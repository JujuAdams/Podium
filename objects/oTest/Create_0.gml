PodiumInitialize();

gamepad = -1;
signedIn = false;

if (PODIUM_ON_SWITCH)
{
    PodiumSignInSwitch(switch_accounts_open_preselected_user());
}
else if (PODIUM_USING_PLAY_SERVICES)
{
    PodiumSignInGooglePlay();
}

//PlayStation and Xbox sign in based on gamepad input in Step event
//Windows GDK signs in based on Async System event