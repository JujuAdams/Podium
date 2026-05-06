if (PODIUM_VERBOSE_ASYNC)
{
    __PodiumTrace($"Social (via `PODIUM_VERBOSE_ASYNC`):\n{json_encode(async_load, true)}");
}

with(__PodiumSystem())
{
    if (PODIUM_ON_SWITCH && (async_load[? "event_type"] == "switch_npln_login_prearranged_user"))
    {
        if (__signInState != PODIUM_USER_SIGNING_IN)
        {
            __PodiumWarning("Unexpected user sign-in received");
        }
        else if (async_load[? "success"])
        {
            __switchUserID = async_load[? "user_id"];
            
            if (PODIUM_VERBOSE)
            {
                __PodiumTrace($"Prearranged user logged in, user ID = \"{__switchUserID}\"");
            }
            
            switch_npln_leaderboard_set_user_data(__switchNPLNUserHandle, __username);
            
            if (PODIUM_VERBOSE)
            {
                __PodiumTrace($"Set NPLN username to \"{__username}\"");
            }
            
            __PodiumUserSignedIn();
        }
        else
        {
            __signInState = PODIUM_USER_SIGN_IN_FAILED;
            
            __switchNPLNUserHandle = undefined;
            __switchUserID = undefined;
            
            __PodiumWarning("Prearranged user failed to log in");
        }
    }
    else if (PODIUM_ON_PS5 && (async_load[? "id"] == PSN_LEADERBOARD_SCORE_RANGE_MSG))
    {
        var _leaderboardID = async_load[? "leaderboardid"]; //The actual ID we want to check against
        
        if (ds_map_exists(__psLeaderboardScoreRangeMap, _leaderboardID))
        {
            var _callback = __psLeaderboardScoreRangeMap[? _leaderboardID];
            ds_map_delete(__psLeaderboardScoreRangeMap, _leaderboardID);
        
            _callback(false);
        }
    }
    else if (PODIUM_ON_PS5 && (async_load[? "id"] == PSN_LEADERBOARD_FRIENDS_SCORES_MSG))
    {
        var _leaderboardID = async_load[? "leaderboardid"]; //The actual ID we want to check against
        
        if (ds_map_exists(__psLeaderboardScoreRangeMap, _leaderboardID))
        {
            var _callback = __psLeaderboardScoreRangeMap[? _leaderboardID];
            ds_map_delete(__psLeaderboardScoreRangeMap, _leaderboardID);
        
            _callback(false);
        }
    }
    else
    {
        for(var _i = 0; _i < array_length(__pendingArray); _i++) //Length of the array can change
        {
            var _opStruct = __pendingArray[_i];
            
            if (PODIUM_ON_SWITCH)
            {
                if (async_load[? "id"] == _opStruct.__asyncID)
                {
                    _opStruct.__Complete(async_load[? "success"]? PODIUM_LEADERBOARD_SUCCESS : PODIUM_LEADERBOARD_ERROR);
                }
            }
        }
    }
    
    //var _asyncIDMap = __PodiumSystem().__socialAsyncIDMap;
    //if (ds_map_exists(_asyncIDMap, _id))
    //{
    //    var _callback = _asyncIDMap[? _id];
    //    ds_map_delete(_asyncIDMap, _id);
    //    
    //    _callback(false);
    //}
}