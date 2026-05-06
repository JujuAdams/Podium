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
    else if (PODIUM_USING_GDK)
    {
        return _system.__xboxUser;
    }
    else
    {
        //TODO
        return undefined;
    }
}