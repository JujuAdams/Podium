/// @param name

function __PodiumPlayFabSetDisplayName(_name)
{
    static _system = __PodiumSystem();
    static _headerMap = ds_map_create();
    
    if (not _system.__playFabLoggedIn)
    {
        __PodiumWarning("Cannot set display name, not logged into PlayFab");
    }
    
    __PodiumEnsureControllerInstance();
    
    _headerMap[? "Content-Type"   ] = "application/json";
    _headerMap[? "X-Authorization"] = _system.__playFabSessionTicket;
      
    var _bodyString = __PodiumPlayFabJSONStringify({
        DisplayName: _name,
    });
    
    if (PODIUM_VERBOSE)
    {
        __PodiumTrace($"Updating PlayFab display name to \"{_name}\" from Xbox gamertag");
    }
    
    var _result = http_request($"https://{PODIUM_PLAYFAB_TITLE_ID}.playfabapi.com/Client/UpdateUserTitleDisplayName", "POST", _headerMap, _bodyString);
    ds_map_clear(_headerMap);
    
    if (PODIUM_VERBOSE)
    {
        __PodiumRegisterHTTPAsyncID(_result, function(_abort)
        {
            var _responseHeaderMap = async_load[? "response_headers"];
            var _httpStatus        = async_load[? "http_status"     ];
            var _url               = async_load[? "url"             ];
            var _resultString      = async_load[? "result"          ];
            
            var _resultJSON = __PodiumPlayFabJSONParse(_resultString);
            if (_resultJSON == undefined) return;
            
            if (_httpStatus != 200)
            {
                __PodiumWarning($"PlayFab display name set received unexpected HTTP status {_httpStatus}");
            }
            else
            {
                __PodiumTrace($"PlayFab display name set received HTTP 200 response");
            }
            
            show_debug_message("Result JSON = \n" + json_stringify(_resultJSON, true));
        });
    }
    
    return _result;
}