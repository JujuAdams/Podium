/// @param leaderboardName
/// @param [range=top]

function PodiumGetCached(_leaderboardName, _range = PODIUM_RANGE_TOP)
{
    var _scoresStruct = __PodiumScoresFind(_leaderboardName, _range);
    return is_struct(_scoresStruct)? _scoresStruct.__GetCachedScores() : false;
}