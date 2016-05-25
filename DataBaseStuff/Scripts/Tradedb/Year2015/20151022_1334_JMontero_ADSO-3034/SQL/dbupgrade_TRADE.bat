@echo off
REM Test parameters
IF %1NOTHING==NOTHING GOTO WARNING
IF %2NOTHING==NOTHING GOTO WARNING
IF %3NOTHING==NOTHING GOTO WARNING
IF %4NOTHING==NOTHING GOTO WARNING
REM
set ISQL="sqlcmd.exe"
set SQLCMDLOGINTIMEOUT=0
REM
echo Upgrading ICTS trade database (MS SQL Server) for issue #ADSO-3034 ...
REM ****************************************************************************
echo ********************************************************************************
echo Creating the riskmgr_win_def table ...
new_table_exists -S %1 -U %2 -P %3 -DB %4 -TB riskmgr_win_def
if errorlevel 1  goto upddoneN1
if errorlevel 0  goto updthisN1
goto upderrN1
:upddoneN1
echo The table riskmgr_win_defexists already!!
goto nextupdN1
:upderrN1
echo new_table_exists: Error occurred....
goto nextupdN1
:updthisN1
%ISQL% -S %1 -U %2 -P %3 -d %4 -w 132 -i NewTables\riskmgr_win_def.tbl
:nextupdN1
REM ****************************************************************************
echo Adding triggers for the riskmgr_win_def table .....
%ISQL% -S %1 -U %2 -P %3 -d %4 -w 200 -i AAA_riskmgr_win_def\riskmgr_win_def_deltrg.trg
%ISQL% -S %1 -U %2 -P %3 -d %4 -w 200 -i AAA_riskmgr_win_def\riskmgr_win_def_instrg.trg
%ISQL% -S %1 -U %2 -P %3 -d %4 -w 200 -i AAA_riskmgr_win_def\riskmgr_win_def_updtrg.trg
REM ********************************************************************************
echo ******************************************************************************** 
echo ********************************************************************************
echo Creating the riskmgr_win_pivot_def table ...
new_table_exists -S %1 -U %2 -P %3 -DB %4 -TB riskmgr_win_pivot_def
if errorlevel 1  goto upddoneN1
if errorlevel 0  goto updthisN1
goto upderrN1
:upddoneN1
echo The table riskmgr_win_pivot_def exists already!!
goto nextupdN1
:upderrN1
echo new_table_exists: Error occurred....
goto nextupdN1
:updthisN1
%ISQL% -S %1 -U %2 -P %3 -d %4 -w 132 -i NewTables\riskmgr_win_pivot_def.tbl
:nextupdN1
REM ****************************************************************************
echo Adding triggers for the riskmgr_win_pivot_def table .....
%ISQL% -S %1 -U %2 -P %3 -d %4 -w 200 -i AAA_riskmgr_win_pivot_def\riskmgr_win_pivot_def_deltrg.trg
%ISQL% -S %1 -U %2 -P %3 -d %4 -w 200 -i AAA_riskmgr_win_pivot_def\riskmgr_win_pivot_def_instrg.trg
%ISQL% -S %1 -U %2 -P %3 -d %4 -w 200 -i AAA_riskmgr_win_pivot_def\riskmgr_win_pivot_def_updtrg.trg
REM ********************************************************************************
echo ******************************************************************************** 
%ISQL% -S %1 -U %2 -P %3 -d %4 -w 132 -i grant.sql
echo Done
goto end
:WARNING
Echo Usage: dbupgrade_TRADE [server] [login] [password] [database]
:end
