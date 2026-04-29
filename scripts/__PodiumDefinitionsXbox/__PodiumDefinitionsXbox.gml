/// N.B. Podium does not call `gdk_init()`, `gdk_update()`, or `gdk_quit()` for you when running on
///      Xbox. You must call these functions yourself.
/// 
/// N.B. You must call `PodiumSetXboxUser()` before using native Xbox leaderboards.

function __PodiumDefinitionsXbox()
{
    PodiumCreateGeneral("all time score",  "1");
    PodiumCreateGeneral("best time",       "2");
    PodiumCreateGeneral("daily challenge", "3");
}