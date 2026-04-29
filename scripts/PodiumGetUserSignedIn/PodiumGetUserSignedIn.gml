function PodiumGetUserSignedIn()
{
    static _system = __PodiumSystem();
    
    if (_system.__steamAvailable)
    {
        return true;
    }
    else if (PODIUM_USING_PLAYFAB_LEADERBOARDS)
    {
        return _system.__playFabLoggedIn;
    }
    else if (PODIUM_USING_XBOX_LEADERBOARDS)
    {
        return ((_system.__xboxUser != 0) && xboxone_user_is_signed_in(_system.__xboxUser));
    }
    else if (PODIUM_ON_PS5)
    {
        return (_system.__psGamepad >= 0);
    }
    else if (PODIUM_ON_SWITCH)
    {
        return ((_system.__switchNPLNUserHandle != undefined) && (_system.__switchNPLNUserHandle > 0));
    }
    else if (_system.__local)
    {
        return true;
    }
    else
    {
        return false;
    }
}