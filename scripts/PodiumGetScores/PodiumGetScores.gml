/// Returns scores for the given leaderboard and range. The leaderboard must previously have been
/// created by `PodiumCreate()`.
/// 
/// This function can return one of three datatypes: `undefined`, a struct, or an array of structs.
/// If there is an error or the request for scores is pending, this function will return
/// `undefined`. If valid data exists in the cache then this function will return either a struct
/// or an array of structs. If the `range` parameter is set to `PODIUM_RANGE_USER` then a struct
/// will be returned. If the `range` parameter is set to anything else then an array of structs
/// will be returned.
/// 
/// Regardless of whether a struct or an array of structs is returned, the structs will be
/// instances of `__PodiumClassRecord`. This constructor will make a struct with four variables:
/// 
/// `.name`
///     The display name of the player who submitted the score. This may be an empty string if the
///     player's name is not known.
/// 
/// `.value`
///     The value for the score. This may be a string or a number depending on what value is
///     returned by the upstream API.
/// 
/// `.metadataString`
///     Extra string-based metadata attached to the score. This may be an empty string.
/// 
/// `.rank`
///     The rank for the score. This is 1-indexed and may be a string or a number depending on what
///     rank is returned by the upstream API. If the rank is not known, which is the case when a
///     offline score is returned, then this variable will be set to `PODIUM_UNKNOWN_RANK`.
/// 
/// `.offline`
///     Whether the score is an offline score that has been created locally for the player and
///     has not been submitted successfuly to the upstream remote service. This will generally be
///     `false` when a connection with the remote service is successful.
/// 
/// @param leaderboardName
/// @param range
/// @param [seasonOffset=0]
/// @param [priority=normal]

function PodiumGetScores(_leaderboardName, _range, _seasonOffset = 0, _priority = PODIUM_PRIORITY_NORMAL)
{
    static _system = __PodiumSystem();
    static _queuedFetchArray = _system.__queuedFetchArray;
    static _emptyArray = [];
    
    array_resize(_emptyArray, 0); //Ensure the array is empty
    
    ///////
    // Error Checking
    ///////
    
    if ((_range != PODIUM_RANGE_TOP)
     && (_range != PODIUM_RANGE_FRIENDS)
     && (_range != PODIUM_RANGE_AROUND)
     && (_range != PODIUM_RANGE_USER))
    {
        __PodiumSoftError($"Unhandled range `{_range}`");
        return _emptyArray;
    }
    
    _seasonOffset = floor(_seasonOffset);
    if (_seasonOffset > 0)
    {
        __PodiumSoftError($"Season offset must be a negative number or zero");
        return _emptyArray;
    }
    
    var _leaderboardStruct = __PodiumLeaderboardFind(_leaderboardName);
    if (_leaderboardStruct == undefined)
    {
        __PodiumSoftError($"Leaderboard name \"{_leaderboardName}\" not recognised");
        return _emptyArray;
    }
    
    ///////
    // Score Collection
    ///////
    
    //If we're not signed in (failure to communicate with the server etc.) then return an offline score if we're able
    if (not PodiumGetSignedIn())
    {
        if ((_range == PODIUM_RANGE_USER) && (_seasonOffset == 0))
        {
            var _offlineRecord = PodiumGetOfflineScore(_leaderboardName);
            return (_offlineRecord == undefined)? _emptyArray : [_offlineRecord];
        }
        else
        {
            return _emptyArray;
        }
    }
    
    if (PodiumGetLeaderboardDisabled(_leaderboardName))
    {
        if (PODIUM_VERBOSE)
        {
            static _ratelimit = -infinity;
            static _lastTrigger = -infinity;
            
            if (current_time - _lastTrigger > 100)
            {
                _ratelimit = -infinity;
            }
            
            if (current_time - _ratelimit > 1500)
            {
                _ratelimit = current_time;
                __PodiumWarning($"Cannot get score, \"{_leaderboardName}\" is disabled");
            }
            
            _lastTrigger = current_time;
        }
    }
    else if (_leaderboardStruct.__GetUsingCache(_range, _seasonOffset)) //Use the cache if we've sent a request recently
    {
        if ((_range == PODIUM_RANGE_USER) && (_seasonOffset == 0) && (_leaderboardStruct.__GetScoresState(_range, _seasonOffset) <= 0))
        {
            //Use the offline score if we're getting the user's score and we ran into an error
            var _offlineRecord = PodiumGetOfflineScore(_leaderboardName);
            return (_offlineRecord == undefined)? _emptyArray : [_offlineRecord];
        }
        else
        {
            //Otherwise, return whatever scores we have available (if any)
            return _leaderboardStruct.__GetScoresData(_range, _seasonOffset);
        }
    }
    else if (_priority != PODIUM_PRIORITY_NO_REQUEST)
    {
        //Make a new request and queue it depending on the priority
        
        var _struct = new __PodiumClassOpGetScores(_leaderboardStruct, _range, _seasonOffset);
        if (__PodiumGetUniqueOperation(_struct))
        {
            if (PODIUM_VERBOSE)
            {
                __PodiumTrace($"Created GET_SCORES operation {string(ptr(_struct))}: \"{_leaderboardStruct.__serviceData.__ref}\", range = {_range}, seasonOffset = {_seasonOffset}");
            }
            
            // N.B. We also set "pending" state when dispatching a request!
            _leaderboardStruct.__EnsureScoresStruct(_range, _seasonOffset).__SetState(PODIUM_LEADERBOARD_WAITING);
            
            if (_priority == PODIUM_PRIORITY_HIGH)
            {
                array_insert(_queuedFetchArray, 0, _struct);
            }
            else if (_priority == PODIUM_PRIORITY_IMMEDIATE)
            {
                _struct.__Dispatch();
            }
            else
            {
                array_push(_queuedFetchArray, _struct);
            }
        }
    }
    
    return _emptyArray;
}