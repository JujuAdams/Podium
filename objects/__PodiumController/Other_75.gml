if (PODIUM_VERBOSE_ASYNC)
{
    __PodiumTrace($"System (via `PODIUM_VERBOSE_ASYNC`):\n{json_encode(async_load, true)}");
}

with(__PodiumSystem())
{
    if (PODIUM_ON_PS5 && (async_load[? "event_type"] == "user_signed_in"))
    {
        __PodiumTrace("Trying to sign in initial user");
        PodiumSignInPlayStation(__PodiumPlayStationGetInitialGamepad(), false);
    }
    else if (PODIUM_ON_PS5 && (async_load[? "event_type"] == "np_availability"))
    {
        if (__signInState != PODIUM_USER_SIGNING_IN)
        {
            __PodiumWarning("Unexpected NP availability received");
        }
        else if (async_load[? "requestid"] != __psNPAvailabilityAsyncID)
        {
            __PodiumWarning($"NP availability received for different request ({async_load[? "requestid"]}) to expected ({__psNPAvailabilityAsyncID})");
        }
        else
        {
            __psNPAvailabilityAsyncID = undefined;
            
            if (async_load[? "result"])
            {
                __psUserID = async_load[? "userid"];
                
                if (PODIUM_VERBOSE)
                {
                    __PodiumTrace($"Set PlayStation user ID to \"{__psUserID}\"");
                }
                
                __PodiumUserSignedIn();
            }
            else
            {
                __signInState = PODIUM_USER_SIGN_IN_FAILED;
            }
        }
    }
    else if (PODIUM_USING_PLAYFAB_LEADERBOARDS && (async_load[? "event_type"] == "tokenandsignature_result"))
    {
        var _status = async_load[? "status"];
        if (_status != 0)
        {
            __PodiumWarning($"Token and signature request returned unexpected status `{_status}`");
            __signInState = PODIUM_USER_SIGN_IN_FAILED;
        }
        else
        {
            if (PODIUM_VERBOSE)
            {
                __PodiumTrace("Received Xbox token and signature successfully");
            }
            
            __playFabXboxTokenAndSignature = async_load[? "token"];
            __PodiumPlayFabXboxLogin();
        }
    }
}