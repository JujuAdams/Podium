/// @param leaderboardName
/// @param value

function PodiumSubmit(_leaderboardName, _value)
{
    with(PodiumFind(_leaderboardName))
    {
        Push(_value);
    }
}