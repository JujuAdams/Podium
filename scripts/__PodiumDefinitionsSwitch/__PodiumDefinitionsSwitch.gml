/// You will need to add a category type in the Config page in the NPLN backend.
/// 
/// N.B. You must not call `PodiumCreateGeneral()` in this function. Instead, you must call
///      `PodiumCreateForSwitch()` to create leaderboards for use with Podium.

function __PodiumDefinitionsSwitch()
{
    PodiumCreateForSwitch("all time score",  "testDescending", 0);
    PodiumCreateForSwitch("best time",       "testAscending",  0);
    PodiumCreateForSwitch("daily challenge", "testDaily",      0);
}