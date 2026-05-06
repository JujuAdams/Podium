if (PODIUM_VERBOSE_ASYNC)
{
    __PodiumTrace($"Steam (via `PODIUM_VERBOSE_ASYNC`):\n{json_encode(async_load, true)}");
}

with(__PodiumSystem())
{
    for(var _i = 0; _i < array_length(__pendingArray); _i++) //Length of the array can change
    {
        var _opStruct = __pendingArray[_i];
        
        if (PODIUM_STEAM_AVAILABLE)
        {
            var _eventType = async_load[? "event_type"];
            if (_eventType == "leaderboard_upload")
            {
                if ((_opStruct.__opType == __PODIUM_OP_SUBMIT) && (async_load[? "post_id"] == _opStruct.__asyncID))
                {
                    _opStruct.__Complete(async_load[? "success"]? PODIUM_LEADERBOARD_SUCCESS : PODIUM_LEADERBOARD_ERROR, undefined);
                }
            }
            else if (_eventType == "leaderboard_download")
            {
                if ((_opStruct.__opType == __PODIUM_OP_GET_SCORES) && (async_load[? "id"] == _opStruct.__asyncID))
                {
                    _opStruct.__Complete((async_load[? "status"] == 0)? PODIUM_LEADERBOARD_SUCCESS : PODIUM_LEADERBOARD_ERROR, undefined);
                }
            }
        }
    }
}