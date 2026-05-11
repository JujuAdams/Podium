function PodiumGetUserID()
{
    static _system = __PodiumSystem();
    
    if (PodiumGetOfflineOnly())
    {
        return "Player";
    }
    else if (PODIUM_USING_STEAMWORKS)
    {
        return steam_get_user_steam_id();
    }
    else if (PODIUM_ON_SWITCH)
    {
        return _system.__switchUserID;
    }
    else if (PODIUM_ON_PS5)
    {
        // N.B. User ID on leaderboards seems to be the same as the username rather than the user ID
        //      We'll return the more useful value here to avoid branching when doing ID checks downstream
        return _system.__username;
    }
    else if (PODIUM_USING_PLAYFAB_LEADERBOARDS)
    {
        return _system.__playFabEntityID;
    }
    else if (PODIUM_USING_XBOX_LEADERBOARDS)
    {
        return _system.__xboxUser;
    }
    else if (PODIUM_PLAY_SERVICES_AVAILABLE)
    {
        return _system.__playServicesID;
    }
    else if (PODIUM_USING_GAMECENTER)
    {
        return _system.__gameCenterPlayerID;
    }
    else
    {
        //TODO
        return undefined;
    }
}