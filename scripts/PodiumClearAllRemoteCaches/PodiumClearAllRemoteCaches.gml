/// @param leaderboardName

function PodiumClearAllRemoteCaches(_leaderboardName)
{
    var _leaderboardStruct = __PodiumLeaderboardFind(_leaderboardName);
    if (is_struct(_leaderboardStruct))
    {
        _leaderboardStruct.__ClearAllCaches();
    }
}