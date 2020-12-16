#requires -version 3

Param
(
    [Parameter(Mandatory=$true,
               Position=0,
               ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true,
               HelpMessage="Game name to dl")]
    [ValidateNotNullOrEmpty()]
    [string]
    $name
)

$steamLocation = ".\Steam"

$gameList = Import-Csv .\steamGames.csv
$theGame  = $gameList -match $name

if ( $theGame.Game -match 'css|tf2' )
{
    if ( Test-Path .\steamCreds.ps1 )
    {
        . .\steamCreds.ps1 # This file sets variables $SteamUsername and $SteamPassword
    }
    else
    {
        Write-Error ".\steamCreds.ps1 does not exist"
        New-Item .\steamCreds.ps1 -Type File | Out-Null
        Add-Content .\steamCreds.ps1 -Value "#Steam User Credentials`r`n" -Encoding OEM
        Add-Content .\steamCreds.ps1 -Value "`$SteamUsername = 'Username'" -Encoding OEM
        Add-Content .\steamCreds.ps1 -Value "`$SteamPassword = 'Password'" -Encoding OEM

        Write-Host "Please edit the new steamCreds.ps1 with your Steam Username and Password" -Fore Yellow
        notepad .\steamCreds.ps1
        pause

        Write-Host "Attempting to login to steam with your credentials, if you've setup SteamGuard, it should make a fuss" -Fore Yellow
        & "$SteamLocation\steamcmd.exe" +login $SteamUsername $SteamPassword +quit
        pause
    }

    & "$SteamLocation\steamcmd.exe" +login $SteamUsername $SteamPassword +app_update $($theGame.ID) +quit
}
elseif ( $theGame )
{
    & "$SteamLocation\steamcmd.exe" +login anonymous +app_update $($theGame.ID) +quit
}
else
{
    Write-Error "$name is not a game in the list!"
}