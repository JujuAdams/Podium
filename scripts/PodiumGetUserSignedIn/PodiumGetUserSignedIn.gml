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
        if (PODIUM_ON_XBOX_SERIES)
        {
            return ((_system.__xboxUser != 0) && xboxone_user_is_signed_in(_system.__xboxUser));
        }
        else if (PODIUM_ON_WINDOWS)
        {
            return (_system.__xboxUser != 0);
        }
    }
    else if (PODIUM_ON_PS5)
    {
        return (_system.__psGamepad >= 0);
    }
    else if (PODIUM_ON_SWITCH)
    {
        return is_struct(_system.__switchNPLNUserHandle);
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