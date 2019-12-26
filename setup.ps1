#requires -version 3

$SteamUrl = 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip'
$SteamZip = Split-Path $SteamURL -Leaf

Push-Location

If ( -Not ( Test-Path Steam\steamcmd.exe ) )
{
    If ( -Not ( Test-Path Steam ) )     { New-Item Steam -Type Directory -Force | Out-Null }
    cd Steam

    If ( -Not ( Test-Path $SteamZip ) ) { Start-BitsTransfer $SteamUrl }
    Expand-Archive $SteamZip -DestinationPath .

    Write-Host 'SteamCMD first time startup' -Fore Yellow
    .\steamcmd.exe +login anonymous +quit
    Write-Host 'SteamCMD setup complete' -Fore Cyan
}

Pop-Location
