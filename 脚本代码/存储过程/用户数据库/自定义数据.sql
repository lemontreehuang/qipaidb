

USE QPAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_PublicNotic]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_PublicNotic]
GO


----------------------------------------------------------------------------------------------------

-- 插入头像
CREATE PROC GSP_GP_PublicNotic
	@strKeyName NVARCHAR(32),					-- 关键字
	@strErrorDescribe NVARCHAR(512) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 自定义数据
	SELECT @strErrorDescribe=StatusString FROM SystemStatusInfo WHERE StatusName=@strKeyName
	IF @strErrorDescribe IS NULL 
	BEGIN
		SET @strErrorDescribe = N'未找到关键字！'
		return 4		
	END

END	

RETURN 0


GO

----------------------------------------------------------------------------------------------------
