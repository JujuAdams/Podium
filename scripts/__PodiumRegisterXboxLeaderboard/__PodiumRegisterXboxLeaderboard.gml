/// @param callbackFunction

function __PodiumRegisterXboxLeaderboard(_callbackFunction)
{
    static _system = __PodiumSystem();
    with(_system)
    {
        if (not is_callable(_callbackFunction))
        {
            __PodiumSoftError("Callback must be a valid function or script");
            return;
        }
        
        if (is_callable(__xboxLeaderboardCallback))
        {
            __PodiumWarning($"Redefining Xbox leaderboard callback");
            __xboxLeaderboardCallback(true);
        }
        
        __xboxLeaderboardCallback = _callbackFunction;
    }
}