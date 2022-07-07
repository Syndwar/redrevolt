@ECHO OFF
SET ENGINE_FOLDER="c:\git\stren\"

SET BIN_FOLDER=bin
SET PROJECT_FOLDER=%~dp0

CD %ENGINE_FOLDER%

CHOICE /M "Press R for Release or D for Debug:" /C RD
IF %ERRORLEVEL% EQU 1 (
    CALL build\make_and_install_release_x86.bat
)
IF %ERRORLEVEL% EQU 2 (
    CALL build\make_and_install_debug_x86.bat
)

IF EXIST %BIN_FOLDER% RMDIR "%BIN_FOLDER%" /s /q

XCOPY "%ENGINE_FOLDER%.install\bin" "%PROJECT_FOLDER%\%BIN_FOLDER%\" /E
XCOPY "%PROJECT_FOLDER%\src" "%PROJECT_FOLDER%\%BIN_FOLDER%\" /E

pause
