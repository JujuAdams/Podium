function __PodiumClassScoreCache() constructor
{
    __state = PODIUM_LEADERBOARD_NOT_FETCHED;
    __data  = [];
    __lastReceivedTime = -infinity;
    __lastGetTime = -infinity;
    
    
    
    static __ClearCache = function()
    {
        __SetState(PODIUM_LEADERBOARD_NOT_FETCHED);
        
        __data = [];
        __lastReceivedTime = -infinity;
    }
    
    static __GetUsingCache = function()
    {
        if (PODIUM_ON_DESKTOP || PODIUM_ON_MOBILE)
        {
            return (current_time - __lastReceivedTime < 1_000*PODIUM_GREEDY_CACHE_TIMEOUT);
        }
        else
        {
            return ((current_time - __lastGetTime < 1_000*15) && (not is_infinity(__lastGetTime)) && (not is_infinity(__lastReceivedTime)));
        }
    }
    
    static __GetReceivedTime = function()
    {
        return __lastReceivedTime;
    }
    
    static __GetScoresData = function()
    {
        __lastGetTime = current_time;
        return __data;
    }
    
    static __ReceiveData = function(_data, _state)
    {
        __data = _data;
        
        __lastGetTime = current_time;
        __lastReceivedTime = current_time;
        
        __SetState(_state);
    }
    
    static __SetState = function(_state)
    {
        __state = _state;
    }
    
    static __GetState = function()
    {
        return __state;
    }
}