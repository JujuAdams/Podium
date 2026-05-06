/// @param serviceData

function __PodiumClassLeaderboard(_serviceData) constructor
{
    static _system = __PodiumSystem();
    
    __serviceData = _serviceData;
    
    __scoresDict = {};
    
    if (PODIUM_USING_STEAMWORKS)
    {
        var _i = 0;
        repeat(__serviceData.hasWeeklyHistory? 7 : 1)
        {
            steam_create_leaderboard(__GetFormattedServiceData(_i).__formattedRef,
                                     __serviceData.descending? lb_sort_descending : lb_sort_ascending,
                                     __serviceData.steam.displayType);
            --_i;
        }
    }
    
    
    
    static __GetUsingCache = function(_range, _seasonOffset)
    {
        return __EnsureScoresStruct(_range, _seasonOffset).__GetUsingCache();
    }
    
    static __GetScoresData = function(_range, _seasonOffset)
    {
        return __EnsureScoresStruct(_range, _seasonOffset).__GetScoresData();
    }
    
    static __GetScoresState = function(_range, _seasonOffset)
    {
        return __EnsureScoresStruct(_range, _seasonOffset).__GetState();
    }
    
    static __GetOfflineRecordValid = function(_record)
    {
        if (__serviceData.daily)
        {
            var _recordDays = date_day_span(PODIUM_REFERENCE_DATE, _record.__datetime);
            return (floor(_recordDays) == PodiumGetDays());
        }
        
        return true;
    }
    
    static __GetFormattedServiceData = function(_seasonOffset)
    {
        var _serviceRefFormatted = __serviceData.__ref;
        
        if (__serviceData.hasWeeklyHistory)
        {
            if (PodiumGetOfflineOnly())
            {
                // n/a
            }
            else if (PODIUM_STEAM_AVAILABLE)
            {
                var _date = date_inc_day(PodiumGetTime(), _seasonOffset);
                _serviceRefFormatted += $"_y{date_get_year(_date)}_d{date_get_day_of_year(_date)}";
            }
            else if (PODIUM_ON_SWITCH)
            {
                _serviceRefFormatted = string_replace(_serviceRefFormatted, "#", PodiumGetWeekday(_seasonOffset));
                __serviceData.switch.__formattedCategoryTypeName = string_replace(__serviceData.switch.categoryTypeName, "#", PodiumGetWeekday(_seasonOffset));
            }
            else if (PODIUM_ON_PS5)
            {
                _serviceRefFormatted = __serviceData.playStation[PodiumGetWeekday(_seasonOffset)];
            }
            else if (PODIUM_USING_PLAYFAB_LEADERBOARDS)
            {
                // n/a
            }
            else
            {
                //TODO
            }
        }
        else
        {
            if (PODIUM_ON_SWITCH)
            {
                __serviceData.switch.__formattedCategoryTypeName = __serviceData.switch.categoryTypeName;
            }
        }
        
        __serviceData.__formattedRef = _serviceRefFormatted;
        
        return __serviceData;
    }
    
    static __EnsureScoresStruct = function(_range, _seasonOffset)
    {
        var _scoresID = $"{__GetFormattedServiceData(_seasonOffset).__formattedRef}_range{_range}_seasonsOffset{_seasonOffset}";
        
        var _struct = __scoresDict[$ _scoresID];
        if (not is_struct(_struct))
        {
            _struct = new __PodiumClassScoreCache();
            __scoresDict[$ _scoresID] = _struct;
        }
        
        return _struct;
    }
}