#macro PODIUM_VERSION  "1.0.0"
#macro PODIUM_DATE     "2026-04-17"

#macro PODIUM_RUNNING_FROM_IDE  (GM_build_type == "run")

#macro PODIUM_ON_WINDOWS                  (os_type == os_windows)
#macro PODIUM_ON_MACOS                    (os_type == os_macosx)
#macro PODIUM_ON_LINUX                    (os_type == os_linux)
#macro PODIUM_ON_DESKTOP                  (PODIUM_ON_WINDOWS || PODIUM_ON_MACOS || PODIUM_ON_LINUX)
#macro PODIUM_ON_IOS                      (os_type == os_ios)
#macro PODIUM_ON_ANDROID                  (os_type == os_android)
#macro PODIUM_ON_XBOX_SERIES              (os_type == os_xboxseriesxs)
#macro PODIUM_ON_PS5                      (os_type == os_ps5)
#macro PODIUM_ON_SWITCH                   (os_type == os_switch)

#macro PODIUM_USING_STEAMWORKS            (PODIUM_ON_DESKTOP && extension_exists("Steamworks"))
#macro PODIUM_USING_GAMECENTER            (PODIUM_ON_IOS && extension_exists("GameCenter"))
#macro PODIUM_USING_PLAY_SERVICES         (PODIUM_ON_ANDROID && extension_exists("GooglePlayServices"))
#macro PODIUM_USING_GDK                   (PODIUM_ON_XBOX_SERIES || PODIUM_USING_WINDOWS_GDK)
#macro PODIUM_USING_WINDOWS_GDK           (PODIUM_ON_WINDOWS && extension_exists("GDKExtension"))
#macro PODIUM_USING_XBOX_LEADERBOARDS     (PODIUM_USING_GDK && (not PODIUM_GDK_USES_PLAYFAB_LEADERBOARDS))
#macro PODIUM_USING_PLAYFAB_LEADERBOARDS  (PODIUM_USING_GDK && PODIUM_GDK_USES_PLAYFAB_LEADERBOARDS)

#macro PODIUM_REFRESH_NEVER    0
#macro PODIUM_REFRESH_DAILY    1
#macro PODIUM_REFRESH_WEEKLY   2
#macro PODIUM_REFRESH_MONTHLY  3

#macro PODIUM_RANGE_TOP      0
#macro PODIUM_RANGE_FRIENDS  1
#macro PODIUM_RANGE_AROUND   2

#macro PODIUM_STATE_UNKNOWN    -3
#macro PODIUM_STATE_CANCELLED  -2
#macro PODIUM_STATE_ERROR      -1
#macro PODIUM_STATE_NO_DATA     0
#macro PODIUM_STATE_PENDING     1
#macro PODIUM_STATE_SUCCESS     2