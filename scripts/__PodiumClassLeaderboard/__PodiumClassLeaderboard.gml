/// @param serviceData

function __PodiumClassLeaderboard(_serviceData) constructor
{
    static _system = __PodiumSystem();
    
    __serviceData = _serviceData;
    
    __scoresDict = {};
    
    if (PODIUM_USING_STEAMWORKS)
    {
        var _ref = __GetFormattedServiceData();
        steam_create_leaderboard(_ref, __serviceData.__sortMethod, __serviceData.__displayType);
    }
    
    
    
    static __GetCached = function(_range)
    {
        return __EnsureScoresStruct(_range).__GetCached();
    }
    
    static __GetData = function(_range)
    {
        return __EnsureScoresStruct(_range).__GetData();
    }
    
    static __GetFormattedServiceData = function()
    {
        if (_system.__steamAvailable)
        {
            var _serviceDataFormatted = __serviceData.__ref;
            
            var _refreshPeriod = __serviceData.__refreshPeriod;
            if (_refreshPeriod != PODIUM_REFRESH_NEVER)
            {
                var _currentDate = date_current_datetime();
                _serviceDataFormatted += $"_y{date_get_year(_currentDate)}";
                
                if (_refreshPeriod == PODIUM_REFRESH_DAILY)
                {
                    _serviceDataFormatted += $"_d{date_get_day_of_year(_currentDate)}";
                }
                else if (_refreshPeriod == PODIUM_REFRESH_WEEKLY)
                {
                    _serviceDataFormatted += $"_w{date_get_week(_currentDate)}";
                }
                else if (_refreshPeriod == PODIUM_REFRESH_MONTHLY)
                {
                    _serviceDataFormatted += $"_m{date_get_month(_currentDate)}";
                }
            }
            
            return _serviceDataFormatted;
        }
        else
        {
            return __serviceData;
        }
    }
    
    static __EnsureScoresStruct = function(_range)
    {
        var _scoresID = $"{__serviceData.__ref}_range{_range}";
        
        var _struct = __scoresDict[$ _scoresID];
        if (not is_struct(_struct))
        {
            _struct = new __PodiumClassScores();
            __scoresDict[$ _scoresID] = _struct;
        }
        
        return _struct;
    }
}