#macro PODIUM_VERSION  "0.4.0-alpha"
#macro PODIUM_DATE     "2026-05-20"

#macro PODIUM_RUNNING_FROM_IDE  (GM_build_type == "run")

#macro PODIUM_ON_WINDOWS      (os_type == os_windows)
#macro PODIUM_ON_MACOS        (os_type == os_macosx)
#macro PODIUM_ON_LINUX        (os_type == os_linux)
#macro PODIUM_ON_DESKTOP      (PODIUM_ON_WINDOWS || PODIUM_ON_MACOS || PODIUM_ON_LINUX)
#macro PODIUM_ON_IOS          (os_type == os_ios)
#macro PODIUM_ON_ANDROID      (os_type == os_android)
#macro PODIUM_ON_MOBILE       (PODIUM_ON_IOS || PODIUM_ON_ANDROID)
#macro PODIUM_ON_XBOX_SERIES  (os_type == os_xboxseriesxs)
#macro PODIUM_ON_PS5          (os_type == os_ps5)
#macro PODIUM_ON_SWITCH       (os_type == os_switch)

#macro PODIUM_USING_STEAMWORKS            (PODIUM_ON_DESKTOP && extension_exists("Steamworks"))
#macro PODIUM_STEAM_AVAILABLE             (__PodiumSystem().__steamAvailable)
#macro PODIUM_USING_GAMECENTER            (PODIUM_ON_IOS && extension_exists("GameCenter"))
#macro PODIUM_USING_PLAY_SERVICES         (PODIUM_ON_ANDROID && extension_exists("GooglePlayServices"))
#macro PODIUM_PLAY_SERVICES_AVAILABLE     (__PodiumSystem().__playServicesAvailable)
#macro PODIUM_USING_GDK                   (PODIUM_ON_XBOX_SERIES || PODIUM_USING_WINDOWS_GDK)
#macro PODIUM_USING_WINDOWS_GDK           (PODIUM_ON_WINDOWS && extension_exists("GDKExtension"))
#macro PODIUM_USING_XBOX_LEADERBOARDS     (PODIUM_USING_GDK && (not PODIUM_GDK_USES_PLAYFAB_LEADERBOARDS))
#macro PODIUM_USING_PLAYFAB_LEADERBOARDS  (PODIUM_USING_GDK && PODIUM_GDK_USES_PLAYFAB_LEADERBOARDS)

#macro PODIUM_RANGE_TOP      0
#macro PODIUM_RANGE_FRIENDS  1
#macro PODIUM_RANGE_AROUND   2
#macro PODIUM_RANGE_USER     3

#macro PODIUM_USER_SIGN_IN_FAILED  -2
#macro PODIUM_USER_SIGNED_OUT      -1
#macro PODIUM_USER_SIGNING_IN       0
#macro PODIUM_USER_SIGNED_IN        1

///////
// State Constants
///////

// These constants are returned by `PodiumGetScoreState()` and reflect the state of received
// leaderboard data. These constants do not reflect the state of submitting states.

// Indicates there was an error receiving data. This means a request has been made and has failed.
#macro PODIUM_LEADERBOARD_ERROR   -1

// We do not have have any data nor have we sent a request. This state indicates that a request
// must be sent before any data may be received. A leaderboard initializes into this state, it will
// be reset to this state when a score is submitted to reflect the factor that the local user's
// score may be represented in leaderboard data, and a leaderboard will be reset to this date when
// `PodiumClearRemoteCache()` is called.
#macro PODIUM_LEADERBOARD_NOT_FETCHED  0

// A request has been queued or sent and we are waiting for a response.
#macro PODIUM_LEADERBOARD_WAITING  1

// A request has been sent and a response has been received. This does not necessarily mean that
// we received useful data and you should still check that the return value from `PodiumGetScores()`
// is valid (not `undefined`) before using it.
#macro PODIUM_LEADERBOARD_SUCCESS  2

///////
// Priority
///////

// No operation will be started. This priority can only be used by `PodiumGetScores()`. Using this
// priority with `PodiumSubmit()` will instead cause the operation to have its priority set to
// `PODIUM_PRIORITY_NORMAL`.
#macro PODIUM_PRIORITY_NO_REQUEST  -1

// The operation will be added to the back of the queue and will be dispatched when prior
// operations have completed.
#macro PODIUM_PRIORITY_NORMAL  0

// The operation will be added to the front of the queue and will be dispatched at the nearest
// opportunity ahead of enqueued operations. The operation will typically be dispatched at the
// start of the next step.
#macro PODIUM_PRIORITY_HIGH  1

// The operation will be dispatched immediately, ignoring any rate limits or ordering.
#macro PODIUM_PRIORITY_IMMEDIATE  2