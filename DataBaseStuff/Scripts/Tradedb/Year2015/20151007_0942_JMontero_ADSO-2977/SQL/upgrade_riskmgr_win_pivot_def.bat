@echo off
REM -----------------------------------------------------------
REM   Issue #ADSO-1702
REM -----------------------------------------------------------
sqlcmd -S %1 -U %2 -P %3 -d %4 -w 200 -i UUU_riskmgr_win_pivot_def_chgs\alter_riskmgr_win_pivot_def.sql
