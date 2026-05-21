/// Function must be called inside `__PodiumConfigLeaderboards`.
/// 
/// PodiumCreate({
///     leaderboardName: "daily",
///     decimalPlaces: 0,
///     descending: true, //descending = higher is better
///     daily: true,
///     hasWeeklyHistory: true,
///     steam: {
///         serviceName: "test",
///         displayType: lb_disp_numeric,
///     },
///     switch: {
///         categoryTypeName: "testDaily_d#",
///         categoryID: 0,
///     },
///     playStation: [0, 1, 2, 3, 4, 5, 6],
///     playFab: {
///         statisticName: "testDailyStat",
///         leaderboardName: "testDaily",
///     },
///     playServices: "",
///     gameCenter: "",
/// });

function PodiumCreate(_serviceData)
{
    static _system = __PodiumSystem();
    static _leaderboardDict = _system.__leaderboardDict;
    
    static _funcValidateStruct = function(_struct, _validNamesArray)
    {
        var _namesArray = struct_get_names(_struct);
        var _i = 0;
        repeat(array_length(_namesArray))
        {
            if (array_get_index(_validNamesArray, _namesArray[_i]) < 0)
            {
                __PodiumSoftError($"Parameter \"{_namesArray[_i]}\" not recognised");
                return false;
            }
            
            ++_i;
        }
        
        return true;
    }
    
    static _funcCheckPresence = function(_struct, _variableName)
    {
        if (not struct_exists(_struct, _variableName))
        {
            __PodiumSoftError($"Missing `.{_variableName}` parameter from leaderboard {_struct}");
            return false;
        }
        
        return true;
    }
    
    if (not _system.__runningDefinitions)
    {
        __PodiumSoftError("Cannot call `PodiumCreate()` outside `__PodiumConfigLeaderboards()`");
        return false;
    }
    
    if (not _funcValidateStruct(_serviceData, ["leaderboardName", "descending", "overwrite",
                                               "daily", "hasWeeklyHistory",
                                               "steam", "switch",
                                               "playStation", "playFab",
                                               "playServices", "gameCenter"]))
    {
        return false;
    }
    
    _serviceData = variable_clone(_serviceData);
    
    _serviceData[$ "descending"      ] ??= true;
    _serviceData[$ "daily"           ] ??= false;
    _serviceData[$ "hasWeeklyHistory"] ??= false;
    _serviceData[$ "overwrite"       ] ??= false;
    _serviceData[$ "decimalPlaces"   ] ??= 0;
    _serviceData.__formattedRef          = undefined;
    
    var _leaderboardName = _serviceData.leaderboardName;
    var _hasWeeklyHistory = _serviceData[$ "hasWeeklyHistory"];
    
    if (PodiumGetOfflineOnly())
    {
        _serviceData.__ref = _leaderboardName;
    }
    else if (PODIUM_STEAM_AVAILABLE)
    {
        if (not _funcCheckPresence(_serviceData, "steam"))
        {
            return false;
        }
        
        var _platformData = _serviceData.steam;
        if (_platformData != undefined)
        {
            if (is_string(_platformData))
            {
                _platformData = {
                    serviceName: _platformData,
                };
                
                _serviceData.steam = _platformData;
            }
            
            if (not _funcValidateStruct(_platformData, ["serviceName", "displayType"]))
            {
                return false;
            }
            
            _platformData[$ "displayType"] ??= lb_disp_numeric;
            
            _serviceData.__ref = _platformData.serviceName;
        }
    }
    else if (PODIUM_ON_SWITCH)
    {
        if (not _funcCheckPresence(_serviceData, "switch"))
        {
            return false;
        }
        
        var _platformData = _serviceData.switch;
        if (_platformData != undefined)
        {
            if ((not _funcCheckPresence(_platformData, "categoryTypeName")) || (not _funcCheckPresence(_platformData, "categoryID")))
            {
                return false;
            }
            
            if (_hasWeeklyHistory)
            {
                if (string_count("#", _platformData.categoryTypeName) != 1)
                {
                    __PodiumSoftError("Switch `.categoryTypeName` must contain exactly one # when using weekly history");
                    return false;
                }
            }
            
            _serviceData.__ref = $"{_platformData.categoryTypeName}_{_platformData.categoryID}";
            _platformData.__formattedCategoryTypeName = undefined;
        }
    }
    else if (PODIUM_ON_PS5)
    {
        if (not _funcCheckPresence(_serviceData, "playStation"))
        {
            return false;
        }
        
        var _platformData = _serviceData.playStation;
        if (_platformData != undefined)
        {
            if (_hasWeeklyHistory)
            {
                if (not is_array(_platformData) || (array_length(_platformData) != 7))
                {
                    __PodiumSoftError("Leaderboard's `.playStation` variable must be an array with 7 elements when using weekly history");
                    return false;
                }
            }
            else if ((not is_numeric(_platformData)) || (floor(_platformData) != _platformData))
            {
                __PodiumSoftError("PlayStation leaderboard IDs must be integers");
                return false;
            }
            
            _serviceData.__ref = _platformData;
        }
    }
    else if (PODIUM_USING_PLAYFAB_LEADERBOARDS)
    {
        if (not _funcCheckPresence(_serviceData, "playFab"))
        {
            return false;
        }
        
        var _platformData = _serviceData.playFab;
        if (_platformData != undefined)
        {
            _serviceData.__ref = _platformData;
        }
    }
    else if (PODIUM_USING_XBOX_LEADERBOARDS)
    {
        if (not _funcCheckPresence(_serviceData, "xbox"))
        {
            return false;
        }
        
        //TODO
        
        var _platformData = _serviceData.xbox;
        if (_platformData != undefined)
        {
            _serviceData.__ref = _platformData;
        }
    }
    else if (PODIUM_USING_GAMECENTER)
    {
        if (not _funcCheckPresence(_serviceData, "gameCenter"))
        {
            return false;
        }
        
        var _platformData = _serviceData.gameCenter;
        if (_platformData != undefined)
        {
            _serviceData.__ref = _serviceData.gameCenter;
        }
    }
    else if (PODIUM_USING_PLAY_SERVICES)
    {
        if (not _funcCheckPresence(_serviceData, "playServices"))
        {
            return false;
        }
        
        var _platformData = _serviceData.playServices;
        if (_platformData != undefined)
        {
            _serviceData.__ref = _serviceData.playServices;
        }
    }
    
    _leaderboardDict[$ _leaderboardName] = new __PodiumClassLeaderboard(_serviceData);
    
    return true;
}