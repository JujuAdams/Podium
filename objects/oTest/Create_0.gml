gamepad = -1;

if (PODIUM_ON_XBOX_SERIES)
{
    var _activatingUser = xboxone_get_activating_user();
    if (_activatingUser != 0)
    {
        PodiumSetXboxUser(_activatingUser);
    }
}

playFabLoggedIn = false;