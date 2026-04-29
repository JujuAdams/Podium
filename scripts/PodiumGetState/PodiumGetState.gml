/// @param leaderboardName
/// @param [range=top]

function PodiumGetState(_leaderboardName, _range = PODIUM_RANGE_TOP)
{
    var _scoresStruct = __PodiumScoresFind(_leaderboardName, _range);
    return is_struct(_scoresStruct)? _scoresStruct.__GetState() : PODIUM_STATE_UNKNOWN;
}