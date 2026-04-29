/// N.B. You must not call `PodiumCreateGeneral()` in this function. Instead, you must call
///      `PodiumCreateForLocal()` to create leaderboards for use with Podium.

function __PodiumDefinitionsLocal()
{
    PodiumCreateForLocal("all time score",  true);
    PodiumCreateForLocal("best time",       false);
    PodiumCreateForLocal("daily challenge", true);
}