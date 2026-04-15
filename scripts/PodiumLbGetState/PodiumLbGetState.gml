/// @param leaderboardName

function PodiumLbGetState(_leaderboardName)
{
    with(PodiumLbFind(_leaderboardName))
    {
        return __state;
    }
    
    return PODIUM_STATE_UNKNOWN;
}