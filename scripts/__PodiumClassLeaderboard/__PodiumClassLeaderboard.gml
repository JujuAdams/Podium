/// @param serviceData

function __PodiumClassLeaderboard(_serviceData) constructor
{
    static _system = __PodiumSystem();
    
    __serviceData = _serviceData;
    
    __scoresDict = {};
    
    if (PODIUM_USING_STEAMWORKS)
    {
        steam_create_leaderboard(__GetFormattedServiceData().__formattedRef, __serviceData.__sortMethod, __serviceData.__displayType);
    }
    
    
    
    static __GetCachedScores = function(_range)
    {
        return __EnsureScoresStruct(_range).__GetCachedScores();
    }
    
    static __GetScoresData = function(_range)
    {
        return __EnsureScoresStruct(_range).__GetScoresData();
    }
    
    static __GetFormattedServiceData = function()
    {
        var _serviceDataFormatted = __serviceData.__ref;
        
        if (_system.__steamAvailable)
        {
            
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
            
        }
        
        __serviceData.__formattedRef = _serviceDataFormatted;
        
        return __serviceData;
    }
    
    static __EnsureScoresStruct = function(_range)
    {
        var _scoresID = $"{__GetFormattedServiceData().__formattedRef}_range{_range}";
        
        var _struct = __scoresDict[$ _scoresID];
        if (not is_struct(_struct))
        {
            _struct = new __PodiumClassScores();
            __scoresDict[$ _scoresID] = _struct;
        }
        
        return _struct;
    }
}