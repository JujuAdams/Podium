/// Returns an encoded string containing local scores.

function PodiumExportLocalData()
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
    
    var _offlineRecordDict = _system.__offlineRecordDict;
    
    var _buffer = buffer_create(1024, buffer_grow, 1);
    buffer_write(_buffer, buffer_string, "POD");
    
    buffer_write(_buffer, buffer_u64, __PODIUM_OFFLINE_DATA_VERSION); //Version number
    
    var _namesArray = struct_get_names(_offlineRecordDict);
    buffer_write(_buffer, buffer_u64, array_length(_namesArray));
    
    var _i = 0;
    repeat(array_length(_namesArray))
    {
        var _name = _namesArray[_i];
        var _struct = _offlineRecordDict[$ _name];
        
        buffer_write(_buffer, buffer_string, _name);
        buffer_write(_buffer, buffer_u64,    _struct.__value);
        buffer_write(_buffer, buffer_string, _struct.__metadata);
        buffer_write(_buffer, buffer_f64,    _struct.__datetime);
        buffer_write(_buffer, buffer_bool,   _struct.__pending);
        
        ++_i;
    }
    
    buffer_write(_buffer, buffer_string, "IUM");
    
    var _compressedBuffer = buffer_compress(_buffer, 0, buffer_tell(_buffer));
    buffer_delete(_buffer);
    
    if (buffer_get_size(_compressedBuffer) >= 16)
    {
        buffer_poke(_compressedBuffer, 8, buffer_u64, PODIUM_OFFLINE_ENCRYPTION_KEY ^ buffer_peek(_compressedBuffer, 8, buffer_u64));
    }
    
    var _string = buffer_base64_encode(_compressedBuffer, 0, buffer_get_size(_compressedBuffer));
    buffer_delete(_compressedBuffer);
    
    _system.__localChanged = false;
    
    return _string;
}