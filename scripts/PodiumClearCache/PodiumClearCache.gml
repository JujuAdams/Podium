/// @param leaderboardName
/// @param [range=all]

function PodiumClearCache(_leaderboardName, _range = -1)
{
    if (_range < 0)
    {
        PodiumClearCache(_leaderboardName, PODIUM_RANGE_TOP);
        PodiumClearCache(_leaderboardName, PODIUM_RANGE_AROUND);
        PodiumClearCache(_leaderboardName, PODIUM_RANGE_FRIENDS);
    }
    else
    {
        var _scoresStruct = __PodiumScoresFind(_leaderboardName, _range);
        if (is_struct(_scoresStruct))
        {
            _scoresStruct.__ClearCache();
        }
    }
}