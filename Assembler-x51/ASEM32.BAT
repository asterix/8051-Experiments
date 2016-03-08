@ECHO OFF
REM          64 MB Virtual Memory Support for ASEMX.EXE
REM          ==========================================
REM
REM Requires Borland's 32-bit DPMI server with virtual memory management!
REM
REM Files:   MAKESWAP.EXE     swap file generator
REM          DPMI32VM.OVL     32-bit DPMI server
REM             32RTM.EXE     32-bit runtime manager
REM
REM The above files are contained in Borland's
REM
REM  - Turbo-Assembler 4.0 and 5.0
REM  - Borland C++ 4.5 and 5.0
REM  - maybe others
REM
REM ... and cannot be provided with the ASEM-51 package for license reasons!
REM Please change the swap file size according to your requirements:
REM       !
REM       v
MAKESWAP 64M WORKFILE.SWP
SET DPMI32=SWAPFILE WORKFILE.SWP
32RTM
ASEMX %1 %2 %3 %4 %5 %6 %7 %8 %9
32RTM -u
SET DPMI32=
DEL WORKFILE.SWP
