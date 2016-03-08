@ECHO OFF
REM           Will be invoked by BOOT.BAT.
REM           Do not edit or run UPLOAD.BAT directly!
REM
IF (%6)==() GOTO USAGE
IF NOT (%7)==() GOTO USAGE
REM initialize serial port %1 to baudrate %2:
IF (%2)==(110) GOTO STANDARD
IF (%2)==(150) GOTO STANDARD
IF (%2)==(300) GOTO STANDARD
IF (%2)==(600) GOTO STANDARD
IF (%2)==(1200) GOTO STANDARD
IF (%2)==(2400) GOTO STANDARD
IF (%2)==(4800) GOTO STANDARD
IF (%2)==(9600) GOTO STANDARD
REM set non-standard baudrates:
COMPORT %1 %2
IF ERRORLEVEL 1 GOTO END
GOTO BAUDSET
:STANDARD
REM set standard baudrates:
MODE %1:%2,N,8,1,P
IF ERRORLEVEL 1 GOTO END
:BAUDSET
REM reset target system via port %4:
ECHO .
ECHO      resetting target system ...
RESET51 %4 %5
IF ERRORLEVEL 1 GOTO END
REM wait for 2 * %5 ms to recover from reset:
RESET51 NUL %5
IF ERRORLEVEL 1 GOTO END
RESET51 NUL %5
IF ERRORLEVEL 1 GOTO END
REM wait until BOOT-51 has output its sign-on message:
REM (important on fast computers with short programs)
SLEEP %2
IF ERRORLEVEL 1 GOTO END
REM assemble program:
ASEM %6
IF ERRORLEVEL 1 GOTO END
REM upload Intel-HEX file to target system:
ECHO U >%1
ECHO .
ECHO      uploading file %6.HEX ...
ECHO .
SLEEP %2 4
COPY %6.HEX %1
SLEEP %2 4
REM start program at location %3:
ECHO G %3 >%1
GOTO END
:USAGE
ECHO .
ECHO      usage:         BOOT source
ECHO .
:END
