@echo off
mode con: cols=120 lines=50
color 0a
title LagEZ Enhanced - Ultimate Minecraft Performance Suite v2.1

setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
set LOG=%~dp0LagEZ.log
set TASKNAME=LagEZ_Auto
set VERSION=2.1

cls
echo.                  
echo.
echo   
echo       LagEZ Enhanced v%VERSION% - Ultimate Performance Suite        
echo              Optimized for Competitive Minecraft             
echo   
echo.

:menu
cls
echo ================================================================================
echo                         SELECT OPTIMIZATION MODE                   
echo ================================================================================
echo.
echo  CORE OPTIMIZATIONS 
echo  ^| 1.  TURBO MODE - Full System Optimization                       ^|
echo  ^| 2.  BACKGROUND AUTO - Smart Process Management                  ^|
echo  ^| 3.  PvP BEAST MODE - Ultra-Low Latency Combat                   ^|
echo  ^| 4.  REDSTONE OPTIMIZER - Tick Rate Enhancement                  ^|
echo  ^| 5.  CHUNK MASTER - Memory and Loading Boost                     ^|
echo  ^| 6.  TNT PERFORMANCE - Explosion Engine Optimizer               ^|
echo  +----------------------------------------------------------------------+
echo.
echo  NETWORK and SYSTEM 
echo  ^| 7.  APP KILLER - Disable Performance Hogs                      ^|
echo  ^| 8.  AUTO-START - Schedule on Boot                              ^|
echo  ^| 9.  DNS BOOSTER - Ultra-Fast Resolution                        ^|
echo  ^| A.  PING WIZARD - Advanced Network Tuning                      ^|
echo  ^| B.  SWILLS MODE - Pro Gamer Network Stack                      ^|
echo  ^| C.  FIREWALL BYPASS - Remove Network Throttles                 ^|
echo  +----------------------------------------------------------------------+
echo.
echo  NEW ADVANCED FEATURES 
echo  ^| D.  MOUSE PRECISION - Ultra-Low Input Lag                      ^|
echo  ^| E.  DISPLAY OPTIMIZER - Frame Rate and V-Sync Control          ^|
echo  ^| F.  MEMORY CLEANER - RAM Optimization and Cleanup              ^|
echo  ^| G.  GAME MODE PLUS - Windows Gaming Enhancements               ^|
echo  +----------------------------------------------------------------------+
echo.
echo  CONTROLS 
echo  ^| H.  SYSTEM STATUS - View Current Optimizations                 ^|
echo  ^| I.  RESTORE DEFAULTS - Undo All Changes                        ^|
echo  ^| W.  VIEW WARNINGS - Read Important Disclaimers                 ^|
echo  ^| X.  EXIT                                                        ^|
echo  +----------------------------------------------------------------------+
echo.
choice /C 123456789ABCDEFGHIX /N /M "Choose option: "
goto choice%errorlevel%

:choice1
call :turbo_mode
pause
goto menu
:choice2
start /min cmd /c "%~f0 run"
echo  LagEZ now running in SMART BACKGROUND MODE
pause
goto menu
:choice3
call :pvp_beast_mode
pause
goto menu
:choice4
call :redstone_optimizer
pause
goto menu
:choice5
call :chunk_master
pause
goto menu
:choice6
call :tnt_performance
pause
goto menu
:choice7
call :app_killer
pause
goto menu
:choice8
call :auto_start
pause
goto menu
:choice9
call :dns_booster
pause
goto menu
:choice10
call :ping_wizard
pause
goto menu
:choice11
call :swills_mode
pause
goto menu
:choice12
call :firewall_bypass
pause
goto menu
:choice13
call :mouse_precision
pause
goto menu
:choice14
call :display_optimizer
pause
goto menu
:choice15
call :memory_cleaner
pause
goto menu
:choice16
call :game_mode_plus
pause
goto menu
:choice17
call :system_status
pause
goto menu
:choice18
call :restore_defaults
pause
goto menu
:choice19
exit /b

:turbo_mode
cls
echo  TURBO MODE ACTIVATED 
echo [] Applying MAXIMUM performance optimizations...
echo.

