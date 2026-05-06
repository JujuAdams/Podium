/// @param displayName
/// @param value
/// @param rank
/// @param userID
/// @param metadataString
/// @param offline

function __PodiumClassRecord(_displayName, _value, _rank, _userID, _metadataString, _offline) constructor
{
    name           = _displayName;
    value          = _value;
    rank           = _rank;
    userID         = _userID;
    metadataString = _metadataString;
    offline        = _offline; //Whether the score is from the local offline cache
    
    ////////////////////////////////////////////
    // DO NOT ADD METHODS TO THIS CONSTRUCTOR //
    ////////////////////////////////////////////
}