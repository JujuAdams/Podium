function __PodiumClassOpCommon() constructor
{
    static _system            = __PodiumSystem();
    static _queuedSubmitArray = _system.__queuedSubmitArray;
    static _queuedFetchArray  = _system.__queuedFetchArray;
    static _pendingArray      = _system.__pendingArray;
    static _activityArray     = _system.__activityArray;
    
    __dispatched       = false;
    __completed        = false;
    __activityTime     = infinity;
    __asyncID          = undefined;
    __status           = undefined
    __callback         = undefined;
    __callbackMetadata = undefined;
}