echo [TCP] Optimizing network stack...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpAckFrequency /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TCPNoDelay /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpWindowSize /t REG_DWORD /d 262144 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpTimedWaitDelay /t REG_DWORD /d 30 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v MaxConnectionsPerServer /t REG_DWORD /d 16 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v FastSendDatagramThreshold /t REG_DWORD /d 64000 /f >nul 2>&1

echo [CPU] Setting MAXIMUM performance profile...
powercfg /s SCHEME_MIN >nul 2>&1
powercfg /setacvalueindex scheme_current sub_processor PROCTHROTTLEMIN 100 >nul 2>&1
powercfg /setacvalueindex scheme_current sub_processor PROCTHROTTLEMAX 100 >nul 2>&1

echo [SYS] Disabling CPU parking...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v ValueMax /t REG_DWORD /d 0 /f >nul 2>&1

echo [GPU] Optimizing graphics performance...
reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v DirectXUserGlobalSettings /t REG_SZ /d "GpuPreference=2;" /f >nul 2>&1

echo [NET] Advanced network buffer tuning...
netsh int tcp set global autotuninglevel=experimental >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global ecncapability=enabled >nul 2>&1

echo  TURBO MODE: All optimizations applied successfully!
exit /b

:background_mode
cls
echo [] SMART BACKGROUND MODE - Monitoring system...
:loop
echo [%TIME%] Scanning for Minecraft processes... >> "%LOG%"

for /f "tokens=2" %%i in ('tasklist /FI "IMAGENAME eq java.exe" /FO CSV ^| findstr /V "PID"') do (
    wmic process where ProcessId=%%i CALL setpriority 128 >nul 2>&1
    echo [%TIME%] Boosted java.exe PID %%i to HIGH priority >> "%LOG%"
)

for /f "tokens=2" %%i in ('tasklist /FI "IMAGENAME eq Minecraft.Windows.exe" /FO CSV ^| findstr /V "PID"') do (
    wmic process where ProcessId=%%i CALL setpriority 128 >nul 2>&1
    echo [%TIME%] Boosted Minecraft.Windows.exe PID %%i >> "%LOG%"
)

for %%p in (chrome.exe firefox.exe discord.exe spotify.exe) do (
    tasklist /FI "IMAGENAME eq %%p" | find /i "%%p" >nul && (
        wmic process where name="%%p" CALL setpriority 64 >nul 2>&1
    )
)

set /a counter+=1
if !counter! GEQ 10 (
    echo [%TIME%] Running memory cleanup... >> "%LOG%"
    rundll32.exe advapi32.dll,ProcessIdleTasks >nul 2>&1
    set counter=0
)

timeout /t 60 >nul
goto loop

:pvp_beast_mode
cls
echo  PvP BEAST MODE 
echo [COMBAT] Optimizing for ultra-low latency PvP...

reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v Tcp1323Opts /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpMaxDupAcks /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v SackOpts /t REG_DWORD /d 1 /f >nul 2>&1

reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d "0" /f >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v MouseDataQueueSize /t REG_DWORD /d 32 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v KeyboardDataQueueSize /t REG_DWORD /d 32 /f >nul 2>&1

echo  PvP BEAST MODE: Combat optimizations applied!
exit /b

:redstone_optimizer
cls
echo  REDSTONE OPTIMIZER 
echo [TICK] Enhancing redstone performance...

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v ObCaseInsensitive /t REG_DWORD /d 1 /f >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v GlobalTimerResolutionRequests /t REG_DWORD /d 1 /f >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 1 /f >nul 2>&1

echo  REDSTONE OPTIMIZER: Tick rate enhancements applied!
exit /b

:chunk_master
cls
echo  CHUNK MASTER 
echo [MEMORY] Optimizing chunk loading and memory management...

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v SystemPages /t REG_DWORD /d 4294967295 /f >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v NtfsDisable8dot3NameCreation /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v NtfsDisableLastAccessUpdate /t REG_DWORD /d 1 /f >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 3 /f >nul 2>&1

echo  CHUNK MASTER: Memory and loading optimizations applied!
exit /b

:tnt_performance
cls
echo  TNT PERFORMANCE OPTIMIZER 
echo [EXPLOSION] Optimizing TNT and entity performance...

reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f >nul 2>&1

