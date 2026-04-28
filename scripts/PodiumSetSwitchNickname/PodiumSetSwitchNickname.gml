/// @param nickname

function PodiumSetSwitchNickname(_nickname)
{
    static _system = __PodiumSystem();
    
    if (not PODIUM_ON_SWITCH)
    {
        return;
    }
    
    with(_system)
    {
        if (not PodiumGetUserSignedIn())
        {
            __PodiumSoftError("Cannot set Switch nickname, NPLN user handle has not been set by `PodiumSetSwitchNPLNUserHandle()`");
        }
        else
        {
            switch_npln_leaderboard_set_user_data(__switchNPLNUserHandle, _nickname);
        }
    }
}