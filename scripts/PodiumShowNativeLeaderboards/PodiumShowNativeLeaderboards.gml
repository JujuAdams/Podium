function PodiumShowNativeLeaderboards()
{
    if (not PodiumGetNativeLeaderboards())
    {
        __PodiumWarning("This platform/service does not support native leaderboards");
        return;
    }
    
    if (PODIUM_USING_PLAY_SERVICES)
    {
        GooglePlayServices_Leaderboard_ShowAll();
    }
}