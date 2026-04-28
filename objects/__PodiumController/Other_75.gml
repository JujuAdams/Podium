if (PODIUM_VERBOSE_ASYNC)
{
    show_debug_message($"System:\n{json_encode(async_load, true)}");
}

//FIXME - It's possible for tokens to get confused if you set the Xbox user rapidly
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
else
{
    var _id = async_load[? "id"];
    
    var _asyncIDMap = __PodiumSystem().__systemAsyncIDMap;
    if (ds_map_exists(_asyncIDMap, _id))
    {
        var _callback = _asyncIDMap[? _id];
        ds_map_delete(_asyncIDMap, _id);
        
        _callback(false);
    }
}