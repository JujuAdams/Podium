function __PodiumDefinitionsPlayFab()
{
    PodiumCreate("testLeaderboard",       "testLeaderboard");
    PodiumCreate("testHourlyLeaderboard", "testHourlyLeaderboard", true);
    PodiumCreate("testDailyLeaderboard",  "testDailyLeaderboard", true, PODIUM_REFRESH_DAILY);
}