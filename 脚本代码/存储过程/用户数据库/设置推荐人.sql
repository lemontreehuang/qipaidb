
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

-- ��ѯ����
CREATE PROC GSP_GP_ModifySpreader
	@dwUserID INT,								-- �û� I D
	@strPassword NCHAR(32),						-- �û�����
	@strSpreader NVARCHAR(32),					-- �Ƽ���
	@strClientIP NVARCHAR(15),					-- ���ӵ�ַ
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- �����Ϣ
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN

	-- ��������
	DECLARE @LogonPass AS NCHAR(32)
	DECLARE @SpreaderID AS NCHAR(32)

	-- ��ѯ�û�
	SELECT @SpreaderID=SpreaderID ,@LogonPass=LogonPass FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	-- �����ж�
	IF @LogonPass<>@strPassword
	BEGIN
		SET @strErrorDescribe=N'�����û����벻��ȷ��������Ϣ��ѯʧ�ܣ�'
		RETURN 1
	END
	
	-- �Ƽ���
	IF @strSpreader=N''
	BEGIN
		SET @strErrorDescribe=N'�Ƽ���Ϊ�գ�'
		RETURN 2
	END
	
	-- �Ƽ���
	IF @SpreaderID<>0
	BEGIN
		SET @strErrorDescribe=N'���Ѿ��������Ƽ��ˣ�'
		RETURN 3
	END
	
	DECLARE @SpreaderUserID AS INT
	-- ��ѯ�û�
	SELECT @SpreaderUserID=UserID FROM AccountsInfo WHERE Accounts=@strSpreader
	
	IF @SpreaderUserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'��������û�'+@strSpreader+N'�����ڣ�'
		RETURN 4
	END
	IF @SpreaderUserID = @dwUserID
	BEGIN
		SET @strErrorDescribe=N'�Ƽ��˲������Լ���'
		RETURN 5
	END
	-- �ƹ����
	DECLARE @RegisterGrantScore INT
	DECLARE @Note NVARCHAR(512)
	SET @Note = N'ע��'
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
	
	SET @strErrorDescribe=N'�����Ƽ��˳ɹ�����ϲ���� '+convert(varchar,@RegisterGrantScore)+N' �Ľ�ң�'
	
	SELECT @SpreaderUserID AS SpreaderID, @DestScore AS DestScore
		
END

RETURN 0

GO
