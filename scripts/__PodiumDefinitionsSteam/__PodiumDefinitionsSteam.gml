function __PodiumDefinitionsSteam()
{
    PodiumLbCreate("all time score", "all time score");
    PodiumLbCreate("best time", "best time", false);
    PodiumLbCreate("daily challenge", "daily", true, PODIUM_REFRESH_DAILY);
}