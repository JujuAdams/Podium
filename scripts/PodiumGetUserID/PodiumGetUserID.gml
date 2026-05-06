function PodiumGetUserID()
{
    static _system = __PodiumSystem();
    
    if (_system.__local)
    {
        return "PLAYER";
    }
    else if (PODIUM_USING_STEAMWORKS)
    {
        return steam_get_user_steam_id();
    }
    else if (PODIUM_ON_SWITCH)
    {
        return _system.__switchUserID;
    }
    else
    {
        //TODO
        return "";
    }
}