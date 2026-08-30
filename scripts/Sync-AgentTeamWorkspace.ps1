<#
.SYNOPSIS
  按 .code-workspace 中的 agentTeam.version 对齐 kit worktree，并更新 folders 路径。

.DESCRIPTION
  1. 读取工作区 settings.agentTeam.version / agentTeam.kitRepo / agentTeam.worktreesRoot
  2. fetch tags；若无对应 worktree 则 git worktree add
  3. 将名为 agent-team-kit@* 或 path 指向 worktrees 的 folder 更新为该版本路径

.PARAMETER WorkspaceFile
  目标 .code-workspace 绝对或相对路径。省略则在当前目录查找 *.code-workspace。

.EXAMPLE
  .\Sync-AgentTeamWorkspace.ps1 -WorkspaceFile ..\spring-ai-study\spring-ai-study.code-workspace
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

if (-not $WorkspaceFile) {
    $found = Get-ChildItem -Path (Get-Location) -Filter "*.code-workspace" -File -ErrorAction SilentlyContinue
    if (-not $found -or $found.Count -eq 0) {
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
# VS Code 允许 JSONC（注释）；去掉 // 与 /* */ 以便 ConvertFrom-Json
$jsonText = [regex]::Replace($raw, '(?m)^\s*//.*$', '')
$jsonText = [regex]::Replace($jsonText, '/\*[\s\S]*?\*/', '')
$ws = $jsonText | ConvertFrom-Json

if (-not $ws.settings) {
    throw "工作区缺少 settings"
}
$version = [string]$ws.settings.'agentTeam.version'
$kitRepoRel = [string]$ws.settings.'agentTeam.kitRepo'
$worktreesRel = [string]$ws.settings.'agentTeam.worktreesRoot'

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
    $tagOk = git rev-parse -q --verify "refs/tags/$version" 2>$null
    if (-not $tagOk) {
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

# 更新 folders：优先匹配 name agent-team-kit@* 或 path 含 .agent-team-worktrees
$folders = @($ws.folders)
if ($folders.Count -eq 0) { throw "工作区 folders 为空" }

$kitFolderIndex = -1
for ($i = 0; $i -lt $folders.Count; $i++) {
    $name = [string]$folders[$i].name
    $path = [string]$folders[$i].path
    if ($name -like "agent-team-kit@*" -or $path -match '\.agent-team-worktrees|agent-team-kit') {
        if ($name -like "agent-team-kit@*" -or $path -match '\.agent-team-worktrees') {
            $kitFolderIndex = $i
            break
        }
        if ($kitFolderIndex -lt 0) { $kitFolderIndex = $i }
    }
}
if ($kitFolderIndex -lt 0) { $kitFolderIndex = 0 }

# 工作区相对路径
$relWt = (Get-RelativePathCompat $wsDir $wtPath).Replace('\', '/')
$folders[$kitFolderIndex].name = "agent-team-kit@$version"
$folders[$kitFolderIndex].path = $relWt
$ws.folders = $folders
$ws.settings.'agentTeam.version' = $version
$ws.settings.'agentTeam.kitRepo' = ($kitRepoRel -replace '\\', '/')
$ws.settings.'agentTeam.worktreesRoot' = ($worktreesRel -replace '\\', '/')

$out = $ws | ConvertTo-Json -Depth 20
[System.IO.File]::WriteAllText($WorkspaceFile, $out + "`n", [System.Text.UTF8Encoding]::new($false))

Write-Host "Updated $WorkspaceFile"
Write-Host "kit folder => $relWt"
Write-Host "Done. 若 Cursor 已打开该工作区，请 Reload Window 以加载新路径。"
