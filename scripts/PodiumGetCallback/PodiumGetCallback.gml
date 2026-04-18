/// Returns the callback set for the particular leaderboard range. If no callback has been set then
/// this function returns `undefined`.
/// 
/// @param leaderboardName
/// @param [range=top]

function PodiumGetCallback(_leaderboardName, _range = PODIUM_RANGE_TOP)
{
    with(PodiumFind(_leaderboardName))
    {
        GetCallback(_range);
    }
}