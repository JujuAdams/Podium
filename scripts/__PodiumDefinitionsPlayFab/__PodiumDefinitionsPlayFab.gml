function __PodiumDefinitionsPlayFab()
{
    PodiumCreate("all time score",  "testDescending");
    PodiumCreate("best time",       "testAscending", false);
    PodiumCreate("daily challenge", "testDaily", true, PODIUM_REFRESH_DAILY);
}