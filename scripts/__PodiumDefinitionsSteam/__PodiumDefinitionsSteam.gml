function __PodiumDefinitionsSteam()
{
    PodiumCreate("all time score", "testBestScore");
    PodiumCreate("best time", "testBestTime", false);
    PodiumCreate("daily challenge", "testDaily", true, PODIUM_REFRESH_DAILY);
}