/// @param leaderboardID
/// @param callbackFunction

function __PodiumRegisterPSLeaderboardUser(_leaderboardID, _callbackFunction)
{
    static _asyncIDMap = __PodiumSystem().__psLeaderboardUserMap;
    
    if (_leaderboardID == undefined)
    {
        __PodiumSoftError("Leaderboard ID must be an integer. Please report this error");
        return;
    }
    
    if (not is_callable(_callbackFunction))
    {
        __PodiumSoftError("Callback must be a valid function or script");
        return;
    }
    
    if (ds_map_exists(_asyncIDMap, _callbackFunction))
    {
        __PodiumWarning($"Redefining user score leaderboard ID {_leaderboardID}");
        
        var _oldCallbackFunction = _asyncIDMap[? _leaderboardID];
        _oldCallbackFunction(true);
    }
    
    _asyncIDMap[? _leaderboardID] = _callbackFunction;
}