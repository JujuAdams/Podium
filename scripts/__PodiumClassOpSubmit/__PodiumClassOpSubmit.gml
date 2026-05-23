/// @param formattedServiceData
/// @param value
/// @param metadataString
/// @param clearCache
/// @param immediate

function __PodiumClassOpSubmit(_formattedServiceData, _value, _metadataString, _clearCache, _immediate) : __PodiumClassOpCommon() constructor
{
    __opType = __PODIUM_OP_SUBMIT;
    
    __formattedServiceData = _formattedServiceData;
    __value                = _value;
    __metadataString       = _metadataString;
    __clearCache           = _clearCache;
    __immediate            = _immediate;
    
    
    
    static __OperationEqual = function(_other)
    {
        return (is_instanceof(_other, __PodiumClassOpSubmit)
             && (__value == _other.__value)
             && (__formattedServiceData.__formattedRef == _other.__formattedServiceData.__formattedRef));
    }
    
    static __Dispatch = function()
    {
        static _bufferStatic = buffer_create(1024, buffer_grow, 1);
        var _buffer = _bufferStatic;
        
        if (__dispatched) return;
        
        __dispatched = true;
        __activityTime = current_time;
        
        if (PODIUM_VERBOSE)
        {
            __PodiumTrace($"Dispatching SUBMIT operation {string(ptr(self))}");
        }
        
        var _index = array_get_index(_queuedSubmitArray, self);
        if (_index >= 0) array_delete(_queuedSubmitArray, _index, 1);
        
        array_push(_activityArray, self);
        
        var _submitScore = __PodiumConvertToSubmitScore(__value, __formattedServiceData);
        
        if (PODIUM_STEAM_AVAILABLE)
        {
            if (__metadataString == "")
            {
                __asyncID = steam_upload_score_ext(__formattedServiceData.__formattedRef, _submitScore, __formattedServiceData.overwrite);
            }
            else
            {
                buffer_resize(_buffer, string_byte_length(__metadataString));
                buffer_poke(_buffer, 0, buffer_text, __metadataString);
                __asyncID = steam_upload_score_buffer_ext(__formattedServiceData.__formattedRef, _submitScore, _buffer, __formattedServiceData.overwrite);
            }
        }
        else if (PODIUM_ON_PS5)
        {
            __asyncID = 999_999;
            psn_post_leaderboard_score_comment(_system.__psGamepad, __formattedServiceData.__formattedRef, _submitScore, __metadataString);
            __PodiumRegisterPSLeaderboardSubmit(__formattedServiceData.__formattedRef, function(_cancelled)
            {
                __Complete(((not _cancelled) && async_load[? "succeeded"])? PODIUM_LEADERBOARD_SUCCESS : PODIUM_LEADERBOARD_ERROR, undefined);
            });
        }
        else if (PODIUM_USING_XBOX_LEADERBOARDS)
        {
            var _result = xboxone_stats_set_stat_int(_system.__xboxUser, __formattedServiceData.xbox, _submitScore);
            xboxone_stats_flush_user(_system.__xboxUser, false);
            __Complete((_result == 0)? PODIUM_LEADERBOARD_SUCCESS : PODIUM_LEADERBOARD_ERROR, undefined);
            return;
        }
        else if (PODIUM_USING_PLAYFAB_LEADERBOARDS)
        {
            __asyncID = __PodiumPlayFabLeaderboardUpdate(__formattedServiceData.playFab, _submitScore, __metadataString, function(_resultJSON)
            {
                __Complete((_resultJSON == undefined)? PODIUM_LEADERBOARD_ERROR : PODIUM_LEADERBOARD_SUCCESS, _resultJSON);
            });
        }
        else if (PODIUM_ON_SWITCH)
        {
            __asyncID = switch_npln_leaderboard_set_score(_system.__switchNPLNUserHandle,
                                                          __formattedServiceData.switch.__formattedCategoryTypeName, __formattedServiceData.switch.categoryID,
                                                          _submitScore, { _: __metadataString });
        }
        else if (PODIUM_USING_GAMECENTER)
        {
            var _metadataValue = 0;
            if (__metadataString != "")
            {
                try
                {
                    _metadataValue = real(__metadataString);
                }
                catch(_error)
                {
                    if (PODIUM_VERBOSE || PODIUM_RUNNING_FROM_IDE)
                    {
                        show_debug_message(_error);
                        __PodiumWarning($"GameCenter metadata must be a numeric value (was \"{__metadataString}\")");
                    }
                }
            }
            
            GameCenter_Leaderboard_Submit(__formattedServiceData.gameCenter, _submitScore, _metadataValue);
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
                GooglePlayServices_Leaderboard_SubmitScore(__formattedServiceData.playServices, _submitScore, _scoreTag);
            }
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
        
        //Redirect this "failure" to a success. `0x8222f404` is the error code for "not best score". To avoid
        //constantly resubmitting not-best scores, we want to chalk this up as a success for our purposes
        if (PODIUM_ON_PS5 && (_status == PODIUM_LEADERBOARD_ERROR)
        &&  (async_load >= 0) && (async_load[? "error_code"] == 0xffff_ffff_8222_f404))
        {
            _status = PODIUM_LEADERBOARD_SUCCESS;
        }
        
        if (PODIUM_VERBOSE)
        {
            __PodiumTrace($"Completing SUBMIT operation {string(ptr(self))}: status = {_status}");
        }
        
        __status = _status;
        __asyncID = undefined;
        
        var _index = array_get_index(_queuedSubmitArray, self);
        if (_index >= 0) array_delete(_queuedSubmitArray, _index, 1);
        
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
        
        if (PODIUM_USING_XBOX_LEADERBOARDS && __immediate && (__status == PODIUM_LEADERBOARD_SUCCESS))
        {
            xboxone_stats_flush_user(_system.__xboxUser, true);
        }
        
        if (is_callable(__callback))
        {
            __callback(_status, __callbackMetadata);
        }
    }
}