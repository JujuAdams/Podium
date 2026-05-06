/// @param leaderboardName
/// @param range
/// @param [seasonOffset=0]

function PodiumGetScoreState(_leaderboardName, _range, _seasonOffset)
{
    if (PodiumGetLeaderboardDisabled(_leaderboardName))
    {
        return PODIUM_LEADERBOARD_NULL;
    }
    
    var _scoresStruct = __PodiumScoreCacheFind(_leaderboardName, _range, _seasonOffset);
    return is_struct(_scoresStruct)? _scoresStruct.__GetState() : PODIUM_LEADERBOARD_NULL;
}