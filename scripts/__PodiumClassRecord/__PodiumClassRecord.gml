/// @param displayName
/// @param value
/// @param rank
/// @param userID
/// @param metadataString
/// @param local

function __PodiumClassRecord(_displayName, _value, _rank, _userID, _metadataString, _local) constructor
{
    name           = _displayName;
    value          = _value;
    rank           = _rank;
    userID         = _userID;
    metadataString = _metadataString;
    local          = _local; //Whether the score is from the local offline cache
    
    ////////////////////////////////////////////
    // DO NOT ADD METHODS TO THIS CONSTRUCTOR //
    ////////////////////////////////////////////
}