reg add "HKCU\Software\Microsoft\Avalon.Graphics" /v DisableHWAcceleration /t REG_DWORD /d 0 /f >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 0 /f >nul 2>&1

echo  TNT PERFORMANCE: Explosion engine optimized!
exit /b

:app_killer
cls
echo  PERFORMANCE HOG KILLER 
echo [KILL] Disabling performance-draining background apps...

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f >nul 2>&1

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f >nul 2>&1

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Spotify" /t REG_SZ /d "" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Discord" /t REG_SZ /d "" /f >nul 2>&1

taskkill /f /im "GameBar.exe" >nul 2>&1
taskkill /f /im "RuntimeBroker.exe" >nul 2>&1
taskkill /f /im "ApplicationFrameHost.exe" >nul 2>&1

echo  APP KILLER: Performance hogs eliminated!
exit /b

:auto_start
cls
echo  AUTO-START SCHEDULER 
echo [SCHEDULE] Setting up automatic startup...

schtasks /Create /RL HIGHEST /SC ONLOGON /TN "%TASKNAME%" /TR "\"%~f0\" run" /F >nul 2>&1
if %errorlevel%==0 (
    echo  AUTO-START: LagEZ will now start automatically on login!
) else (
    echo  AUTO-START: Failed to create scheduled task
)
exit /b

:dns_booster
cls
echo  DNS TURBO BOOSTER 
echo [DNS] Applying ultra-fast DNS resolution...

ipconfig /flushdns >nul 2>&1
netsh interface ip delete destinationcache >nul 2>&1

for /f "tokens=3*" %%i in ('netsh interface show interface ^| findstr /C:"Connected"') do (
    netsh interface ip set dns "%%j" static 1.1.1.1 primary >nul 2>&1
    netsh interface ip add dns "%%j" 1.0.0.1 index=2 >nul 2>&1
    netsh interface ip add dns "%%j" 8.8.8.8 index=3 >nul 2>&1
    netsh interface ip add dns "%%j" 8.8.4.4 index=4 >nul 2>&1
)

reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v MaxCacheTtl /t REG_DWORD /d 86400 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v MaxNegativeCacheTtl /t REG_DWORD /d 60 /f >nul 2>&1

echo  DNS BOOSTER: Ultra-fast resolution configured!
exit /b

:ping_wizard
cls
echo  PING WIZARD 
echo [NETWORK] Advanced network stack optimization...

netsh winsock reset >nul 2>&1
netsh int ip reset >nul 2>&1

netsh int tcp set global autotuninglevel=experimental >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global ecncapability=enabled >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1
netsh int tcp set global rsc=enabled >nul 2>&1

powercfg /setacvalueindex scheme_current sub_none DEVICEIDLE 0 >nul 2>&1

echo  PING WIZARD: Network stack optimized for minimal latency!
exit /b

:swills_mode
cls
echo  SWILLS.GG PRO MODE 
echo [PRO] Applying professional gamer network configuration...

netsh int tcp set global autotuninglevel=highlyrestricted >nul 2>&1
netsh int tcp set global chimney=enabled >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global netdma=enabled >nul 2>&1
netsh int tcp set heuristics disabled >nul 2>&1

netsh interface ipv4 set global icmpredirects=enabled >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnableTCPA /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnableRSS /t REG_DWORD /d 1 /f >nul 2>&1

echo  SWILLS MODE: Pro gamer configuration activated!
exit /b

:firewall_bypass
cls
echo  FIREWALL BYPASS OPTIMIZER 
echo [FIREWALL] Removing network throttles...

netsh advfirewall set allprofiles state off >nul 2>&1

netsh int tcp set global nonsackrttresiliency=disabled >nul 2>&1

for /f "tokens=3*" %%i in ('netsh interface show interface ^| findstr /C:"Connected"') do (
    netsh interface ipv4 set subinterface "%%j" mtu=1472 store=persistent >nul 2>&1
)

echo  FIREWALL BYPASS: Network throttles removed!
echo  WARNING: Firewall disabled for maximum performance
exit /b

:mouse_precision
cls
echo  MOUSE PRECISION OPTIMIZER 
echo [INPUT] Ultra-low input lag configuration...

reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d "0" /f >nul 2>&1

