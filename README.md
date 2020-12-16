# SteamDedicatedServers

## Requirements
- Windows (preferably Windows Server)
- Powershell 5+

## Initial Setup
Get SteamCmd by running `setup.ps1`

(If you don't have powershell execution policy setup for running local scripts, `bootstrap.cmd` will run `setup.ps1` for you)

Download select Steam games using `getSteamGame.ps1`
```
> getSteamGame.ps1 <Game Name>
```
Games the script knows to use are defined in `steamGames.csv`
The script will populate a file `steamCreds.ps1` which you should put in your steam login into. This is needed if a game needs a license to download (some dedicated server software doesn't need a license and can be downloaded with an anonymous steam login).
