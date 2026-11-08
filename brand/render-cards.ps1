<#
.SYNOPSIS
  Renders the social preview cards and LinkedIn banners from cards.json.

.DESCRIPTION
  Each card is drawn as an SVG page (the lockup SVG, the description lines in
  IBM Plex Sans, the URL and the accent bar) and screenshotted by headless
  Microsoft Edge (or Chrome) at its exact size. The PNGs are written next to
  this script. Line breaks are set by hand in cards.json.

.EXAMPLE
  ./render-cards.ps1                              # every card
  ./render-cards.ps1 social-preview-net.png       # just the named ones
#>
param([string[]] $Only)

$ErrorActionPreference = 'Stop'
$brand = $PSScriptRoot
$config = Get-Content (Join-Path $brand 'cards.json') -Raw | ConvertFrom-Json
$font = Join-Path $brand 'web/fonts/IBMPlexSans-Regular-Latin1.woff2'

$browser = @(
  "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
  "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe",
  "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
  "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
) | Where-Object { $_ -and (Test-Path $_) } | Select-Object -First 1
if (-not $browser) { throw 'Needs Microsoft Edge or Google Chrome installed.' }

$work = Join-Path ([IO.Path]::GetTempPath()) 'motif-cards'
New-Item -ItemType Directory -Force $work | Out-Null

function FileUrl([string] $path) { 'file:///' + $path.Replace('\', '/') }
function Esc([string] $text) { [Security.SecurityElement]::Escape($text) }

foreach ($card in $config.cards) {
  if ($Only -and $Only -notcontains $card.file) { continue }
  $l = $config.layouts.($card.layout)
  $t = $config.themes.($card.theme)

  $lockupPath = Join-Path $brand "$($card.lockup)$($t.lockupSuffix).svg"
  $lockupSvg = Get-Content $lockupPath -Raw
  if ($lockupSvg -notmatch 'width="([\d.]+)" height="([\d.]+)"') { throw "No size in $lockupPath" }
  $lockupWidth = [double]$Matches[1] * $l.lockupHeight / [double]$Matches[2]

  # The block (lockup, lines, URL) stays vertically centred: each line past two lifts it by half a line.
  $lines = @($card.lines)
  $lockupTop = $l.lockupTopForTwoLines - ($lines.Count - 2) * $l.lineHeight / 2
  $baseline = $lockupTop + $l.firstBaselineBelowLockupTop

  $texts = for ($i = 0; $i -lt $lines.Count; $i++) {
    "<text x='$($l.textX)' y='$($baseline + $i * $l.lineHeight)' font-size='$($l.fontSize)' fill='$($t.text)'>$(Esc $lines[$i])</text>"
  }
  $urlBaseline = $baseline + ($lines.Count - 1) * $l.lineHeight + $l.urlBaselineBelowLastLine

  $html = @"
<!doctype html><html><head><meta charset="utf-8"><style>
@font-face{font-family:Plex;font-weight:400;src:url('$(FileUrl $font)') format('woff2')}
html,body{margin:0;background:$($t.background);overflow:hidden}
</style></head><body>
<svg xmlns="http://www.w3.org/2000/svg" width="$($l.width)" height="$($l.height)" style="display:block;font-family:Plex">
<image href="$(FileUrl $lockupPath)" x="$($l.lockupX)" y="$lockupTop" width="$lockupWidth" height="$($l.lockupHeight)"/>
$($texts -join "`n")
<text x='$($l.textX)' y='$urlBaseline' font-size='$($l.urlSize)' fill='$($t.muted)'>$(Esc $card.url)</text>
<rect x="0" y="$($l.height - $l.barHeight)" width="$($l.width)" height="$($l.barHeight)" fill="$($t.bar)"/>
</svg></body></html>
"@
  $page = Join-Path $work ($card.file -replace '\.png$', '.html')
  Set-Content -Path $page -Value $html -Encoding UTF8

  $out = Join-Path $brand $card.file
  $arguments = @(
    '--headless=new', '--disable-gpu', '--hide-scrollbars', '--force-device-scale-factor=1',
    '--allow-file-access-from-files', "--user-data-dir=$work\profile",
    "--window-size=$($l.width),$($l.height)", "--screenshot=$out", (FileUrl $page)
  )
  Start-Process -FilePath $browser -ArgumentList $arguments -Wait -WindowStyle Hidden
  if (-not (Test-Path $out)) { throw "Rendering $($card.file) failed." }
  Write-Host "Rendered $($card.file)"
}
