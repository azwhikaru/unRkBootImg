@ECHO OFF

:: Get Label
SET bootImgPath="%1"

IF NOT EXIST %bootImgPath% (
	ECHO. && ECHO Please enter the directory of the BOOTIMG
	GOTO :EOF
)

:: Start Repack

ECHO.

ECHO Creating Temporary Directory...
IF EXIST "%CD%\Temp" (
    RD /S /Q "%CD%\Temp"
)
MKDIR Temp
ECHO Copying BOOTIMG...
dd.exe if=%bootImgPath% of=Temp/boot.cpio.gz bs=1 skip=8 1>nul 2>nul
ECHO Decompressing BOOTIMG...
gzip.exe -d -f -q Temp/boot.cpio.gz
ECHO Creating Ramdisk Directory...
MKDIR Temp\ramdisk
ECHO Decompressing RAMDISK...
CD Temp\ramdisk
..\..\cpio.exe -idm < ..\boot.cpio 1>nul 2>nul
ECHO Copying RAMDISK...
CD .. && CD..
IF EXIST "%CD%\ramdisk" (
    RD /S /Q "%CD%\ramdisk"
)
MOVE /Y Temp\ramdisk %CD% 1>nul 2>nul

:: Clean Up

ECHO Cleaning Up...
RD /S /Q "%CD%\Temp"
ECHO. && ECHO The output file is at %CD%\ramdisk

@ECHO ON