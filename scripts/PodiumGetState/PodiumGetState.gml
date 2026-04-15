/// @param leaderboardName

function PodiumGetState(_leaderboardName)
{
    with(PodiumFind(_leaderboardName))
    {
        return __state;
    }
    
    return PODIUM_STATE_UNKNOWN;
}