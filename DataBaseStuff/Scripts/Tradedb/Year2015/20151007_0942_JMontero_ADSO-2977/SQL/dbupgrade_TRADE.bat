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
echo Upgrading ICTS trade database (MS SQL Server) for issue #ADSO-2977 ...
REM ********************************************************************************
echo ********************************************************************************
echo Checking if exists the riskmgr_win_pivot_def table ...
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
%ISQL% -S %1 -U %2 -P %3 -d %4 -w 132 -i grant.sql
:nextupdN1
REM ********************************************************************************
echo Upgrading the riskmgr_win_pivot_def table ...
new_column_datatype_exists -S %1 -U %2 -P %3 -DB %4 -TB riskmgr_win_pivot_def -COLUMN pivot_layout -NEWDATATYPE varchar(max)
if errorlevel 1  goto upddone110
if errorlevel 0  goto updthis110
goto upderr110
:upddone110
echo The new datatype 'varchar(max)' for the column 'pivot_layout' has already existed in the 'riskmgr_win_pivot_def' table!!
goto nextupd110
:upderr110
echo new_column_datatype_exists: Error occurred....
goto nextupd110
:updthis110
call upgrade_riskmgr_win_pivot_def %1 %2 %3 %4
:nextupd110
REM ********************************************************************************
echo ******************************************************************************** 
echo Done
goto end
:WARNING
Echo Usage: dbupgrade_TRADE [server] [login] [password] [database]
:end
