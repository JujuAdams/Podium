/// @param leaderboardName
/// @param range
/// @param [seasonOffset=0]

function PodiumGetCacheTime(_leaderboardName, _range, _seasonOffset)
{
    if (PodiumGetLeaderboardDisabled(_leaderboardName))
    {
        return 0;
    }
    
    var _scoresStruct = __PodiumScoreCacheFind(_leaderboardName, _range, _seasonOffset);
    return is_struct(_scoresStruct)? _scoresStruct.__GetReceivedTime() : 0;
}