if (PODIUM_VERBOSE_ASYNC)
{
    __PodiumTrace($"System (via `PODIUM_VERBOSE_ASYNC`):\n{json_encode(async_load, true)}");
}

if (async_load[? "event_type"] == "tokenandsignature_result")
{
    var _status = async_load[? "status"];
    if (_status != 0)
    {
        __PodiumSoftError($"Token and signature request returned unexpected status `{_status}`");
    }
    else
    {
        if (PODIUM_VERBOSE)
        {
            __PodiumTrace("Received Xbox token and signature successfully");
        }
        
        __PodiumSystem().__playFabXboxTokenAndSignature = async_load[? "token"];
        __PodiumPlayFabXboxLogin();
    }
}