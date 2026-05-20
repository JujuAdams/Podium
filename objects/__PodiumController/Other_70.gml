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
    else if (PODIUM_ON_PS5 && (async_load[? "id"] == PSN_LEADERBOARD_SCORE_POSTED_MSG))
    {
        __PodiumCheckPSError();
        
        var _leaderboardID = async_load[? "leaderboardid"]; //The actual ID we want to check against
        if (ds_map_exists(__psLeaderboardSubmitMap, _leaderboardID))
        {
            var _callback = __psLeaderboardSubmitMap[? _leaderboardID];
            ds_map_delete(__psLeaderboardSubmitMap, _leaderboardID);
            _callback(false);
        }
    }
    else if (PODIUM_ON_PS5 && (async_load[? "id"] == PSN_LEADERBOARD_SCORE_RANGE_MSG))
    {
        __PodiumCheckPSError();
        
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
        __PodiumCheckPSError();
        
        var _leaderboardID = async_load[? "leaderboardid"]; //The actual ID we want to check against
        if (ds_map_exists(__psLeaderboardFriendsMap, _leaderboardID))
        {
            var _callback = __psLeaderboardFriendsMap[? _leaderboardID];
            ds_map_delete(__psLeaderboardFriendsMap, _leaderboardID);
            _callback(false);
        }
    }
    else if (PODIUM_ON_PS5 && (async_load[? "id"] == PSN_LEADERBOARD_SCORE_MSG))
    {
        __PodiumCheckPSError();
        
        var _leaderboardID = async_load[? "leaderboardid"]; //The actual ID we want to check against
        if (ds_map_exists(__psLeaderboardUserMap, _leaderboardID))
        {
            var _callback = __psLeaderboardUserMap[? _leaderboardID];
            ds_map_delete(__psLeaderboardUserMap, _leaderboardID);
            _callback(false);
        }
    }
    else if (PODIUM_USING_PLAY_SERVICES && (async_load[? "type"] == "GooglePlayServices_SignIn"))
    {
        if (__signInState != PODIUM_USER_SIGNING_IN)
        {
            __PodiumWarning("Unexpected user sign-in received");
        }
        else if (async_load[? "success"] && async_load[? "isAuthenticated"])
        {
            if (PODIUM_VERBOSE)
            {
                __PodiumTrace($"Google Play signed in");
            }
            
            GooglePlayServices_Player_Current();
        }
        else
        {
            __signInState = PODIUM_USER_SIGN_IN_FAILED;
            
            __PodiumWarning("Google Play failed sign in");
        }
    }
    else if (PODIUM_USING_PLAY_SERVICES && (async_load[? "type"] == "GooglePlayServices_Player_Current"))
    {
        if (__signInState != PODIUM_USER_SIGNING_IN)
        {
            __PodiumWarning("Unexpected player info received");
        }
        else if (async_load[? "success"])
        {
            if (PODIUM_VERBOSE)
            {
                __PodiumTrace($"Google Play player info received");
            }
            
            var _username = undefined;
            var _playerID = undefined;
            try
            {
                var _json = json_parse(async_load[? "player"]);
                _username = _json.displayName;
                _playerID = _json.playerId;
            }
            catch(_error)
            {
                show_debug_message(_error);
            }
            
            if ((_username != undefined) && (_playerID != undefined))
            {
                __username = _username;
                __playServicesID = _playerID;
                __PodiumUserSignedIn();
            }
            else
            {
                __signInState = PODIUM_USER_SIGN_IN_FAILED;
                __PodiumWarning("Failed to parse player info JSON");
            }
        }
        else
        {
            __signInState = PODIUM_USER_SIGN_IN_FAILED;
            
            __PodiumWarning("Failed to obtain Google Play player info");
        }
    }
    else if (PODIUM_USING_GAMECENTER && (async_load[? "type"] == "GameCenter_Authenticate"))
    {
        if (__signInState != PODIUM_USER_SIGNING_IN)
        {
            __PodiumWarning("Unexpected GameCenter authenticate received");
        }
        else if (async_load[? "success"])
        {
            if (PODIUM_VERBOSE)
            {
                __PodiumTrace($"GameCenter authenticate received");
            }
            
            var _infoJSON = GameCenter_LocalPlayer_GetInfo();
            
            var _info        = undefined;
            var _displayName = undefined;
            var _playerID    = undefined;
            try
            {
                _info        = json_parse(_infoJSON);
                _displayName = _info.displayName;
                _playerID    = _info.playerID;
            }
            catch(_error)
            {
                show_debug_message(_error);
            }
            
            if ((_displayName != undefined) && (_playerID != undefined))
            {
                __username           = _displayName;
                __gameCenterPlayerID = _playerID;
                
                __PodiumUserSignedIn();
            }
            else
            {
                __signInState = PODIUM_USER_SIGN_IN_FAILED;
                
                __PodiumWarning("Failed to parse GameCenter player info");
            }
        }
        else
        {
            __signInState = PODIUM_USER_SIGN_IN_FAILED;
            
            __PodiumWarning("Failed to authenticate GameCenter");
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
                    if (PODIUM_SWITCH_SHOW_ERROR_VIEWER)
                    {
                        if (async_load[? "error"] > 0)
                        {
                            switch_error_show_os_code("2321-4993");
                        }
                    }
                    
                    _opStruct.__Complete(async_load[? "success"]? PODIUM_LEADERBOARD_SUCCESS : PODIUM_LEADERBOARD_ERROR);
                }
            }
            else if (PODIUM_USING_PLAY_SERVICES)
            {
                if (async_load[? "ind"] == _opStruct.__asyncID)
                {
                    _opStruct.__Complete(PODIUM_LEADERBOARD_SUCCESS);
                }
            }
        }
    }
}