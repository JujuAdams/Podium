function PodiumGetUserName()
{
    static _system = __PodiumSystem();
    
    if (_system.__local)
    {
        return "PLAYER";
    }
    else if (PODIUM_USING_STEAMWORKS)
    {
        return steam_get_persona_name();
    }
    else if (PODIUM_ON_SWITCH)
    {
        return _system.__switchNickname;
    }
    else if (PODIUM_ON_PS5)
    {
        return psn_default_user_name();
    }
    else if (PODIUM_USING_GDK)
    {
        return _system.__xboxModernGamertag;
    }
    else
    {
        //TODO
        return "";
    }
}