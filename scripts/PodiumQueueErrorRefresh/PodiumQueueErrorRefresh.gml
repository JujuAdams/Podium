/// @param leaderboardName
/// @param range
/// @param [seasonOffset=0]

function PodiumQueueErrorRefresh(_leaderboardName, _range, _seasonOffset)
{
    var _scoresStruct = __PodiumScoreCacheFind(_leaderboardName, _range, _seasonOffset);
    if (is_struct(_scoresStruct))
    {
        _scoresStruct.__QueueErrorRefresh();
    }
}