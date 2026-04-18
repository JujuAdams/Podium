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
        
        if (_xboxUser > 0)
        {
            if (PODIUM_USING_XBOX_LEADERBOARDS)
            {
                xboxone_stats_add_user(_xboxUser);
            }
            else if (PODIUM_USING_PLAYFAB_LEADERBOARDS)
            {
                //FIXME - It's possible for tokens to get confused if you set the Xbox user rapidly
                
                _system.__playFabLoggedIn = false;
                
                __PodiumPlayFabXboxRequestToken();
            }
        }
    }
}