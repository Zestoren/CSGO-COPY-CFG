@ECHO OFF

:: Define your main steam account in STEAMID3 format [U:1:123456789] (provide only last numbers)
SET MAIN_ACC_STEAMID3=123456789





ECHO This BATCH script will copy your CSGO config from the main account to your smurf account

ECHO:

:: Define your Steam path by finding path to SteamClient.dll from registry
FOR /F "usebackq tokens=3*" %%A IN (`REG QUERY "HKCU\Software\Valve\Steam\ActiveProcess" /v SteamClientDll`) DO (
        SET STEAM_DLL_PATH=%%A %%B
    )

:: Remove "steamclient.dll" from the path
SET STEAM_DLL_PATH=%STEAM_DLL_PATH:steamclient.dll=%
ECHO Your Steam location: %STEAM_DLL_PATH%

:: Define your steam userdata path
SET USERDATA_PATH=%STEAM_DLL_PATH%userdata\

ECHO Your main account config folder: %USERDATA_PATH%%MAIN_ACC_STEAMID3%\730\local\cfg
ECHO:

CHOICE /C 12 /N /M "Press 1 to change config of the currently active Steam user or 2 to manually enter STEAMID user"

IF %ERRORLEVEL% EQU 1 (
        goto LOOP
    )

IF %ERRORLEVEL% EQU 2 (
        SET /p SMURF_ACC_STEAMID3="Enter your smurf STEAMID3 (only last numbers): "
        goto ENDLOOP
    )

:LOOP
FOR /F "usebackq tokens=3*" %%A IN (`REG QUERY "HKCU\Software\Valve\Steam\ActiveProcess" /v ActiveUser`) DO (
        SET SMURF_ACC_STEAMID3_HEX=%%A
    )

:: If you are not logged in
IF %SMURF_ACC_STEAMID3_HEX% EQU 0x0 (
    ECHO You are not logged in Steam. Please log in and try again.
    PAUSE
    goto LOOP
)

:ENDLOOP
:: CONVERT HEX TO DEC
SET /A SMURF_ACC_STEAMID3=%SMURF_ACC_STEAMID3_HEX%

:: If cfg folder does not exist then create it
IF NOT EXIST "%USERDATA_PATH%%SMURF_ACC_STEAMID3%\730\local\cfg" (
	    mkdir "%USERDATA_PATH%%SMURF_ACC_STEAMID3%\730\local\cfg"
	)

:: Copy your main config to another folder
ROBOCOPY "%USERDATA_PATH%%MAIN_ACC_STEAMID3%\730\local\cfg" "%USERDATA_PATH%%SMURF_ACC_STEAMID3%\730\local\cfg" /mir

PAUSE
