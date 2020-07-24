@echo off
set versionOLD= 0

REM Exit if the config file isn't there
if not exist wowpath.cfg (
	msg * Your wowpath.cfg isn't there SUKA!
	PAUSE
	exit
)

set /p WOWPath= < wowpath.cfg

REM Exit if the Path to WOW doesnt exist
if not exist "%WOWPath%" (
	msg * Ding Dong your wowpath is wrong! 
	PAUSE
	exit
)

REM If ElvUI is installed check the toc file for the installed version number
if exist %WOWPath%/ElvUI/ElvUI.toc (
		powershell -Command "Select-String -Path '%wowPath%\ElvUI\ElvUI.toc' -Pattern 'Version\: ([0-9]+.[0-9]+)' -AllMatches | %% { $_.Matches.Groups[1] } | %% { $_.Value } | Out-File tmpfile -Encoding ascii -NoNewline"
		set /p versionOLD= <tmpfile
		del tmpfile
)

powershell -Command "Invoke-WebRequest https://www.tukui.org/download.php?ui=elvui#version -OutFile elvui.html"
if errorlevel 1 (
	echo Error appeared, try again
	del elvui.html
	exit
)

powershell -Command "Select-String -Path elvui.html -Pattern '<b class=""Premium"""">([0-9]+.[0-9]+)</b>' -AllMatches | %% { $_.Matches.Groups[1] } | %% { $_.Value } | Out-File tmpfile -Encoding ascii -NoNewline"
if errorlevel 1 (
	echo Error appeared, try again
	del tmpfile
	exit
)

set /p version= < tmpfile
del tmpfile

if %versionOLD% LSS %version% (
	if not exist "elvui-%version%.zip" (
		powershell -Command "Invoke-WebRequest https://www.tukui.org/downloads/elvui-%version%.zip -OutFile elvui-%version%.zip"
		if errorlevel 1 (
			echo Error appeared, try again
			del elvui-%version%.zip
			exit
		)
	)
	powershell.exe -NoP -NonI -Command "Expand-Archive -Path '%CD%\elvui-%version%.zip' -DestinationPath '%wowPath%' -Force"
	if errorlevel 1 (
			echo Error appeared, try again
			del elvui-%version%.zip
			exit
	)
	echo Installed ElvUI version %version% succesfully
	PAUSE
	exit
) else (
	msg * Newest ElvUI version is already downloaded and installed BLYAT!
	PAUSE
	exit
)