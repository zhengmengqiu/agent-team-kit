<#
.SYNOPSIS
  按 .code-workspace 中的 agentTeam.version 对齐 kit worktree，并更新 folders 路径。

.PARAMETER WorkspaceFile
  目标 .code-workspace 路径。省略则在当前目录查找唯一的 *.code-workspace。

.EXAMPLE
  .\Sync-AgentTeamWorkspace.ps1 -WorkspaceFile .\develop-project.code-workspace
#>
[CmdletBinding()]
param(
    [string]$WorkspaceFile = ""
)

$ErrorActionPreference = "Stop"

function Resolve-ExistingPath([string]$Path, [string]$BaseDir) {
    if ([System.IO.Path]::IsPathRooted($Path)) {
        return [System.IO.Path]::GetFullPath($Path)
    }
    return [System.IO.Path]::GetFullPath((Join-Path $BaseDir $Path))
}

function Get-RelativePathCompat([string]$FromDir, [string]$ToPath) {
    $from = (Resolve-Path -LiteralPath $FromDir).Path.TrimEnd('\', '/')
    $to = [System.IO.Path]::GetFullPath($ToPath)
    $fromUri = New-Object System.Uri (($from.TrimEnd('\') + '\'))
    $toUri = New-Object System.Uri $to
    $rel = $fromUri.MakeRelativeUri($toUri).ToString()
    return [System.Uri]::UnescapeDataString($rel).Replace('/', '\')
}

function Get-SettingValue($settings, [string]$Name) {
    if ($null -eq $settings) { return $null }
    $prop = $settings.PSObject.Properties[$Name]
    if ($prop) { return [string]$prop.Value }
    return $null
}

if (-not $WorkspaceFile) {
    $found = @(Get-ChildItem -Path (Get-Location) -Filter "*.code-workspace" -File -ErrorAction SilentlyContinue)
    if ($found.Count -eq 0) {
        throw "未指定 -WorkspaceFile，且当前目录无 *.code-workspace"
    }
    if ($found.Count -gt 1) {
        throw "当前目录有多个 .code-workspace，请用 -WorkspaceFile 指定"
    }
    $WorkspaceFile = $found[0].FullName
}

$WorkspaceFile = [System.IO.Path]::GetFullPath($WorkspaceFile)
if (-not (Test-Path -LiteralPath $WorkspaceFile)) {
    throw "工作区文件不存在: $WorkspaceFile"
}

$wsDir = Split-Path -Parent $WorkspaceFile
$raw = Get-Content -LiteralPath $WorkspaceFile -Raw -Encoding UTF8
$jsonText = [regex]::Replace($raw, '(?m)^\s*//.*$', '')
$jsonText = [regex]::Replace($jsonText, '/\*[\s\S]*?\*/', '')
$ws = $jsonText | ConvertFrom-Json

$settings = $ws.settings
if (-not $settings) { throw "工作区缺少 settings" }

$version = Get-SettingValue $settings "agentTeam.version"
$kitRepoRel = Get-SettingValue $settings "agentTeam.kitRepo"
$worktreesRel = Get-SettingValue $settings "agentTeam.worktreesRoot"

if (-not $version) { throw "settings.agentTeam.version 未设置" }
if (-not $kitRepoRel) { $kitRepoRel = "../agent-team-kit" }
if (-not $worktreesRel) { $worktreesRel = "../.agent-team-worktrees" }

$kitRepo = Resolve-ExistingPath $kitRepoRel $wsDir
$worktreesRoot = Resolve-ExistingPath $worktreesRel $wsDir
$wtPath = Join-Path $worktreesRoot $version

if (-not (Test-Path -LiteralPath (Join-Path $kitRepo ".git"))) {
    throw "kit 仓不存在或不是 git 仓库: $kitRepo"
}

Write-Host "kitRepo   = $kitRepo"
Write-Host "version   = $version"
Write-Host "worktree  = $wtPath"

Push-Location $kitRepo
try {
    git fetch --tags --prune 2>&1 | Out-Host
    if ($LASTEXITCODE -ne 0) {
        Write-Host "warn: git fetch 失败，改用本地 tag"
    }
    git show-ref --verify --quiet "refs/tags/$version"
    if ($LASTEXITCODE -ne 0) {
        throw "tag 不存在: $version（请先在 agent-team-kit 打 tag 并 push）"
    }

    if (-not (Test-Path -LiteralPath $wtPath)) {
        New-Item -ItemType Directory -Force -Path $worktreesRoot | Out-Null
        Write-Host "Creating worktree for $version ..."
        git worktree add $wtPath "refs/tags/$version"
        if ($LASTEXITCODE -ne 0) { throw "git worktree add 失败" }
    } else {
        Write-Host "Worktree already exists: $wtPath"
    }
}
finally {
    Pop-Location
}

$folders = @($ws.folders)
if ($folders.Count -eq 0) { throw "工作区 folders 为空" }

$kitFolderIndex = -1
for ($i = 0; $i -lt $folders.Count; $i++) {
    $name = [string]$folders[$i].name
    if ($name -like "agent-team-kit@*") {
        $kitFolderIndex = $i
        break
    }
}
if ($kitFolderIndex -lt 0) {
    for ($i = 0; $i -lt $folders.Count; $i++) {
        $path = [string]$folders[$i].path
        if ($path -match '\.agent-team-worktrees') {
            $kitFolderIndex = $i
            break
        }
    }
}
if ($kitFolderIndex -lt 0) {
    throw "找不到 kit folder：请将 name 设为 agent-team-kit@<version>，或 path 指向 .agent-team-worktrees/<version>"
}

$relWt = (Get-RelativePathCompat $wsDir $wtPath).Replace('\', '/')
$folders[$kitFolderIndex].name = "agent-team-kit@$version"
$folders[$kitFolderIndex].path = $relWt

$folderList = New-Object System.Collections.Generic.List[object]
foreach ($f in $folders) {
    $folderList.Add([ordered]@{
        name = [string]$f.name
        path = [string]$f.path
    }) | Out-Null
}

$settingsOut = [ordered]@{}
foreach ($p in $settings.PSObject.Properties) {
    $settingsOut[$p.Name] = $p.Value
}
$settingsOut["agentTeam.version"] = $version
$settingsOut["agentTeam.kitRepo"] = ($kitRepoRel -replace '\\', '/')
$settingsOut["agentTeam.worktreesRoot"] = ($worktreesRel -replace '\\', '/')

$outObj = [ordered]@{
    folders  = $folderList.ToArray()
    settings = $settingsOut
}
# 保留工作区里 folders/settings 以外的键（如 launch、extensions）
foreach ($p in $ws.PSObject.Properties) {
    if ($p.Name -eq "folders" -or $p.Name -eq "settings") { continue }
    $outObj[$p.Name] = $p.Value
}

$out = $outObj | ConvertTo-Json -Depth 20
[System.IO.File]::WriteAllText($WorkspaceFile, $out + "`n", [System.Text.UTF8Encoding]::new($false))

Write-Host "Updated $WorkspaceFile"
Write-Host "kit folder => $relWt"
Write-Host "Done. 若 Cursor 已打开该工作区，请 Reload Window。"
