/// @param accountIndex

function PodiumSetSwitchAccountIndex(_accountIndex)
{
    static _system = __PodiumSystem();
    
    with(_system)
    {
        __switchAccountIndex = _accountIndex;
        __switchNPLNUserHandle = switch_npln_login_prearranged_user(_accountIndex, 0, PODIUM_SWITCH_NPLN_TENANT);
        
        //Set the user's name on the leaderboards to be their account nickname
        switch_npln_leaderboard_set_user_data(__switchNPLNUserHandle, switch_accounts_get_nickname(_accountIndex));
    }
}