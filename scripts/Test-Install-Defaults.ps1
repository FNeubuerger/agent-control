$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Assert-True {
    param([bool]$Condition, [string]$Message)
    if (-not $Condition) { throw $Message }
}

$repository = Split-Path -Parent $PSScriptRoot
$testRoot = Join-Path ([IO.Path]::GetTempPath()) ('agent-control-test-' + [guid]::NewGuid())
$junctions = @()
try {
    $fixture = Join-Path $testRoot 'checkout with spaces'
    $homePath = Join-Path $testRoot 'home'
    $profile = Join-Path $testRoot 'profile'
    New-Item -ItemType Directory -Path $fixture -Force | Out-Null
    foreach ($directory in @('instructions', '.github', 'scripts')) {
        Copy-Item -LiteralPath (Join-Path $repository $directory) -Destination $fixture -Recurse
    }
    $installer = Join-Path $fixture 'scripts\Install-Defaults.ps1'
    $baseline = Join-Path $homePath '.copilot\copilot-instructions.md'
    New-Item -ItemType Directory -Path (Split-Path -Parent $baseline) -Force | Out-Null
    [IO.File]::WriteAllText($baseline, 'Keep my personal preferences.')

    & $installer -HomeDirectory $homePath -VSCodeUserDirectory $profile | Out-Null
    $first = [IO.File]::ReadAllText($baseline)
    Assert-True ($first.StartsWith('Keep my personal preferences.')) 'Personal instructions lost.'
    $junctions = @(Get-ChildItem -LiteralPath $testRoot -Recurse -Force |
        Where-Object { $_.Attributes -band [IO.FileAttributes]::ReparsePoint })
    Assert-True ($junctions.Count -eq 6) 'Expected two instruction and four skill junctions.'
    & $installer -HomeDirectory $homePath -VSCodeUserDirectory $profile | Out-Null
    Assert-True ([IO.File]::ReadAllText($baseline) -ceq $first) 'Second install is not idempotent.'

    $source = Join-Path $fixture 'instructions\quality-hooks.instructions.md'
    [IO.File]::AppendAllText($source, "`r`nLive-update-test.`r`n")
    foreach ($linked in @(
        (Join-Path $homePath '.copilot\instructions\agent-control\quality-hooks.instructions.md'),
        (Join-Path $profile 'prompts\agent-control\quality-hooks.instructions.md')
    )) {
        Assert-True ([IO.File]::ReadAllText($linked).Contains('Live-update-test.')) 'Source edit not visible through linked instructions.'
    }
    $skillSource = Join-Path $fixture '.github\skills\explain-code\SKILL.md'
    [IO.File]::AppendAllText($skillSource, "`r`nLive-skill-test.`r`n")
    foreach ($root in @('.copilot', '.agents')) {
        $linked = Join-Path $homePath "$root\skills\explain-code\SKILL.md"
        Assert-True ([IO.File]::ReadAllText($linked).Contains('Live-skill-test.')) 'Source edit not visible through linked skill.'
    }

    $newSkill = Join-Path $fixture '.github\skills\test-new-skill'
    New-Item -ItemType Directory -Path $newSkill | Out-Null
    [IO.File]::WriteAllText((Join-Path $newSkill 'SKILL.md'), 'New skill fixture.')
    & $installer -HomeDirectory $homePath -VSCodeUserDirectory $profile | Out-Null
    foreach ($root in @('.copilot', '.agents')) {
        $linked = Get-Item -LiteralPath (Join-Path $homePath "$root\skills\test-new-skill")
        Assert-True ($linked.LinkType -eq 'Junction') 'New skill was not linked on reinstall.'
    }

    $conflictHome = Join-Path $testRoot 'conflicting-home'
    $conflict = Join-Path $conflictHome '.copilot\instructions\agent-control'
    New-Item -ItemType Directory -Path $conflict -Force | Out-Null
    $rejected = $false
    try {
        & $installer -HomeDirectory $conflictHome -VSCodeUserDirectory (Join-Path $testRoot 'conflict-profile') | Out-Null
    } catch {
        if ($_.Exception.Message -notlike 'Destination already exists*') { throw }
        $rejected = $true
    }
    Assert-True $rejected 'Conflicting directory was not rejected.'
    Assert-True (-not (Test-Path -LiteralPath (Join-Path $conflictHome '.copilot\copilot-instructions.md'))) 'Conflict created a partial baseline.'

    [IO.File]::WriteAllText($baseline, '<!-- agent-control:start -->')
    $rejected = $false
    try {
        & $installer -HomeDirectory $homePath -VSCodeUserDirectory $profile | Out-Null
    } catch {
        if ($_.Exception.Message -notlike 'Malformed agent-control markers*') { throw }
        $rejected = $true
    }
    Assert-True $rejected 'Malformed baseline markers were not rejected.'
    Write-Output 'PASS: install, repeat install, personal instruction preservation, live instruction and skill updates, new skill installation, conflict refusal, malformed marker refusal.'
} finally {
    # Remove junction entries before cleaning the isolated fixture, never targets.
    if (Test-Path -LiteralPath $testRoot) {
        $junctions = @(Get-ChildItem -LiteralPath $testRoot -Recurse -Force |
            Where-Object { $_.Attributes -band [IO.FileAttributes]::ReparsePoint })
        foreach ($junction in $junctions) {
            [IO.Directory]::Delete($junction.FullName)
        }
        Remove-Item -LiteralPath $testRoot -Recurse -Force
    }
}
