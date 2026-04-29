PodiumInitialize();

gamepad = -1;

if (PODIUM_ON_SWITCH)
{
    SwitchLogInDefaultAccount();
}
else if (PODIUM_ON_XBOX_SERIES)
{
    var _activatingUser = xboxone_get_activating_user();
    if (_activatingUser != 0)
    {
        PodiumSetXboxUser(_activatingUser);
    }
}

PodiumSubmit("all time score",   111);
PodiumSubmit("all time score",   112);
PodiumSubmit("all time score",   113);
//PodiumSubmit("best time",        222);
//PodiumSubmit("daily challenge",  555);

PodiumGetScores("all time score");

playFabLoggedIn = false;