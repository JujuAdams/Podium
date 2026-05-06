/// @param leaderboardName
/// @param range
/// @param [seasonOffset=0]

function PodiumClearRemoteCache(_leaderboardName, _range, _seasonOffset = 0)
{
    var _scoresStruct = __PodiumScoreCacheFind(_leaderboardName, _range, _seasonOffset);
    if (is_struct(_scoresStruct))
    {
        _scoresStruct.__ClearCache();
    }
}