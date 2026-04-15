/// @param leaderboardName

function PodiumLbFind(_leaderboardName)
{
    static _leaderboardDict = __PodiumSystem().__leaderboardDict;
    
    var _struct = _leaderboardDict[$ _leaderboardName];
    if (not is_struct(_struct))
    {
        __PodiumSoftError($"Leaderboard name \"{_leaderboardName}\" not recognised");
        return undefined;
    }
    
    return _struct;
}