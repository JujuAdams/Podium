function __PodiumDefinitionsPlayFab()
{
    PodiumLbCreate("testLeaderboard",       "testLeaderboard");
    PodiumLbCreate("testHourlyLeaderboard", "testHourlyLeaderboard", true);
    PodiumLbCreate("testDailyLeaderboard",  "testDailyLeaderboard", true, PODIUM_REFRESH_DAILY);
}