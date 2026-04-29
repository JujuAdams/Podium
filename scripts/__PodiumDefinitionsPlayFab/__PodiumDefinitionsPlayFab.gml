/// N.B. You must not call `PodiumCreateGeneral()` in this function. Instead, you must call
///      `PodiumCreateForPlayFab()` to create leaderboards for use with Podium.
/// 
/// N.B. Podium does not call `gdk_init()`, `gdk_update()`, or `gdk_quit()` for you when running on
///      Xbox. You must call these functions yourself.
/// 
/// N.B. You must call `PodiumSetXboxUser()` before using PlayFab leaderboards with Xbox.

function __PodiumDefinitionsPlayFab()
{
    PodiumCreateForPlayFab("all time score",  "testDescendingStat", "testDescending");
    PodiumCreateForPlayFab("best time",       "testAscendingStat",  "testAscending" );
    PodiumCreateForPlayFab("daily challenge", "testDailyStat",      "testDaily"     );
}