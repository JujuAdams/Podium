/// @param leaderboardName
/// @param [range=top]

function PodiumGetState(_leaderboardName, _range = PODIUM_RANGE_TOP)
{
    with(PodiumFind(_leaderboardName))
    {
        return GetState(_range);
    }
    
    return PODIUM_STATE_UNKNOWN;
}