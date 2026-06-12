/// Encryption key for locally stored data. Please note that this is not a foolproof system and for
/// full security you should encrypt the string returned by `PodiumExportLocalData()` yourself. The
/// encryption key must be a 64-bit integer e.g. a number in the format of `0x0000_0000_0000_0000`.
/// 
/// N.B. Once set, you must never change this number. Keep a backup.
/// 
#macro PODIUM_OFFLINE_ENCRYPTION_KEY  undefined

/// Cipher key for Xbox user IDs when we pass them to PlayFab. The cipher key must be a 64-bit
/// integer e.g. a number in the format of `0x0000_0000_0000_0000`.
/// 
/// N.B. Once set, you must never change this number. Keep a backup.
/// 
#macro PODIUM_XBOX_USER_CIPHER  undefined

#macro PODIUM_OFFLINE_SCORE_VERSION  "1"

#macro PODIUM_DAILY_ROLLOVER_HOUR  0

/// The maximum length of time that a leaderboard cache is valid for before forcing a refresh. This
/// macro only applies on desktop and mobile platforms. Console platforms will never automatically
/// time-out a cache to avoid the anger of the Gods.
#macro PODIUM_GREEDY_CACHE_TIMEOUT  600 //seconds

#macro PODIUM_UNKNOWN_RANK  "??"

///////
// Platforms Controls
///////

/// Whether to force use of local data storage. This will ignore any remote or per-platform
/// services.
#macro PODIUM_FORCE_OFFLINE_ONLY  false

#macro PODIUM_SWITCH_NPLN_TENANT  ""

#macro PODIUM_SWITCH_SHOW_ERROR_VIEWER  true

#macro PODIUM_PSN_LEADERBOARD_SERVICE_LABEL  0

///////
// PlayFab
///////

//You must tick the "Allow client to post player statistics" box in the PlayFab backend. This can
//be found in the product / Settings / API Features.
#macro PODIUM_GDK_USES_PLAYFAB_LEADERBOARDS  false

//Found on PlayFab backend
#macro PODIUM_PLAYFAB_TITLE_ID  ""

//Found on PlayFab backend in the product / Settings / Secret Keys
#macro PODIUM_PLAYFAB_TITLE_SECRET  ""

///////
// Debug
///////

/// Whether to report lots of information messages to the console. This can be helpful to diagnose
/// problems. You will likely want to set this macro to `false` for production builds.
#macro PODIUM_VERBOSE  false

#macro PODIUM_VERBOSE_ASYNC  false

#macro PODIUM_WARNINGS_HAVE_CALLSTACKS  (PODIUM_RUNNING_FROM_IDE)

#macro PODIUM_DEBUG_IGNORE_LOCAL_IMPORT  false