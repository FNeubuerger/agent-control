[CmdletBinding()]
param(
    [string]$HomeDirectory = $HOME,
    [string]$VSCodeUserDirectory = (Join-Path $env:APPDATA 'Code\User')
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

if ($env:OS -ne 'Windows_NT') {
    throw 'This installer uses Windows directory junctions. See the README for platform scope.'
}

$repository = Split-Path -Parent $PSScriptRoot
$instructions = Join-Path $repository 'instructions'
$skills = Join-Path $repository '.github\skills'
$copilot = Join-Path $HomeDirectory '.copilot'
$baseline = Join-Path $copilot 'copilot-instructions.md'
$start = '<!-- agent-control:start -->'
$end = '<!-- agent-control:end -->'
$block = @"
$start
Read and follow the [agent-control engineering defaults](./instructions/agent-control/engineering-defaults.instructions.md)
and the guidance linked there for coding, documentation, and project-local quality hooks.
The linked checkout is the source of truth; do not copy its policy into this file.
$end
"@

$links = @(
    @{
        Path = Join-Path $copilot 'instructions\agent-control'
        Target = $instructions
    },
    @{
        Path = Join-Path $VSCodeUserDirectory 'prompts\agent-control'
        Target = $instructions
    }
)
foreach ($skill in Get-ChildItem -LiteralPath $skills -Directory) {
    foreach ($root in @(
        (Join-Path $copilot 'skills'),
        (Join-Path $HomeDirectory '.agents\skills')
    )) {
        $links += @{ Path = Join-Path $root $skill.Name; Target = $skill.FullName }
    }
}

# Preflight everything before writing, so conflicts do not cause a partial install.
foreach ($link in $links) {
    if (-not (Test-Path -LiteralPath $link.Target -PathType Container)) {
        throw "Source directory missing: $($link.Target)"
    }
    $item = Get-Item -LiteralPath $link.Path -Force -ErrorAction SilentlyContinue
    if ($null -ne $item) {
        if ($item.LinkType -ne 'Junction' -or
            [IO.Path]::GetFullPath([string]$item.Target[0]).TrimEnd('\') -ine
            [IO.Path]::GetFullPath($link.Target).TrimEnd('\')) {
            throw "Destination already exists and is not the expected junction: $($link.Path). Move it aside explicitly before retrying."
        }
    }
}

$existing = ''
if (Test-Path -LiteralPath $baseline) {
    $item = Get-Item -LiteralPath $baseline -Force
    if ($item.PSIsContainer -or $item.LinkType) {
        throw "Expected a regular instruction file: $baseline"
    }
    $existing = [IO.File]::ReadAllText($baseline)
}
$startCount = [regex]::Matches($existing, [regex]::Escape($start)).Count
$endCount = [regex]::Matches($existing, [regex]::Escape($end)).Count
$pattern = '(?s)' + [regex]::Escape($start) + '.*?' + [regex]::Escape($end)
if ($startCount -gt 1 -or $endCount -gt 1 -or $startCount -ne $endCount -or
    ($startCount -eq 1 -and -not [regex]::IsMatch($existing, $pattern))) {
    throw "Malformed agent-control markers in $baseline. Repair them before retrying."
}
if ($startCount -eq 1) {
    $updated = [regex]::Replace($existing, $pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($match) $block })
} elseif ($existing.Length -gt 0) {
    $updated = $existing.TrimEnd() + "`r`n`r`n" + $block + "`r`n"
} else {
    $updated = $block + "`r`n"
}

foreach ($link in $links) {
    if ($null -eq (Get-Item -LiteralPath $link.Path -Force -ErrorAction SilentlyContinue)) {
        New-Item -ItemType Directory -Path (Split-Path -Parent $link.Path) -Force | Out-Null
        New-Item -ItemType Junction -Path $link.Path -Target $link.Target | Out-Null
    }
}
if ($updated -cne $existing) {
    [IO.File]::WriteAllText($baseline, $updated, [Text.UTF8Encoding]::new($false))
}

Write-Output "Installed live defaults from $repository"
Write-Output "VS Code profile: $VSCodeUserDirectory"
Write-Output 'Existing personal instructions outside the managed block are preserved.'
Write-Output 'Start a fresh chat and verify discovery in Chat: Open Customizations.'
