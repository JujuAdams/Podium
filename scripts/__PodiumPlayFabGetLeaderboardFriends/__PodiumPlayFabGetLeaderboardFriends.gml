/// @param leaderboardName
/// @param startPosition
/// @param count
/// @param [callback]

function __PodiumPlayFabGetLeaderboardFriends(_leaderboardName, _startPosition, _count, _callback = undefined)
{
    static _system = __PodiumSystem();
    static _headerMap = ds_map_create();
    
    if (not _system.__playFabLoggedIn)
    {
        __PodiumWarning("Cannot get leaderboard, not logged into PlayFab");
    }
    
    __PodiumEnsureControllerInstance();
    
    _headerMap[? "Content-Type" ] = "application/json";
    _headerMap[? "X-EntityToken"] = _system.__playFabEntityToken;
    
    var _bodyString = __PodiumPlayFabJSONStringify({
        StartingPosition: int64(_startPosition),
        PageSize: int64(_count),
        LeaderboardName: _leaderboardName,
        ExternalFriendSources: "Xbox",
        XboxToken: _system.__playFabXboxTokenAndSignature,
    });
    
    var _result = http_request($"https://{PODIUM_PLAYFAB_TITLE_ID}.playfabapi.com/Leaderboard/GetFriendLeaderboardForEntity", "POST", _headerMap, _bodyString);
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