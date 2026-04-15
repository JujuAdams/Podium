/// Sets the user that has unlocked an achievement. You should call this function at least once
/// before calling `PodiumAward()`.
/// 
/// @param xboxUser

function PodiumSetXboxUser(_xboxUser)
{
    static _system = __PodiumSystem();
    
    if (PODIUM_USING_GDK)
    {
        _system.__xboxUser = int64(_xboxUser);
        
        if (PODIUM_VERBOSE)
        {
            __PodiumTrace($"Set Xbox user to {_xboxUser}");
        }
        
        //FIXME - It's possible for tokens to get confused if you set the Xbox user rapidly
        if (PODIUM_USING_PLAYFAB_LEADERBOARDS)
        {
            _system.__playFabLoggedIn = false;
            
            if (_xboxUser != 0)
            {
                __PodiumPlayFabXboxRequestToken();
            }
        }
    }
}