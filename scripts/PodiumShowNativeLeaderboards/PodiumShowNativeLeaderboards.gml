function PodiumShowNativeLeaderboards()
{
    if (not PodiumGetNativeLeaderboards())
    {
        __PodiumWarning("This platform/service does not support native leaderboards");
        return;
    }
    
    if (PODIUM_USING_PLAY_SERVICES)
    {
        if (PODIUM_VERBOSE)
        {
            __PodiumTrace("Showing all leaderboards");
        }
        
        GooglePlayServices_Leaderboard_ShowAll();
    }
    else if (PODIUM_USING_GAMECENTER)
    {
        if (PODIUM_VERBOSE)
        {
            __PodiumTrace("Presenting leaderboard view");
        }
        
        GameCenter_PresentView_Leaderboards();
    }
}