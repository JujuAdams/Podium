/// @param leaderboardName
/// @param versionOffset
/// @param [callback]

function __PodiumPlayFabGetLeaderboardUser(_leaderboardName, _versionOffset, _callback = undefined)
{
    static _system = __PodiumSystem();
    
    if (not _system.__playFabLoggedIn)
    {
        __PodiumWarning("Cannot get leaderboard, not logged into PlayFab");
    }
    
    if (_versionOffset == 0)
    {
        var _result = __PodiumPlayFabGetLeaderboardUserInternal(_leaderboardName, undefined, _callback);
    }
    else
    {
        var _result = __PodiumPlayFabGetLeaderboardUserInternal(_leaderboardName, undefined, method({
            __leaderboardName: _leaderboardName,
            __versionOffset:   _versionOffset,
            __callback:        _callback,
        },
        function(_resultJSON)
        {
            var _version = undefined;
            try
            {
                _version = _resultJSON.data.Version;
            }
            catch(_error)
            {
                
            }
            
            if (not is_numeric(_version))
            {
                __PodiumWarning($"Could not find leaderboard version for \"{__leaderboardName}\"");
                
                if (is_callable(__callback))
                {
                    __callback(undefined);
                }
            }
            else if (_version + __versionOffset < 0)
            {
                __PodiumWarning($"Found current leaderboard \"{__leaderboardName}\" version {_version} but offset {__versionOffset} makes request version negative");
                
                if (is_callable(__callback))
                {
                    __callback(undefined);
                }
            }
            else
            {
                __PodiumPlayFabGetLeaderboardUserInternal(__leaderboardName, _version + __versionOffset, __callback);
            }
        }));
    }
    
    return _result;
}

function __PodiumPlayFabGetLeaderboardUserInternal(_leaderboardName, _version, _callback = undefined)
{
    static _system = __PodiumSystem();
    static _headerMap = ds_map_create();
    
    if (not _system.__playFabLoggedIn)
    {
        __PodiumWarning("Cannot get leaderboard, not logged into PlayFab");
    }
    
    _headerMap[? "Content-Type" ] = "application/json";
    _headerMap[? "X-EntityToken"] = _system.__playFabEntityToken;
    
    var _body = {
        EntityIds: [_system.__playFabEntityID],
        LeaderboardName: _leaderboardName,
    };
    
    if (_version != undefined)
    {
        _body.Version = _version;
    }
    
    var _bodyString = __PodiumPlayFabJSONStringify(_body);
    
    var _result = http_request($"https://{PODIUM_PLAYFAB_TITLE_ID}.playfabapi.com/Leaderboard/GetLeaderboardForEntities", "POST", _headerMap, _bodyString);
    ds_map_clear(_headerMap);
    
    __PodiumRegisterHTTPAsyncID(_result, method({
        __callback: _callback,
    },
    function(_abort)
    {
        var _responseHeaderMap = async_load[? "response_headers"];
        var _httpStatus        = async_load[? "http_status"     ];
        var _url               = async_load[? "url"             ];
        var _resultString      = async_load[? "result"          ];
    
        var _resultJSON = __PodiumPlayFabJSONParse(_resultString);
        if (_resultJSON == undefined)
        {
            if (is_callable(__callback))
            {
                __callback(undefined);
            }
            
            return;
        }
        
        if (_httpStatus != 200)
        {
            __PodiumWarning($"PlayFab leaderboard get received unexpected HTTP status {_httpStatus}");
            
            if (PODIUM_VERBOSE)
            {
                show_debug_message("Result JSON = \n" + json_stringify(_resultJSON, true));
            }
            
            if (is_callable(__callback))
            {
                __callback(undefined);
            }
        }
        else
        {
            if (PODIUM_VERBOSE)
            {
                __PodiumTrace($"PlayFab leaderboard get received response");
            }
            
            if (is_callable(__callback))
            {
                __callback(_resultJSON);
            }
        }
    }));
    
    return _result;
}