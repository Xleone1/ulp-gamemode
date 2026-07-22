param(
    [switch]$Push
)

$Root = $PSScriptRoot
$PawnCC = Join-Path $Root "qawno\pawncc.exe"
$Includes = Join-Path $Root "qawno\include"

Write-Host "=== Compilando gamemodes/main.pwn ==="
& $PawnCC (Join-Path $Root "gamemodes\main.pwn") "-o$(Join-Path $Root 'gamemodes\main.amx')" "-i$Includes"
if ($LASTEXITCODE -ne 0) { Write-Host "Error compilando main.pwn"; exit 1 }

$Filterscripts = Join-Path $Root "filterscripts"
if (Test-Path $Filterscripts) {
    Get-ChildItem "$Filterscripts\*.pwn" | ForEach-Object {
        $out = [System.IO.Path]::ChangeExtension($_.FullName, ".amx")
        Write-Host "Compilando $($_.Name)"
        & $PawnCC $_.FullName "-o$out" "-i$Includes"
        if ($LASTEXITCODE -ne 0) { Write-Host "Error compilando $($_.Name)"; exit 1 }
    }
}

if ($Push) {
    Write-Host "=== Commit & Push .amx files ==="
    git -C $Root add "*.amx"
    git -C $Root commit -m "compiled .amx files"
    git -C $Root push
} else {
    Write-Host "=== Build Docker ==="
    docker compose build
}
