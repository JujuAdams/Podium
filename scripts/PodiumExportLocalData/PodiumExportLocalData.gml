/// Returns an encoded string containing local scores.

function PodiumExportLocalData()
{
    static _system = __PodiumSystem();
    
    var _localData = _system.__localData;
    
    var _buffer = buffer_create(1024, buffer_grow, 1);
    buffer_write(_buffer, buffer_string, "POD");
    
    buffer_write(_buffer, buffer_u64, __PODIUM_OFFLINE_DATA_VERSION); //Version number
    
    var _namesArray = struct_get_names(_localData);
    buffer_write(_buffer, buffer_u64, array_length(_namesArray));
    
    var _i = 0;
    repeat(array_length(_namesArray))
    {
        var _name = _namesArray[_i];
        var _struct = _localData[$ _name];
        
        buffer_write(_buffer, buffer_string, _name);
        buffer_write(_buffer, buffer_u64,    _struct.__value);
        buffer_write(_buffer, buffer_string, _struct.__metadata);
        buffer_write(_buffer, buffer_f64,    _struct.__datetime);
        buffer_write(_buffer, buffer_bool,   _struct.__pending);
        
        ++_i;
    }
    
    buffer_write(_buffer, buffer_string, "IUM");
    
    //TODO - Encryption
    
    var _string = buffer_base64_encode(_buffer, 0, buffer_tell(_buffer));
    buffer_delete(_buffer);
    
    _system.__localChanged = false;
    
    return _string;
}