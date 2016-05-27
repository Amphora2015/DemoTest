IF OBJECT_ID('CONFIRMMGR.PKG_TRADE_SUMMARY$P_UPDATE_TRADE_SUMMARY','P') IS NULL
EXEC('CREATE PROCEDURE  ConfirmMgr.PKG_TRADE_SUMMARY$P_UPDATE_TRADE_SUMMARY_CPTY_TRADE_ID AS SELECT GETDATE()')
GO
ALTER PROCEDURE [ConfirmMgr].[PKG_TRADE_SUMMARY$P_UPDATE_TRADE_SUMMARY_CPTY_TRADE_ID]
@p_trade_id		    int,
@p_cpty_trade_id	varchar(50)
AS
/******************************************************************************
*
* AUTHOR:		Javier Montero - 12/22/2015
* MODIFIED:		
* DB:			SQL SERVER 2012 OR HIGHER
* VERSION:		1.0
* DESCRIPTION:  
* DEPENDECIES:   
* CHANGES:		
*******************************************************************************/
DECLARE 
@error_msg		nvarchar(max),
@error_id		int,
@error_sev		int,
@error_sta		int,
@error_line		int
BEGIN
		BEGIN TRY
			IF(@p_trade_id) IS NOT NULL
			BEGIN
				UPDATE ts
				SET ts.CPTY_TRADE_ID = @p_cpty_trade_id
				FROM ConfirmMgr.TRADE_SUMMARY ts
				WHERE ts.TRADE_ID = @p_trade_id;
			END
		END TRY
		BEGIN CATCH
			IF @@ERROR > 0
			SELECT @error_msg  = ERROR_PROCEDURE() + ' FAIL: ' + ERROR_MESSAGE(),
				   @error_id = ERROR_NUMBER(),
				   @error_sev = ERROR_SEVERITY(),
				   @error_sta = ERROR_STATE(),
				   @error_line = ERROR_LINE();
			RAISERROR(@error_msg, @error_id, @error_sev, @error_sta, @error_line) WITH LOG
		END CATCH
END
GO
IF OBJECT_ID('CONFIRMMGR.PKG_TRADE_SUMMARY$P_UPDATE_TRADE_SUMMARY','P') IS NOT NULL
PRINT '<<< CREATED\ALTRED SPROC CONFIRMMGR.PKG_TRADE_SUMMARY$P_UPDATE_TRADE_SUMMARY >>>'
ELSE
PRINT '<<< FAILED TO CREATE\ALTRE SPROC CONFIRMMGR.PKG_TRADE_SUMMARY$P_UPDATE_TRADE_SUMMARY >>>'