/// @param leaderboardName
/// @param [priority=normal]

function PodiumGetUserScore(_leaderboardName, _priority = PODIUM_PRIORITY_NORMAL)
{
    return PodiumGetScores(_leaderboardName, __PODIUM_RANGE_USER, _priority);
}