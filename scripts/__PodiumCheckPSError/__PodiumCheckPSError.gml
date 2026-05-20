function __PodiumCheckPSError()
{
    static _system = __PodiumSystem();
    
    if (async_load < 0) return;
    
    var _errorCode = async_load[? "error_code"];
    if (_errorCode == undefined) return;
    
    if ((_errorCode = 0xFFFF_FFFF_8055_3407)
    ||  (_errorCode = 0xFFFF_FFFF_8055_0006)
    ||  (_errorCode = 0xFFFF_FFFF_8055_0007)
    ||  (_errorCode = 0xFFFF_FFFF_8055_000A))
    {
        __PodiumWarning("PlayStation async event returned \"not signed in\" error code");
        
        _system.__psGamepad   = -1;
        _system.__signInState = PODIUM_USER_SIGNED_OUT;
    }
}