/// @param leaderboardName

function PodiumGetLeaderboardDisabled(_leaderboardName)
{
    static _system = __PodiumSystem();
    
    if (PodiumGetOfflineOnly())
    {
        return false;
    }
    else
    {
        var _leaderboardStruct = __PodiumLeaderboardFind(_leaderboardName);
        if (_leaderboardStruct == undefined)
        {
            return true;
        }
        
        var _serviceData = _leaderboardStruct.__serviceData;
        
        if (PODIUM_USING_STEAMWORKS)
        {
            return (_serviceData[$ "steam"] == undefined);
        }
        else if (PODIUM_ON_SWITCH_X)
        {
            return (_serviceData[$ "switch"] == undefined);
        }
        else if (PODIUM_ON_PS5)
        {
            return (_serviceData[$ "playStation"] == undefined);
        }
        else if (PODIUM_USING_XBOX_LEADERBOARDS)
        {
            return (_serviceData[$ "xbox"] == undefined);
        }
        else if (PODIUM_USING_PLAYFAB_LEADERBOARDS)
        {
            return (_serviceData[$ "playFab"] == undefined);
        }
        else if (PODIUM_USING_GAMECENTER)
        {
            return (_serviceData[$ "gameCenter"] == undefined);
        }
        else if (PODIUM_USING_PLAY_SERVICES)
        {
            return (_serviceData[$ "playServices"] == undefined);
        }
        else
        {          
            return true;
        }
    }
}