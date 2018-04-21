
----------------------------------------------------------------------------------------------------

USE QPAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_ModifySpreader]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_ModifySpreader]
GO


SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- 查询资料
CREATE PROC GSP_GP_ModifySpreader
	@dwUserID INT,								-- 用户 I D
	@strPassword NCHAR(32),						-- 用户密码
	@strSpreader NVARCHAR(32),					-- 推荐人
	@strClientIP NVARCHAR(15),					-- 连接地址
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- 输出信息
WITH ENCRYPTION AS

-- 属性设置
SET NOCOUNT ON

-- 执行逻辑
BEGIN

	-- 变量定义
	DECLARE @LogonPass AS NCHAR(32)
	DECLARE @SpreaderID AS NCHAR(32)

	-- 查询用户
	SELECT @SpreaderID=SpreaderID ,@LogonPass=LogonPass FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	-- 密码判断
	IF @LogonPass<>@strPassword
	BEGIN
		SET @strErrorDescribe=N'您的用户密码不正确，个人信息查询失败！'
		RETURN 1
	END
	
	-- 推荐人
	IF @strSpreader=N''
	BEGIN
		SET @strErrorDescribe=N'推荐人为空！'
		RETURN 2
	END
	
	-- 推荐人
	IF @SpreaderID<>0
	BEGIN
		SET @strErrorDescribe=N'您已经设置了推荐人！'
		RETURN 3
	END
	
	DECLARE @SpreaderUserID AS INT
	-- 查询用户
	SELECT @SpreaderUserID=UserID FROM AccountsInfo WHERE Accounts=@strSpreader
	
	IF @SpreaderUserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'您输入的用户'+@strSpreader+N'不存在！'
		RETURN 4
	END
	IF @SpreaderUserID = @dwUserID
	BEGIN
		SET @strErrorDescribe=N'推荐人不能是自己！'
		RETURN 5
	END
	-- 推广提成
	DECLARE @RegisterGrantScore INT
	DECLARE @Note NVARCHAR(512)
	SET @Note = N'注册'
	SELECT @RegisterGrantScore = RegisterGrantScore FROM QPTreasureDBLink.QPTreasureDB.dbo.GlobalSpreadInfo
	IF @RegisterGrantScore IS NULL
	BEGIN
		SET @RegisterGrantScore=5000
	END
	INSERT INTO QPTreasureDBLink.QPTreasureDB.dbo.RecordSpreadInfo(
		UserID,Score,TypeID,ChildrenID,CollectNote)
	VALUES(@SpreaderUserID,@RegisterGrantScore,1,@dwUserID,@Note)		
	
	
	UPDATE QPTreasureDBLink.QPTreasureDB.dbo.GameScoreInfo SET Score=Score+@RegisterGrantScore
	WHERE UserID=@dwUserID
	
	UPDATE AccountsInfo SET SpreaderID=@SpreaderUserID
	WHERE UserID=@dwUserID
	
	UPDATE QPTreasureDBLink.QPTreasureDB.dbo.GameScoreInfo SET Score=Score+@RegisterGrantScore
	WHERE UserID=@SpreaderUserID
	
	DECLARE @DestScore BIGINT
	SELECT @DestScore=Score FROM QPTreasureDBLink.QPTreasureDB.dbo.GameScoreInfo WHERE UserID=@dwUserID
	
	SET @strErrorDescribe=N'设置推荐人成功，恭喜你获得 '+convert(varchar,@RegisterGrantScore)+N' 的金币！'
	
	SELECT @SpreaderUserID AS SpreaderID, @DestScore AS DestScore
		
END

RETURN 0

GO
