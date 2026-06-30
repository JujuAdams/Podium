/// @param string
/// @param [submitPendingScores=true]

function PodiumImportLocalData(_string, _submitPendingScores = true)
{
    static _system = __PodiumSystem();
    
    if (PODIUM_OFFLINE_ENCRYPTION_KEY == undefined)
    {
        __PodiumError("Please set `PODIUM_OFFLINE_ENCRYPTION_KEY` to an unsigned 64-bit integer\nThis is a number in the format of `0x0000_0000_0000_0000`");
    }
    
    if (PODIUM_OFFLINE_ENCRYPTION_KEY == 0x0000_0000_0000_0000)
    {
        __PodiumError("Encryption key cannot literally be `0x0000_0000_0000_0000`. Choose another random number");
    }
    
    with(_system)
    {
        if (not __initialized)
        {
            __PodiumError("Cannot import data, Podium has not been initialized");
            return;
        }
        
        var _buffer = -1;
        var _compressedBuffer = -1;
        try
        {
            var _compressedBuffer = buffer_base64_decode(_string);
            
            if (not buffer_exists(_compressedBuffer))
            {
                throw "Base64 decode failed";
            }
            
            if (buffer_get_size(_compressedBuffer) >= 16)
            {
                buffer_poke(_compressedBuffer, 8, buffer_u64, PODIUM_OFFLINE_ENCRYPTION_KEY ^ buffer_peek(_compressedBuffer, 8, buffer_u64));
            }
            
            var _buffer = buffer_decompress(_compressedBuffer);
            
            if (not buffer_exists(_buffer))
            {
                throw "Decompression failed";
            }
        }
        catch(_error)
        {
            show_debug_message(_error);
            __PodiumWarning("Failed to decode string");
            return false;
        }
        finally
        {
            if (buffer_exists(_compressedBuffer))
            {
                buffer_delete(_compressedBuffer);
            }
        }
        
        var _offlineRecordDict = {};
        
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
            if (_version == __PODIUM_OFFLINE_DATA_VERSION)
            {
                var _scoreVersion = buffer_read(_buffer, buffer_string);
            }
            else
            {
                throw $"Failed to import data, version not `{__PODIUM_OFFLINE_DATA_VERSION}`";
            }
            
            if (_scoreVersion != string(PODIUM_OFFLINE_SCORE_VERSION))
            {
                throw $"Score version mismatch, found (`{_scoreVersion}` versus expected macro value `{PODIUM_OFFLINE_SCORE_VERSION}`)";
            }
            
            var _count = buffer_read(_buffer, buffer_u64);
            repeat(_count)
            {
                var _leaderboardName = buffer_read(_buffer, buffer_string);
                var _value           = buffer_read(_buffer, buffer_u64);
                var _metadata        = buffer_read(_buffer, buffer_string);
                var _datetime        = buffer_read(_buffer, buffer_f64);
                var _pending         = bool(buffer_read(_buffer, buffer_bool));
                
                var _offlineRecord = new __PodiumClassOfflineRecord(_value, _metadata, _datetime, _pending);
                
                var _leaderboardStruct = __PodiumLeaderboardFind(_leaderboardName);
                if (_leaderboardStruct == undefined)
                {
                    __PodiumWarning($"Found offline record for leaderboard \"{_leaderboardName}\" but that leaderboard doesn't exist");
                    _offlineRecordDict[$ _leaderboardName] = _offlineRecord;
                }
                else if (_leaderboardStruct.__GetOfflineRecordValid(_offlineRecord))
                {
                    _offlineRecordDict[$ _leaderboardName] = _offlineRecord;
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
        __offlineRecordDict = _offlineRecordDict;
        
        if (_submitPendingScores && PodiumGetSignedIn())
        {
            __PodiumSubmitAllPendingOfflineRecords();
        }
        
        return true;
    }
    
    return false;
}