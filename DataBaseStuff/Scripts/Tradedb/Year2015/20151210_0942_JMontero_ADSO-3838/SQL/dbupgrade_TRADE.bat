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
echo Upgrading ICTS trade database (MS SQL Server) for issue #ADSO-3838 ...
REM ********************************************************************************
echo ********************************************************************************
echo Checking if exists the topic_portfolio_mappings table ...
new_table_exists -S %1 -U %2 -P %3 -DB %4 -TB topic_portfolio_mappings
if errorlevel 0  goto updthisN1
if errorlevel 1  goto upddoneN1
goto upderrN1
:upddoneN1
echo The table topic_portfolio_mappings exists already!!
goto nextupdN1
:upderrN1
echo new_table_exists: Error occurred....
goto nextupdN1
:updthisN1
%ISQL% -S %1 -U %2 -P %3 -d %4 -w 132 -i NewTables\topic_portfolio_mappings.tbl
:nextupdN1
REM ********************************************************************************
echo Checking if exists the rabbitmq_security_auth table ...
new_table_exists -S %1 -U %2 -P %3 -DB %4 -TB rabbitmq_security_auth
if errorlevel 0  goto updthisN1
if errorlevel 1  goto upddoneN1
goto upderrN1
:upddoneN1
echo The table rabbitmq_security_auth exists already!!
goto nextupdN1
:upderrN1
echo new_table_exists: Error occurred....
goto nextupdN1
:updthisN1
%ISQL% -S %1 -U %2 -P %3 -d %4 -w 132 -i NewTables\rabbitmq_security_auth.tbl
:nextupdN1
REM ********************************************************************************
echo ******************************************************************************** 
echo Done
%ISQL% -S %1 -U %2 -P %3 -d %4 -w 132 -i grant.sql
goto end
:WARNING
Echo Usage: dbupgrade_TRADE [server] [login] [password] [database]
:end
