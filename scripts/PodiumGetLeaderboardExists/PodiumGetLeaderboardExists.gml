/// @param leaderboardName

function PodiumGetLeaderboardExists(_leaderboardName)
{
    static _leaderboardDict = __PodiumSystem().__leaderboardDict;
    return struct_exists(_leaderboardDict, _leaderboardName);
}