@ECHO OFF
ECHO                                                                         .
ECHO         ASEM-51 V1.3 Installation Procedure
ECHO         ===================================
ECHO                                                                         .
IF (%1)==() GOTO INSTHELP
ECHO This will install ASEM-51 V1.3 in %1
ECHO or update a previous ASEM-51 version in %1
ECHO                                                                         .
ECHO Press Enter, if you really want this!
ECHO If you want to install ASEM-51 in another location,
ECHO break with Ctrl-C, and invoke INSTALL.BAT again with
ECHO                                                                         .
ECHO                    INSTALL d:\path
ECHO                                                                         .
ECHO where "d:\path" is the destination disk and directory.
ECHO                                                                         .
PAUSE
ECHO Installing ASEM-51 in %1 ...
ECHO                                                                         .
IF NOT EXIST ASEM.EXE GOTO NOASEM
REM Create installation directory, if necessary:
IF NOT EXIST %1\ASEM.EXE MKDIR %1
COPY ASEM.EXE %1
IF NOT EXIST %1\ASEM.EXE GOTO NODEST
DEL %1\ASEM.EXE
REM Create subdirectory for processor definition files:
IF NOT EXIST %1\MCU\*.MCU MKDIR %1\MCU
REM Save user-written MCU files from a previous installation:
IF EXIST %1\*.MCU COPY %1\*.MCU %1\MCU
REM Copy files to installation directory:
COPY *.* %1
REM Copy processor definition files:
IF EXIST *.MCU COPY *.MCU %1\MCU
IF EXIST MCU\*.MCU COPY MCU\*.MCU %1\MCU
IF EXIST %1\*.MCU DEL %1\*.MCU
REM Copy HTML documentation:
IF NOT EXIST %1\HTML\*.HTM MKDIR %1\HTML
IF EXIST *.HTM COPY *.HTM %1\HTML
IF EXIST *.GIF COPY *.GIF %1\HTML
IF EXIST *.JPG COPY *.JPG %1\HTML
IF EXIST HTML\*.HTM COPY HTML\*.* %1\HTML
IF EXIST %1\*.HTM DEL %1\*.HTM
IF EXIST %1\*.GIF DEL %1\*.GIF
IF EXIST %1\*.JPG DEL %1\*.JPG
REM Delete legacy files from previous ASEM-51 versions:
IF EXIST %1\RESET.EXE DEL %1\RESET.EXE
IF EXIST %1\LOAD.BAT DEL %1\LOAD.BAT
IF EXIST %1\RELEASE.120 DEL %1\RELEASE.120
IF EXIST %1\UPDATES.DOC DEL %1\UPDATES.DOC
IF EXIST %1\MCU\83C51F.MCU DEL %1\MCU\83C51F.MCU
IF EXIST %1\MCU\83C517A.MCU DEL %1\MCU\83C517A.MCU
IF EXIST %1\RELEASE.110 DEL %1\RELEASE.110
IF EXIST %1\FILE_ID.DIZ DEL %1\FILE_ID.DIZ
ECHO                                                                         .
ECHO Done!
ECHO                                                                         .
ECHO The ASEM-51 installation directory %1
ECHO should now be appended to your PATH statement, and
ECHO the DOS environment variables ASEM51INC and DPMIMEM
ECHO should be set as follows:
ECHO                                                                         .
ECHO   PATH %PATH%;%1
ECHO   SET ASEM51INC=%1\MCU
ECHO   SET DPMIMEM=MAXMEM 16383
ECHO                                                                         .
ECHO Press Enter, if the corresponding modifications in file
ECHO AUTOEXEC.BAT should be done automatically!
ECHO (The previous AUTOEXEC.BAT will be renamed to AUTOEXEC.PRE!)
ECHO If you want to do this yourself, break with Ctrl-C now.
ECHO                                                                         .
PAUSE
IF NOT EXIST C:\AUTOEXEC.BAT GOTO NOAUTO
IF EXIST C:\AUTOEXEC.PRE GOTO PREEXIST
ECHO Saving C:\AUTOEXEC.BAT to C:\AUTOEXEC.PRE ...
ECHO                                                                         .
COPY C:\AUTOEXEC.BAT C:\AUTOEXEC.PRE
ECHO                                                                         .
:PREEXIST
ECHO Updating C:\AUTOEXEC.BAT ...
ECHO                                                                         .
COPY C:\AUTOEXEC.PRE C:\AUTOEXEC.BAT
ECHO PATH %PATH%;%1 >>C:\AUTOEXEC.BAT
ECHO SET ASEM51INC=%1\MCU >>C:\AUTOEXEC.BAT
ECHO SET DPMIMEM=MAXMEM 16383 >>C:\AUTOEXEC.BAT
ECHO                                                                         .
ECHO *****  Installation complete!  *****
ECHO                                                                         .
ECHO        Please reboot your PC.
GOTO END
:INSTHELP
ECHO To install ASEM-51 on your disk, go into the directory,
ECHO where INSTALL.BAT and all the other files of the ASEM-51
ECHO distribution archive are, and invoke INSTALL again with
ECHO                                                                         .
ECHO                    INSTALL d:\path
ECHO                                                                         .
ECHO where "d:\path" is the destination disk and directory.
ECHO                                                                         .
ECHO Example:           INSTALL C:\ASEM51
GOTO END
:NOASEM
ECHO File not found:  ASEM.EXE
ECHO                                                                         .
ECHO Go into the directory, where INSTALL.BAT and all the other files
ECHO of the ASEM-51 distribution archive are, and invoke INSTALL again!
GOTO END
:NODEST
ECHO Directory not found:  %1
GOTO END
:NOAUTO
ECHO File not found:  C:\AUTOEXEC.BAT
GOTO END
:END
ECHO                                                                         .
