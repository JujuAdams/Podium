/// @param formattedServiceData
/// @param value
/// @param metadataString
/// @param clearCache

function __PodiumClassOpSubmit(_formattedServiceData, _value, _metadataString, _clearCache) : __PodiumClassOpCommon() constructor
{
    __opType = __PODIUM_OP_SUBMIT;
    
    __formattedServiceData = _formattedServiceData;
    __value                = _value;
    __metadataString       = _metadataString;
    __clearCache           = _clearCache;
    
    
    
    static __OperationEqual = function(_other)
    {
        return (is_instanceof(_other, __PodiumClassOpSubmit)
             && (__value == _other.__value)
             && (__formattedServiceData.__formattedRef == _other.__formattedServiceData.__formattedRef));
    }
    
    static __Dispatch = function()
    {
        static _buffer = buffer_create(1024, buffer_grow, 1);
        
        if (__dispatched) return;
        
        __dispatched = true;
        __activityTime = current_time;
        
        if (PODIUM_VERBOSE)
        {
            __PodiumTrace($"Dispatching SUBMIT operation {string(ptr(self))}");
        }
        
        var _index = array_get_index(_queuedArray, self);
        if (_index >= 0) array_delete(_queuedArray, _index, 1);
        
        array_push(_activityArray, self);
        
        if (PODIUM_STEAM_AVAILABLE)
        {
            buffer_resize(_buffer, string_byte_length(__metadataString));
            buffer_poke(_buffer, 0, buffer_text, __metadataString);
            __asyncID = steam_upload_score_buffer_ext(__formattedServiceData.__formattedRef, __value, _buffer, true);
        }
        else if (PODIUM_USING_GAMECENTER)
        {
            GameCenter_Leaderboard_Submit(__formattedServiceData.gameCenter, __value, 0);
        }
        else if (PODIUM_PLAY_SERVICES_AVAILABLE)
        {
            var _scoreTag = __PodiumPlayServicesEncode(__metadataString);
            if (string_length(_scoreTag) > 64)
            {
                if (PODIUM_VERBOSE || PODIUM_RUNNING_FROM_IDE)
                {
                    __PodiumTrace($"Metadata string = \"{__metadataString}\", encoded = \"{_scoreTag}\" (length = {string_length(_scoreTag)})");
                }
                
                __PodiumSoftError("Encoded metadata string is longer than 64 characters");
            }
            else
            {
                GooglePlayServices_Leaderboard_SubmitScore(__formattedServiceData.playServices, __value, _scoreTag);
            }
        }
        else if (PODIUM_ON_PS5)
        {
            psn_post_leaderboard_score_comment(_system.__psGamepad, __formattedServiceData.playStation, __value, __metadataString);
        }
        else if (PODIUM_USING_XBOX_LEADERBOARDS)
        {
            xboxone_stats_set_stat_int(_system.__xboxUser, __formattedServiceData.xbox, __value);
        }
        else if (PODIUM_USING_PLAYFAB_LEADERBOARDS)
        {
            __asyncID = __PodiumPlayFabLeaderboardUpdate(__formattedServiceData.playFab, __value, __metadataString, function(_resultJSON)
            {
                __Complete((_resultJSON == undefined)? PODIUM_LEADERBOARD_ERROR : PODIUM_LEADERBOARD_SUCCESS, _resultJSON);
            });
        }
        else if (PODIUM_ON_SWITCH)
        {
            __asyncID = switch_npln_leaderboard_set_score(_system.__switchNPLNUserHandle,
                                                          __formattedServiceData.switch.__formattedCategoryTypeName, __formattedServiceData.switch.categoryID,
                                                          __value, { _: __metadataString });
        }
        else
        {
            __PodiumSoftError($"Unhandled OS {os_type}. Please report this error");
        }
        
        if ((__asyncID != undefined) && (__asyncID >= 0))
        {
            array_push(_pendingArray, self);
        }
        else
        {
            __Complete(PODIUM_LEADERBOARD_ERROR, undefined);
        }
    }
    
    static __Complete = function(_status, _playFabData)
    {
        if (__completed) return;
        
        __completed = true;
        __activityTime = current_time;
        
        if (PODIUM_VERBOSE)
        {
            __PodiumTrace($"Completing SUBMIT operation {string(ptr(self))}: status = {_status}");
        }
        
        __status = _status;
        __asyncID = undefined;
        
        var _index = array_get_index(_queuedArray, self);
        if (_index >= 0) array_delete(_queuedArray, _index, 1);
        
        var _index = array_get_index(_pendingArray, self);
        if (_index >= 0) array_delete(_pendingArray, _index, 1);
        
        if (__clearCache)
        {
            PodiumClearRemoteCache(__formattedServiceData.leaderboardName, PODIUM_RANGE_TOP,     0);
            PodiumClearRemoteCache(__formattedServiceData.leaderboardName, PODIUM_RANGE_AROUND,  0);
            PodiumClearRemoteCache(__formattedServiceData.leaderboardName, PODIUM_RANGE_FRIENDS, 0);
            PodiumClearRemoteCache(__formattedServiceData.leaderboardName, PODIUM_RANGE_USER,    0);
        }
        
        __PodiumOfflineRecordSetPending(__formattedServiceData.leaderboardName, (__status != PODIUM_LEADERBOARD_SUCCESS));
        
        if (is_callable(__callback))
        {
            __callback(_status, __callbackMetadata);
        }
    }
}