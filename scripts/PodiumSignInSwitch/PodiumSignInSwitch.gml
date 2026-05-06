/// Signs in the given account index to NPLN and prepares Podium to target this user. You'll
/// usually want to use `switch_accounts_open_preselected_user()` as the account index.
/// 
/// @param accountIndex

function PodiumSignInSwitch(_accountIndex)
{
    static _system = __PodiumSystem();
    
    if (PODIUM_ON_SWITCH)
    {
        with(_system)
        {
            __switchAccountIndex = _accountIndex;
            __username = (_accountIndex == undefined)? "" : switch_accounts_get_nickname(_accountIndex);
            
            __switchNPLNUserHandle = undefined;
            __switchUserID = undefined;
            
            if (PODIUM_VERBOSE)
            {
                __PodiumTrace($"Set Switch account index to {_accountIndex} \"{__username}\"");
            }
            
            if (_accountIndex == undefined)
            {
                __signInState = PODIUM_USER_SIGNED_OUT;
                return;
            }
            
            __signInState = PODIUM_USER_SIGNING_IN;
            
            if (not switch_accounts_network_service_available(_accountIndex))
            {
                __PodiumWarning($"Network service not available for account index {_accountIndex}");
            }
            
            var _return = switch_accounts_login_user(_accountIndex);
            if (_return)
            {
                if (PODIUM_VERBOSE)
                {
                    __PodiumTrace($"Logged in user");
                }
            }
            else
            {
                __PodiumWarning($"Failed to login user");
            }
            
            var _userHandle = switch_npln_login_prearranged_user(_accountIndex, 0, PODIUM_SWITCH_NPLN_TENANT);
            if (is_struct(_userHandle))
            {
                if (PODIUM_VERBOSE)
                {
                    __PodiumTrace($"Obtained user handle {ptr(_userHandle)} successfully");
                }
                
                __switchNPLNUserHandle = _userHandle;
            }
            else
            {
                call_later(1, time_source_units_frames, function()
                {
                    __PodiumWarning($"Failed to obtain NPLN user handle");
                    
                    __switchNPLNUserHandle = undefined;
                    __switchUserID = undefined;
                    
                    __signInState = PODIUM_USER_SIGN_IN_FAILED;
                });
            }
        }
    }
}