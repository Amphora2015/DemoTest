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
echo Validating Logs Folder
REM
cd logs
if errorlevel 1 goto dirnotexists
if exist *.log del *.log
cd ..
goto start
:dirnotexists
echo So, the folder 'logs' doesn't exist...create it now
mkdir logs
goto start
REM
:start
echo Upgrading ICTS trade database (MS SQL Server) for issue #ADSO-2713 ...
REM ********************************************************************************
echo ******************************************************************************** 
echo checking if exists table riskmgr_win_def ...
new_table_exists -S %1 -U %2 -P %3 -DB %4 -TB riskmgr_win_def
if errorlevel 1  goto upddoneN1
if errorlevel 0  goto updthisN1
goto upderrN1
:upddoneN1
echo The table 'riskmgr_win_def' exists already!!
goto nextupdN1
:upderrN1
echo new_table_exists: Error occurred....
goto nextupdN1
:updthisN1
echo Creating new table riskmgr_win_def ...
%ISQL% -S %1 -U %2 -P %3 -d %4 -w 132 -i NewTables\riskmgr_win_def.tbl >> logs\riskmgr_win_def.log
goto nextupdU2
:nextupdN1
REM ********************************************************************************
echo ********************************************************************************
echo Altering the riskmgr_win_def table...
%ISQL% -S %1 -U %2 -P %3 -d %4 -w 132 -i uuu_riskmgr_win_def\uuu_riskmgr_win_def.sql >> logs\uuu_riskmgr_win_def.log
goto nextupdU2
:nextupdU2
REM ********************************************************************************
echo checking if exists table riskmgr_win_pivot_def ...
new_table_exists -S %1 -U %2 -P %3 -DB %4 -TB riskmgr_win_pivot_def
if errorlevel 1  goto upddoneN2
if errorlevel 0  goto updthisN2
goto upderrN2
:upddoneN2
echo The table 'riskmgr_win_pivot_def' exists already!!
goto nextupdN2
:upderrN2
echo new_table_exists: Error occurred....
goto nextupdN3
:updthisN2
echo Creating new table riskmgr_win_def ...
%ISQL% -S %1 -U %2 -P %3 -d %4 -w 132 -i NewTables\riskmgr_win_pivot_def.tbl >> logs\riskmgr_win_pivot_def.log
echo Creating Foreign Keys(s)
%ISQL% -S %1 -U %2 -P %3 -d %4 -w 132 -i UUU_riskmgr_win_pivot_def\riskmgr_win_pivot_def.con >> logs\riskmgr_win_pivot_def_cons.log
goto nextupdU3
:nextupdN2
REM ********************************************************************************
echo ********************************************************************************
echo Altering the riskmgr_win_pivot_def table...
%ISQL% -S %1 -U %2 -P %3 -d %4 -w 132 -i UUU_riskmgr_win_pivot_def\uuu_riskmgr_win_pivot_def.sql >> logs\uuu_riskmgr_win_pivot_def.log
:nextupdU3
REM ********************************************************************************
echo ********************************************************************************
REM
echo Done
goto end
:WARNING
Echo Usage: dbupgrade_TRADE [server] [login] [password] [database]
:end

