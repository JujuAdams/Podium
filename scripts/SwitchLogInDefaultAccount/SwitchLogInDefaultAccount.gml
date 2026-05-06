function SwitchLogInDefaultAccount()
{
    var _accountIndex = switch_accounts_open_preselected_user();
    show_debug_message($"Setting Switch account index to {_accountIndex}");
    
    if (not switch_accounts_network_service_available(_accountIndex))
    {
        show_debug_message($"Warning! Network service not available for account index {_accountIndex}");
    }
    
    var _return = switch_accounts_login_user(_accountIndex);
    if (_return)
    {
        show_debug_message($"Logged in user");
    }
    else
    {
        show_debug_message($"Failed to login user");
    }
    
    var _userHandle = switch_npln_login_prearranged_user(_accountIndex, 0, "") ?? 0;
    show_debug_message($"NPLN user handle is {ptr(_userHandle)}");
    
    if (_userHandle == 0)
    {
        show_debug_message($"Failed to obtain NPLN user handle");
    }
    else
    {
        show_debug_message($"Obtained user handle successfully");
    }
    
    PodiumSetSwitchNPLNUserHandle(_userHandle);
    
    if (PodiumGetUserSignedIn())
    {
        PodiumSetSwitchNickname(switch_accounts_get_nickname(_accountIndex));
    }
}