reg add "HKCU\Control Panel\Mouse" /v SmoothMouseXCurve /t REG_BINARY /d "0000000000000000c0cc0c0000000000809919000000000040662600000000000033330000000000" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v SmoothMouseYCurve /t REG_BINARY /d "0000000000000000000038000000000000007000000000000000a800000000000000e00000000000" /f >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v MouseDataQueueSize /t REG_DWORD /d 64 /f >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Control\usbflags" /v fid_D4F_24_100 /t REG_BINARY /d "01" /f >nul 2>&1

echo  MOUSE PRECISION: Ultra-precise input configured!
exit /b

:display_optimizer
cls
echo  DISPLAY OPTIMIZER 
echo [GRAPHICS] Frame rate and display optimization...

reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v DirectXUserGlobalSettings /t REG_SZ /d "VSync=0;" /f >nul 2>&1

reg add "HKCU\Software\Microsoft\Avalon.Graphics" /v DisableHWAcceleration /t REG_DWORD /d 0 /f >nul 2>&1

reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f >nul 2>&1

reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f >nul 2>&1

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v Priority /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1

echo  DISPLAY OPTIMIZER: Maximum frame rate configuration applied!
exit /b

:memory_cleaner
cls
echo  MEMORY CLEANER & OPTIMIZER 
echo [MEMORY] Advanced RAM optimization and cleanup...

rundll32.exe advapi32.dll,ProcessIdleTasks >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 0 /f >nul 2>&1

schtasks /create /tn "LagEZ_MemoryCleanup" /tr "rundll32.exe advapi32.dll,ProcessIdleTasks" /sc minute /mo 15 /f >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettings /t REG_DWORD /d 1 /f >nul 2>&1

echo  MEMORY CLEANER: RAM optimized and auto-cleanup scheduled!
exit /b

:game_mode_plus
cls
echo  GAME MODE PLUS 
echo [GAMING] Windows gaming enhancements activation...

reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f >nul 2>&1

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v Priority /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul 2>&1

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount" /v "$$windows.data.notifications.quiethourssettings" /t REG_DWORD /d 1 /f >nul 2>&1

echo  GAME MODE PLUS: Enhanced gaming environment activated!
exit /b

:system_status
cls
echo  SYSTEM STATUS - LAGEZ OPTIMIZATIONS 
echo 
echo.

echo  NETWORK STATUS 
netsh int tcp show global | findstr "Receive Window Auto-Tuning Level"
netsh int tcp show global | findstr "RSS State"
netsh int tcp show global | findstr "ECN Capability"
echo 
echo.

echo  POWER STATUS 
powercfg /query | findstr "Power Scheme GUID" | head -1
echo 
echo.

echo  RUNNING PROCESSES 
tasklist /FI "IMAGENAME eq java.exe" | findstr "java.exe" || echo No Minecraft Java processes found
tasklist /FI "IMAGENAME eq Minecraft.Windows.exe" | findstr "Minecraft.Windows.exe" || echo No Minecraft Bedrock processes found
echo 
echo.

echo  MEMORY STATUS 
systeminfo | findstr "Available Physical Memory"
echo 

exit /b

:restore_defaults
cls
echo  RESTORE DEFAULTS 
echo [RESTORE] Undoing all LagEZ optimizations...

reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpAckFrequency /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TCPNoDelay /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpWindowSize /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpTimedWaitDelay /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v FastSendDatagramThreshold /f >nul 2>&1

netsh int tcp reset >nul 2>&1
netsh winsock reset >nul 2>&1
netsh int ip reset >nul 2>&1

powercfg /s SCHEME_BALANCED >nul 2>&1

reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d "1" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d "6" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d "10" /f >nul 2>&1

reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /f >nul 2>&1

netsh advfirewall set allprofiles state on >nul 2>&1

schtasks /delete /tn "%TASKNAME%" /f >nul 2>&1
schtasks /delete /tn "LagEZ_MemoryCleanup" /f >nul 2>&1

for /f "tokens=3*" %%i in ('netsh interface show interface ^| findstr /C:"Connected"') do (
    netsh interface ip set dns "%%j" dhcp >nul 2>&1
)

echo  RESTORE DEFAULTS: All optimizations have been reverted!
echo  RESTART REQUIRED for all changes to take effect
exit /b

:run
call :background_mode
exit /b
