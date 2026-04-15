/// N.B. You must call `PodiumSetPSGamepad()` or `PodiumSetXboxUser()` before getting scores from
///      leaderboards on PlayStation or Xbox.
/// 
/// N.B. Podium does not call `steam_update()` for you when using Steam. You must call this function
///      yourself.
/// 
/// N.B. Podium does not call `psn_tick()` or `psn_init_leaderboard()` for you when running on
///      PlayStation. You must call these functions yourself.
/// 
/// N.B. Podium does not call `gdk_init()`, `gdk_update()`, or `gdk_quit()` for you when running on
///      Xbox. You must call these functions yourself.
///
/// @param leaderboardName
/// @param [range=top]

function PodiumLbGetScores(_leaderboardName, _range = PODIUM_RANGE_TOP)
{
    with(PodiumLbFind(_leaderboardName))
    {
        return GetScores(_range);
    }
    
    return undefined;
}