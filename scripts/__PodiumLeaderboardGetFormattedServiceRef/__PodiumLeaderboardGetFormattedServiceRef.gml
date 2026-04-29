/// @param leaderboardName

function __PodiumLeaderboardGetFormattedServiceRef(_leaderboardName)
{
    var _leaderboard = __PodiumLeaderboardFind(_leaderboardName);
    if (_leaderboard == undefined)
    {
        __PodiumError($"Could not find leaderboard \"{_leaderboardName}\"");
    }
    
    return _leaderboard.__GetFormattedServiceRef();
}