@echo off
setlocal
REM Move this kit into CoTemp and create a Desktop shortcut
set "SRC=%~dp0"
set "CT=%USERPROFILE%\Downloads\CoTemp"
if not exist "%CT%" mkdir "%CT%"
if not exist "%CT%\tools" mkdir "%CT%\tools"

REM Copy files
copy /Y "%SRC%Start-CoPayloadRunner.cmd" "%CT%\" >nul
copy /Y "%SRC%tools\CoPayloadRunner.ps1" "%CT%\tools\" >nul
copy /Y "%SRC%tools\CoSign-Text.ps1" "%CT%\tools\" >nul
copy /Y "%SRC%tools\CoAgent_SendHealth.ps1" "%CT%\tools\" >nul
copy /Y "%SRC%Send CoAgent Health (Manual).cmd" "%CT%\" >nul

REM Create Desktop shortcut for Runner
> "%TEMP%\mklnk.vbs" echo Set s=CreateObject("WScript.Shell")
>>"%TEMP%\mklnk.vbs" echo desk=s.SpecialFolders("Desktop")
>>"%TEMP%\mklnk.vbs" echo Set a=s.CreateShortcut(desk ^& "\CoPayloadRunner (Manual).lnk")
>>"%TEMP%\mklnk.vbs" echo a.TargetPath = "%CT%\Start-CoPayloadRunner.cmd"
>>"%TEMP%\mklnk.vbs" echo a.WorkingDirectory = "%CT%"
>>"%TEMP%\mklnk.vbs" echo a.IconLocation = "%SystemRoot%\System32\shell32.dll,46"
>>"%TEMP%\mklnk.vbs" echo a.Save
cscript //nologo "%TEMP%\mklnk.vbs" >nul
del "%TEMP%\mklnk.vbs" >nul 2>&1

REM Drop a sample HH zip into Downloads for testing
set "DL=%USERPROFILE%\Downloads"
copy /Y "%SRC%HH_SAMPLE.zip" "%DL%\HH_SAMPLE.zip" >nul

echo.
echo [OK] Installed to: %CT%
echo [OK] Shortcut: Desktop\CoPayloadRunner (Manual).lnk
echo [OK] Sample:   %DL%\HH_SAMPLE.zip
echo.
echo How to test:
echo   1) Double-click the Desktop shortcut to start the runner.
echo   2) In Explorer, double-click HH_SAMPLE.zip in Downloads.
echo   3) A CoPong markdown will open in Notepad with the result.
echo.
pause
