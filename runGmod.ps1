#requires -version 3

Param
(
    [Parameter(Position=0,
               ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true,
               HelpMessage="update too")]
    [ValidateNotNullOrEmpty()]
    [switch]
    $update = $false
)

$GamesLocation = "\Games"
$SteamLocation = "$GamesLocation\Steam"
$GmodLocation  = "$SteamLocation\steamapps\common\GarrysModDS"
$Srcds         = "$GmodLocation\srcds.exe"

# SRCDS Update ---------------------------------------------------------------------------------------------------------

if ( $update )
{
    Write-Host "Updating Gmod ..." -Fore Cyan
    ./getSteamGame.ps1 'gmod-ds'

    Write-Host "Updating CS:S ..." -Fore Cyan
    ./getSteamGame.ps1 'css-ds'
}

# SRCDS Arguments ------------------------------------------------------------------------------------------------------

# Get $GmodToken from file
# This should be the token created here: https://steamcommunity.com/dev/managegameservers
if ( Test-Path .\gmodCreds.ps1 )
{
    . .\gmodCreds.ps1 # This file sets variable $GmodToken
}
else
{
    Write-Error ".\gmodCreds.ps1 does not exist"
    New-Item .\gmodCreds.ps1 -Type File | Out-Null
    Add-Content .\gmodCreds.ps1 -Value "#Gmod Server Token`r`n" -Encoding OEM
    Add-Content .\gmodCreds.ps1 -Value "`$GmodToken = 'Token'" -Encoding OEM

    Write-Host "Please edit the new gmodCreds.ps1 with your server token" -Fore Yellow
    Write-Host "If you don't want to use a token, keep the file blank" -Fore Yellow
    notepad .\gmodCreds.ps1
    explorer 'https://steamcommunity.com/dev/managegameservers'
    pause
    . .\gmodCreds.ps1
}


# Build cmdline arguments for srcds.exe
$SrcdsArgs = @( "-game" , "garrysmod" , "-console" , "+maxplayers" , "20" , "-tickrate" , "100" )

# Set server token, if you have it
if ( $GmodToken )
{
    $SrcdsArgs += @( "+sv_setsteamaccount" , $GmodToken )
}

# Workshop items
# Set as you please, 1190472924 is mine for TTT
$WSCollection = "1190472924"
$SrcdsArgs += @( "+host_workshop_collection" , $WSCollection )

# Gamemode
$SrcdsArgs += @( "+gamemode" , "terrortown" , "+map" , "ttt_foundation_a1" )

# Server Start ---------------------------------------------------------------------------------------------------------

Write-Host "Starting Gmod Server ..." -Fore Green
try
{
    & $Srcds $SrcdsArgs
}
finally
{
    #Write-Host "Server Offline!" -Fore Red
}