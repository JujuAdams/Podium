/// @param name
/// @param serviceRef
/// @param [higherValueIsBetter=true]
/// @param [refreshPeriod=never]

function __PodiumClassLeaderboard(_name, _serviceRef, _higherValueIsBetter = true, _refreshPeriod = PODIUM_REFRESH_NEVER) constructor
{
    static _system = __PodiumSystem();
    
    __name                = _name;
    __serviceRef          = _serviceRef;
    __refreshPeriod       = _refreshPeriod;
    __higherValueIsBetter = _higherValueIsBetter;
    __scoresDict          = {};
    
    
    
    static Push = function(_value)
    {
        if (_system.__local)
        {
            //TODO
        }
        else if (_system.__steamAvailable)
        {
            steam_upload_score(__GetFormattedServiceRef(), _value);
        }
        else if (PODIUM_USING_GAMECENTER)
        {
            GameCenter_Leaderboard_Submit(__GetFormattedServiceRef(), _value, 0);
        }
        else if (_system.__playServicesAvailable)
        {
            GooglePlayServices_Leaderboard_SubmitScore(GetFormattedServiceRef(), _value, "");
        }
        else if (PODIUM_ON_PS5)
        {
            if (_system.__psGamepad < 0)
            {
                __PodiumSoftError("PlayStation gamepad not set or invalid. Please set the gamepad with `PodiumSetPSGamepad()` before pushing leaderboard scores");
            }
            else
            {
                psn_post_leaderboard_score(_system.__psGamepad, GetFormattedServiceRef(), _value);
            }
        }
        else if (PODIUM_USING_XBOX_LEADERBOARDS)
        {
            if (_system.__xboxUser < 0)
            {
                __PodiumSoftError("Xbox user not set or invalid. Please set the gamepad with `PodiumSetXboxUser()` before pushing leaderboard scores");
            }
            else
            {
                xboxone_stats_set_stat_int(_system.__xboxUser, GetFormattedServiceRef(), _value);
            }
        }
        else if (PODIUM_USING_PLAYFAB_LEADERBOARDS)
        {
            if (_system.__xboxUser < 0)
            {
                __PodiumSoftError("Xbox user not set or invalid. Please set the gamepad with `PodiumSetXboxUser()` before pushing leaderboard scores");
            }
            else
            {
                __PodiumPlayFabSetStat(GetFormattedServiceRef(), _value);
            }
        }
        else if (PODIUM_ON_SWITCH)
        {
            if (_system.__switchNPLNUserHandle == undefined)
            {
                __PodiumSoftError("Switch NPLN user handle not set or invalid. Please set the NPLN user handle with `PodiumSetSwitchNPLNUserHandle()` before pushing leaderboard scores");
            }
            else
            {
                switch_npln_leaderboard_set_score(_system.__switchNPLNUserHandle, __serviceRef.categoryTypeName, __serviceRef.categoryID, _value);
            }
        }
        else
        {
            __PodiumSoftError($"Unhandled OS {os_type}. Please report this error");
        }
    }
    
    static GetScores = function(_range, _callback, _callbackMetadata)
    {
        if ((_range != PODIUM_RANGE_TOP) && (_range != PODIUM_RANGE_FRIENDS) && (_range != PODIUM_RANGE_AROUND))
        {
            __PodiumSoftError($"Unhandled range `{_range}`");
            return undefined;
        }
        
        return __EnsureScoresStruct(__GetFormattedServiceRef(), _range).__GetScoresContinuous(_callback, _callbackMetadata);
    }
    
    static Refresh = function(_range, _callback, _callbackMetadata)
    {
        if ((_range != PODIUM_RANGE_TOP) && (_range != PODIUM_RANGE_FRIENDS) && (_range != PODIUM_RANGE_AROUND))
        {
            __PodiumSoftError($"Unhandled range `{_range}`");
            return undefined;
        }
        
        return __EnsureScoresStruct(__GetFormattedServiceRef(), _range).__Refresh(_callback, _callbackMetadata);
    }
    
    static GetState = function(_range)
    {
        return __EnsureScoresStruct(__GetFormattedServiceRef(), _range).__state;
    }
    
    static SetCallback = function(_range, _callback, _callbackMetadata)
    {
        return __EnsureScoresStruct(__GetFormattedServiceRef(), _range).__SetCallback(_callback, _callbackMetadata);
    }
    
    static __GetFormattedServiceRef = function()
    {
        if (_system.__steamAvailable)
        {
            var _serviceRefFormatted = __serviceRef;
            
            if (__refreshPeriod != PODIUM_REFRESH_NEVER)
            {
                var _currentDate = date_current_datetime();
                _serviceRefFormatted += $"_y{date_get_year(_currentDate)}";
                
                if (__refreshPeriod == PODIUM_REFRESH_DAILY)
                {
                    _serviceRefFormatted += $"_d{date_get_day_of_year(_currentDate)}";
                }
                else if (__refreshPeriod == PODIUM_REFRESH_WEEKLY)
                {
                    _serviceRefFormatted += $"_w{date_get_week(_currentDate)}";
                }
                else if (__refreshPeriod == PODIUM_REFRESH_MONTHLY)
                {
                    _serviceRefFormatted += $"_m{date_get_month(_currentDate)}";
                }
            }
            
            return _serviceRefFormatted;
        }
        
        return __serviceRef;
    }
    
    static __EnsureScoresStruct = function(_formattedServiceRef, _range)
    {
        var _scoresID = $"{_formattedServiceRef}_range{_range}";
        
        var _struct = __scoresDict[$ _scoresID];
        if (not is_struct(_struct))
        {
            _struct = new __PodiumClassScores(_scoresID, __name, _formattedServiceRef, _range, __refreshPeriod);
            __scoresDict[$ _scoresID] = _struct;
        }
        
        return _struct;
    }
}