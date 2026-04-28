PodiumInitialize();

gamepad = -1;

if (PODIUM_ON_SWITCH)
{
    SwitchLogInDefaultAccount();
    
    PodiumSubmit("all time score",   112);
    PodiumSubmit("best time",        223);
    PodiumSubmit("daily challenge",  556);
    
    PodiumGetScores("daily challenge");
}
else if (PODIUM_ON_XBOX_SERIES)
{
    var _activatingUser = xboxone_get_activating_user();
    if (_activatingUser != 0)
    {
        PodiumSetXboxUser(_activatingUser);
    }
}

playFabLoggedIn = false;