/// @param leaderboardName
/// @param [range=all]
/// @param [seasonOffset=0]

function PodiumClearRemoteCache(_leaderboardName, _range = -1, _seasonOffset)
{
    if (_range < 0)
    {
        PodiumClearRemoteCache(_leaderboardName, PODIUM_RANGE_TOP,     _seasonOffset);
        PodiumClearRemoteCache(_leaderboardName, PODIUM_RANGE_AROUND,  _seasonOffset);
        PodiumClearRemoteCache(_leaderboardName, PODIUM_RANGE_FRIENDS, _seasonOffset);
        PodiumClearRemoteCache(_leaderboardName, PODIUM_RANGE_USER,    _seasonOffset);
    }
    else
    {
        var _scoresStruct = __PodiumScoreCacheFind(_leaderboardName, _range, _seasonOffset);
        if (is_struct(_scoresStruct))
        {
            _scoresStruct.__ClearCache();
        }
    }
}