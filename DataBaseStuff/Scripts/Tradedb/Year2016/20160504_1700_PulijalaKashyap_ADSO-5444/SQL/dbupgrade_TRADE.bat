@echo off
REM Test parameters
IF %1NOTHING==NOTHING GOTO WARNING
IF %2NOTHING==NOTHING GOTO WARNING
IF %3NOTHING==NOTHING GOTO WARNING
IF %4NOTHING==NOTHING GOTO WARNING
REM
set ISQL="sqlcmd.exe"
REM
echo Upgrading ICTS trade database (MS SQL Server) for issues #ADSO-5444...
REM ********************************************************************************
echo ******************************************************************************** 
echo Upgrading the riskmgr_win_pivot_def table (add asof_date column) ...
new_column_exists -S %1 -U %2 -P %3 -DB %4 -TB riskmgr_win_pivot_def -COLUMN asof_date
if errorlevel 1  goto upddoneU5
if errorlevel 0  goto updthisU5
goto upderrU5
:upddoneU5
echo The column 'asof_date' has already existed in the 'riskmgr_win_pivot_def' table!!
goto nextupdU5
:upderrU5
echo new_column_exists: Error occurred....
goto nextupdU5
:updthisU5
call upgrade_riskmgr_win_pivot_def %1 %2 %3 %4
:nextupdU5
REM ********************************************************************************
echo ********************************************************************************
echo Adding reference data into the new_num table ...
%ISQL% -S %1 -U %2 -P %3 -d %4 -w 132 -i UUU_refdata_chgs\add_new_num_data.sql
REM ********************************************************************************
echo ********************************************************************************
echo Updating db objects related to the riskmgr_win_pivot_def table ...
%ISQL% -S %1 -U %2 -P %3 -d %4 -w 132 -i AAA_riskmgr_win_pivot_def\riskmgr_win_pivot_def_deltrg.trg
%ISQL% -S %1 -U %2 -P %3 -d %4 -w 132 -i AAA_riskmgr_win_pivot_def\riskmgr_win_pivot_def_updtrg.trg
REM ********************************************************************************
echo ********************************************************************************
echo Done
goto end
:WARNING
Echo Usage: dbupgrade_TRADE [server] [login] [password] [database]
:end