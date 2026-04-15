function __PodiumDefinitionsGameCenter()
{
    PodiumCreate("all time score", "all time score");
    PodiumCreate("best time", "best time", false);
    PodiumCreate("daily challenge", "daily", true, PODIUM_REFRESH_DAILY);
}