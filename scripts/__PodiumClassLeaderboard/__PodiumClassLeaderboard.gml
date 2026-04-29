/// @param name
/// @param serviceRef
/// @param [higherValueIsBetter=true]
/// @param [displayType=numeric]
/// @param [refreshPeriod=never]

function __PodiumClassLeaderboard(_name, _serviceRef, _higherValueIsBetter = true, _displayType = PODIUM_DISPLAY_NUMERIC, _refreshPeriod = PODIUM_REFRESH_NEVER) constructor
{
    static _system = __PodiumSystem();
    
    __name                = _name;
    __serviceRef          = _serviceRef;
    __refreshPeriod       = _refreshPeriod;
    __higherValueIsBetter = _higherValueIsBetter;
    __displayType         = _displayType;
    __scoresDict          = {};
    
    if (PODIUM_USING_STEAMWORKS)
    {
        //Trigger an early ensure to create leaderboards. This helps us find errors early
        __EnsureScoresStruct(__GetFormattedServiceRef(), _refreshPeriod);
    }
    
    
    
    static __GetCached = function(_range)
    {
        return __EnsureScoresStruct(__GetFormattedServiceRef(), _range).__GetCached();
    }
    
    static __GetData = function(_range)
    {
        return __EnsureScoresStruct(__GetFormattedServiceRef(), _range).__GetData();
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
            _struct = new __PodiumClassScores(_scoresID, __name, _formattedServiceRef, _range, __higherValueIsBetter, __displayType, __refreshPeriod);
            __scoresDict[$ _scoresID] = _struct;
        }
        
        return _struct;
    }
}