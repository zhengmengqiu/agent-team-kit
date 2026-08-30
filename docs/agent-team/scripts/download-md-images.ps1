# 从 Markdown 批量下载图片并替换为本地相对路径
# 用法：
#   .\download-md-images.ps1 -MarkdownFile "D:\path\prd-from-feishu.md" -OutputDir "D:\path\input\images" -RewriteMarkdown "D:\path\input\prd.md"
#
# 参数：
#   -MarkdownFile      源 MD（含 ![alt](url)）
#   -OutputDir         图片输出目录（不存在则创建）
#   -RewriteMarkdown   可选；写出替换内链后的 MD（prd.md）
#   -MapFile           可选；URL→本地路径映射 JSON，默认 OutputDir/image-url-map.json

param(
    [Parameter(Mandatory = $true)]
    [string]$MarkdownFile,

    [Parameter(Mandatory = $true)]
    [string]$OutputDir,

    [string]$RewriteMarkdown = "",

    [string]$MapFile = ""
)

$ErrorActionPreference = "Stop"

function ConvertTo-Slug {
    param([string]$Text, [int]$MaxLen = 40)
    if ([string]::IsNullOrWhiteSpace($Text)) { return "image" }
    $slug = $Text.Trim().ToLower()
    $slug = $slug -replace '\s+', '-'
    $slug = $slug -replace '[^\w\u4e00-\u9fff\-]', ''
    if ($slug.Length -gt $MaxLen) { $slug = $slug.Substring(0, $MaxLen) }
    if ([string]::IsNullOrWhiteSpace($slug)) { return "image" }
    return $slug
}

function Get-ImageExtension {
    param([string]$Url, [string]$ContentType)
    if ($ContentType -match 'image/png') { return '.png' }
    if ($ContentType -match 'image/jpeg|image/jpg') { return '.jpg' }
    if ($ContentType -match 'image/gif') { return '.gif' }
    if ($ContentType -match 'image/webp') { return '.webp' }
    if ($ContentType -match 'image/svg') { return '.svg' }
    $path = ([Uri]$Url).AbsolutePath
    $ext = [System.IO.Path]::GetExtension($path)
    if ($ext -match '^\.(png|jpe?g|gif|webp|svg)$') { return $ext.ToLower() }
    return '.png'
}

if (-not (Test-Path $MarkdownFile)) {
    Write-Error "Markdown 文件不存在: $MarkdownFile"
}

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

$content = Get-Content -Path $MarkdownFile -Raw -Encoding UTF8
$pattern = '!\[([^\]]*)\]\((https?://[^)\s]+)\)'
$matches = [regex]::Matches($content, $pattern)

$map = @()
$index = 0
$success = 0
$failed = 0

foreach ($m in $matches) {
    $index++
    $alt = $m.Groups[1].Value
    $url = $m.Groups[2].Value
    $slug = ConvertTo-Slug -Text $alt
    $seq = '{0:D2}' -f $index
    $localName = "$seq-$slug"
    $localPath = Join-Path $OutputDir "$localName.tmp"
    $finalPath = $null
    $status = "failed"
    $errorMsg = ""

    try {
        $response = Invoke-WebRequest -Uri $url -Method Get -UseBasicParsing -TimeoutSec 60
        $ext = Get-ImageExtension -Url $url -ContentType $response.Headers['Content-Type']
        $finalPath = Join-Path $OutputDir "$localName$ext"
        [System.IO.File]::WriteAllBytes($finalPath, $response.Content)
        $status = "ok"
        $success++

        # 相对路径：假定 RewriteMarkdown 在 input/ 下，images 在 input/images/
        $relativePath = "./images/$localName$ext"
        $old = $m.Value
        $new = "![$alt]($relativePath)"
        $content = $content.Replace($old, $new)
    }
    catch {
        $errorMsg = $_.Exception.Message
        $failed++
        if (Test-Path $localPath) { Remove-Item $localPath -Force -ErrorAction SilentlyContinue }
    }

    $map += [ordered]@{
        index    = $index
        alt      = $alt
        url      = $url
        local    = if ($finalPath) { $finalPath.Replace('\', '/') } else { $null }
        relative = if ($finalPath) { "./images/$(Split-Path -Leaf $finalPath)" } else { $null }
        status   = $status
        error    = $errorMsg
    }
}

if ([string]::IsNullOrWhiteSpace($MapFile)) {
    $MapFile = Join-Path $OutputDir "image-url-map.json"
}
$map | ConvertTo-Json -Depth 5 | Set-Content -Path $MapFile -Encoding UTF8

if ($RewriteMarkdown) {
    $rewriteDir = Split-Path -Parent $RewriteMarkdown
    if ($rewriteDir -and -not (Test-Path $rewriteDir)) {
        New-Item -ItemType Directory -Force -Path $rewriteDir | Out-Null
    }
    Set-Content -Path $RewriteMarkdown -Value $content -Encoding UTF8
}

Write-Host "扫描图片链接: $($matches.Count)  成功: $success  失败: $failed"
Write-Host "映射文件: $MapFile"
if ($RewriteMarkdown) { Write-Host "已写出 MD: $RewriteMarkdown" }

if ($failed -gt 0) {
    Write-Host "失败项见 image-url-map.json 中 status=failed（常见：飞书内链需登录/过期）" -ForegroundColor Yellow
    exit 2
}
exit 0
