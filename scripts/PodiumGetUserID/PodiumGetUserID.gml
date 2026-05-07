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
        return psn_user_for_pad(_system.__psGamepad);
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
    else
    {
        //TODO
        return undefined;
    }
}