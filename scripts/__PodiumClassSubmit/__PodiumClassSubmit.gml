/// @param formattedServiceData
/// @param value

function __PodiumClassSubmit(_formattedServiceData, _value) : __PodiumClassCommonOp() constructor
{
    __opType = __PODIUM_OP_SUBMIT;
    
    if (PODIUM_VERBOSE)
    {
        __PodiumTrace($"Created SUBMIT operation {string(ptr(self))}: ({_value} -> \"{_formattedServiceData}\")");
    }
    
    __formattedServiceData = _formattedServiceData;
    __value = _value;
    
    
    
    static __Dispatch = function()
    {
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
        
        if (_system.__local)
        {
            //TODO
        }
        else
        {
            if (_system.__steamAvailable)
            {
                __asyncID = steam_upload_score(__formattedServiceData, __value);
            }
            else if (PODIUM_USING_GAMECENTER)
            {
                GameCenter_Leaderboard_Submit(__formattedServiceData.__ref, __value, 0);
            }
            else if (_system.__playServicesAvailable)
            {
                GooglePlayServices_Leaderboard_SubmitScore(__formattedServiceData.__ref, __value, "");
            }
            else if (PODIUM_ON_PS5)
            {
                if (_system.__psGamepad < 0)
                {
                    __PodiumSoftError("PlayStation gamepad not set or invalid. Please set the gamepad with `PodiumSetPSGamepad()` before pushing leaderboard scores");
                }
                else
                {
                    psn_post_leaderboard_score(_system.__psGamepad, __formattedServiceData.__ref, __value);
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
                    xboxone_stats_set_stat_int(_system.__xboxUser, __formattedServiceData.__ref, __value);
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
                    __asyncID = __PodiumPlayFabSetStat(__formattedServiceData.__statisticName, __value, function(_resultJSON)
                    {
                        __Complete((_resultJSON == undefined)? PODIUM_STATE_ERROR : PODIUM_STATE_SUCCESS, _resultJSON);
                    });
                }
            }
            else if (PODIUM_ON_SWITCH)
            {
                if (_system.__switchNPLNUserHandle == undefined)
                {
                    __PodiumSoftError("Switch NPLN user handle not set or invalid. Please set the NPLN user handle with `PodiumSetSwitchNPLNUserHandle()` before pushing leaderboard scores");
                }
                else if (_system.__switchNPLNUserHandle == 0)
                {
                    __PodiumWarning("Switch NPLN user handle is null, not submitting score");
                }
                else
                {
                    __asyncID = switch_npln_leaderboard_set_score(_system.__switchNPLNUserHandle, __formattedServiceData.__categoryTypeName, __formattedServiceData.__categoryID, __value);
                }
            }
            else
            {
                __PodiumSoftError($"Unhandled OS {os_type}. Please report this error");
            }
        }
        
        if ((__asyncID != undefined) && (__asyncID >= 0))
        {
            array_push(_pendingArray, self);
        }
        else
        {
            __Complete(PODIUM_STATE_ERROR, undefined);
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
        
        if (is_callable(__callback))
        {
            __callback(_status, __callbackMetadata);
        }
    }
}