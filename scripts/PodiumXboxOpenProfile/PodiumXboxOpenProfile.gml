/// @param index
/// @param leaderboardName
/// @param range
/// @param [seasonOffset=0]

function PodiumXboxOpenProfile(_index, _leaderboardName, _range, _seasonOffset = 0)
{
    if (not PODIUM_USING_GDK) return;
    
    var _array = PodiumGetScores(_leaderboardName, _range, _seasonOffset);
    if (not is_array(_array)) return;
    
    if ((_index < 0) || (_index >= array_length(_array))) return;
    
    var _score = _array[_index];
    if (_score.userID != undefined)
    {
        xboxone_show_profile_card_for_user(PodiumGetUserID(), _score.userID);
    }
}