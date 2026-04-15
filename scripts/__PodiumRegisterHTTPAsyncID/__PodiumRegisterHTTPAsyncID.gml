/// @param asyncID
/// @param callbackFunction

function __PodiumRegisterHTTPAsyncID(_asyncID, _callbackFunction)
{
    static _asyncIDMap = __PodiumSystem().__httpAsyncIDMap;
    
    if (_asyncID == undefined)
    {
        __PodiumSoftError("Async ID must be an integer. Please report this error");
        return;
    }
    
    if (not is_callable(_callbackFunction))
    {
        __PodiumSoftError("Callback must be a valid function or script");
        return;
    }
    
    __PodiumEnsureControllerInstance();
    
    if (ds_map_exists(_asyncIDMap, _callbackFunction))
    {
        __PodiumWarning($"Redefining async ID {_asyncID}");
        
        var _oldCallbackFunction = _asyncIDMap[? _asyncID];
        _oldCallbackFunction(true);
    }
    
    _asyncIDMap[? _asyncID] = _callbackFunction;
}