/// N.B. Podium does not call `psn_tick()` for you when running on PlayStation. You must call this
///      function yourself.
/// 
/// N.B. You must call `PodiumSetPSGamepad()` before using PlayStation leaderboards.

function __PodiumDefinitionsPlayStation()
{
    PodiumCreateGeneral("all time score",  0);
    PodiumCreateGeneral("best time",       1);
    PodiumCreateGeneral("daily challenge", 2);
}