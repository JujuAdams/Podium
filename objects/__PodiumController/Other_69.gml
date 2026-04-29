if (PODIUM_VERBOSE_ASYNC)
{
    show_debug_message($"Steam:\n{json_encode(async_load, true)}");
}

with(__PodiumSystem())
{
    var _i = 0;
    repeat(array_length(__pendingArray))
    {
        var _opStruct = __pendingArray[_i];
        
        if (__steamAvailable)
        {
            var _eventType = async_load[? "event_type"];
            if (_eventType == "leaderboard_upload")
            {
                if ((_opStruct.__opType == __PODIUM_OP_SUBMIT) && (async_load[? "post_id"] == _opStruct.__asyncID))
                {
                    _opStruct.__Complete(async_load[? "success"]);
                }
            }
            else if (_eventType == "leaderboard_download")
            {
                if ((_opStruct.__opType == __PODIUM_OP_GET_SCORES) && (async_load[? "id"] == _opStruct.__asyncID))
                {
                    _opStruct.__Complete(async_load[? "status"] == 0);
                }
            }
        }
        else if (PODIUM_ON_SWITCH)
        {
            
        }
        
        ++_i;
    }
}