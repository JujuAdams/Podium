/// @param value
/// @param config

function __PodiumConvertToSubmitScore(_value, _config)
{
    return _value * power(10, _config.decimalPlaces);
}