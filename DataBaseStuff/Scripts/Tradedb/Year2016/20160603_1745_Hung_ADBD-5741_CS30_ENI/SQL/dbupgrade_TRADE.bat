@echo off
REM Test parameters
IF %1NOTHING==NOTHING GOTO WARNING
IF %2NOTHING==NOTHING GOTO WARNING
IF %3NOTHING==NOTHING GOTO WARNING
IF %4NOTHING==NOTHING GOTO WARNING
REM
set ISQL="sqlcmd.exe"
REM
echo Upgrading ICTS trade database (MS SQL Server) for issues #ADSO-5741...
REM ********************************************************************************
echo ******************************************************************************** 
echo Create\Update stored proc's...
%ISQL% -S %1 -U %2 -P %3 -d %4 -w 132 -i UUU_other_chgs\fetchDeletedAllocForAllocNum.sp
%ISQL% -S %1 -U %2 -P %3 -d %4 -w 132 -i UUU_other_chgs\fetchDeletedAllocItemsForAlloc.sp
%ISQL% -S %1 -U %2 -P %3 -d %4 -w 132 -i UUU_other_chgs\fetchDeletedAllocItemsForTrade.sp
%ISQL% -S %1 -U %2 -P %3 -d %4 -w 132 -i UUU_other_chgs\fetchAllocItemToAssignTrade.sp
%ISQL% -S %1 -U %2 -P %3 -d %4 -w 132 -i UUU_other_chgs\fetchAllocationToEntityTag.sp
%ISQL% -S %1 -U %2 -P %3 -d %4 -w 132 -i UUU_other_chgs\fetchAllocItemToEntityTag.sp
%ISQL% -S %1 -U %2 -P %3 -d %4 -w 132 -i UUU_other_chgs\fetchActualToEntityTag.sp
REM ********************************************************************************
echo ******************************************************************************** 
echo Done
goto end
:WARNING
Echo Usage: dbupgrade_TRADE [server] [login] [password] [database]
:end