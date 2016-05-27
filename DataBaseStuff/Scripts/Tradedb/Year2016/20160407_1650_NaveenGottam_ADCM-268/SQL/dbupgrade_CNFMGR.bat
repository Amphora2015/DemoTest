@echo off
REM Test parameters
IF %1NOTHING==NOTHING GOTO WARNING
IF %2NOTHING==NOTHING GOTO WARNING
IF %3NOTHING==NOTHING GOTO WARNING
IF %4NOTHING==NOTHING GOTO WARNING
REM
set ISQL="sqlcmd.exe"
REM
echo Upgrading ICTS trade database (MS SQL Server) for issues #ADCM-268...
REM ********************************************************************************
echo ******************************************************************************** 
echo Updating a stored proc CONFIRMMGR.PKG_TRADE_SUMMARY$P_UPDATE_TRADE_SUMMARY...
%ISQL% -S %1 -U %2 -P %3 -d %4 -w 132 -i UUU_other_chgs\PKG_TRADE_SUMMARY$P_UPDATE_TRADE_SUMMARY_CPTY_TRADE_ID.sp
REM ********************************************************************************
echo ******************************************************************************** 
echo Done
goto end
:WARNING
Echo Usage: dbupgrade_TRADE [server] [login] [password] [database]
:end