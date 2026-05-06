/// @param string
/// @param [submitPendingScores=true]

function PodiumImportLocalData(_string, _submitPendingScores = true)
{
    static _system = __PodiumSystem();
    
    with(_system)
    {
        if (not __initialized)
        {
            __PodiumError("Cannot import data, Podium has not been initialized");
            return;
        }
        
        var _buffer = -1;
        try
        {
            _buffer = buffer_base64_decode(_string);
            
            if (not buffer_exists(_buffer))
            {
                throw "Buffer does not exist";
            }
        }
        catch(_error)
        {
            show_debug_message(_error);
            __PodiumWarning("Failed to decode string");
            return false;
        }
        
        var _localData = {};
        
        try
        {
            if (PODIUM_DEBUG_IGNORE_LOCAL_IMPORT)
            {
                throw "`PODIUM_DEBUG_IGNORE_LOCAL_IMPORT` is set to `true`";
            }
            
            var _header = buffer_read(_buffer, buffer_string);
            if (_header != "POD")
            {
                throw "Failed to import data, header not found";
            }
            
            var _version = buffer_read(_buffer, buffer_u64);
            if (_version != __PODIUM_OFFLINE_DATA_VERSION)
            {
                throw "$Failed to import data, version not `{__PODIUM_OFFLINE_DATA_VERSION}`";
            }
            
            var _count = buffer_read(_buffer, buffer_u64);
            repeat(_count)
            {
                var _leaderboardName = buffer_read(_buffer, buffer_string);
                var _value           = buffer_read(_buffer, buffer_u64);
                var _metadata        = buffer_read(_buffer, buffer_string);
                var _datetime        = buffer_read(_buffer, buffer_f64);
                var _pending         = buffer_read(_buffer, buffer_bool);
                
                var _offlineRecord = new __PodiumClassOfflineRecord(_value, _metadata, _datetime, _pending);
                
                var _leaderboardStruct = __PodiumLeaderboardFind(_leaderboardName);
                if (_leaderboardStruct == undefined)
                {
                    __PodiumWarning($"Found offline record for leaderboard \"{_leaderboardName}\" but that leaderboard doesn't exist");
                    _localData[$ _leaderboardName] = _offlineRecord;
                }
                else if (_leaderboardStruct.__GetOfflineRecordValid(_offlineRecord))
                {
                    _localData[$ _leaderboardName] = _offlineRecord;
                }
                else
                {
                    __PodiumTrace($"Removing old score for leaderboard \"{_leaderboardName}\"");
                }
            }
            
            var _footer = buffer_read(_buffer, buffer_string);
            buffer_delete(_buffer);
            
            if (_footer != "IUM")
            {
                throw "Failed to import data, footer not found";
            }
        }
        catch(_error)
        {
            if (is_string(_error))
            {
                __PodiumWarning(_error);
            }
            else
            {
                show_debug_message(_error);
                __PodiumWarning("Failed to decode buffer");
            }
            
            buffer_delete(_buffer);
            return false;
        }
        
        __localChanged = false;
        __localData = _localData;
        
        if (_submitPendingScores && PodiumGetUserSignedIn())
        {
            __PodiumLocalSubmitAllPending();
        }
        
        return true;
    }
    
    return false;
}