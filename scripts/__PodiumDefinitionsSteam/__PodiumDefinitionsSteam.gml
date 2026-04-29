/// N.B. You must not call `PodiumCreateGeneral()` in this function. Instead, you must call
///      `PodiumCreateForSteam()` to create leaderboards for use with Podium.
/// 
/// N.B. Podium does not call `steam_update()` for you when using Steam. You must call this function
///      yourself.

function __PodiumDefinitionsSteam()
{
    PodiumCreateForSteam("all time score",  "testBestScore", true,  lb_disp_numeric);
    PodiumCreateForSteam("best time",       "testBestTime",  false, lb_disp_numeric);
    PodiumCreateForSteam("daily challenge", "testDaily",     true,  lb_disp_numeric, PODIUM_REFRESH_DAILY);
}