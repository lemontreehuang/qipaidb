----------------------------------------------------------------------
-- ��Ȩ��2011
-- ʱ�䣺2011-09-1
-- ��;�����߶���
----------------------------------------------------------------------

USE [QPTreasureDB]
GO

-- ÿ��ǩ��
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].NET_PW_WriteCheckIn') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].NET_PW_WriteCheckIn
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------------------
-- ÿ��ǩ��
CREATE PROCEDURE NET_PW_WriteCheckIn
	@dwUserID			INT,					-- �û���ʶ	
	@strClientIP		NVARCHAR(15),			-- ǩ����ַ
	@strErrorDescribe	NVARCHAR(127) OUTPUT	-- �����Ϣ
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- �ʺ�����
DECLARE @UserID INT
DECLARE @Nullity TINYINT
DECLARE @StunDown TINYINT

-- ��¼��Ϣ
DECLARE @RecordID INT

-- ִ���߼�
BEGIN
	-- ��֤�û�
	SELECT @UserID=UserID,@Nullity=Nullity,@StunDown=StunDown
	FROM QPAccountsDBLink.QPAccountsDB.dbo.AccountsInfo
	WHERE UserID=@dwUserID

	IF @UserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'��Ǹ����Ҫǩ�����û��˺Ų����ڡ�'
		RETURN 1
	END

	IF @Nullity=1
	BEGIN
		SET @strErrorDescribe=N'��Ǹ����Ҫǩ�����û��˺���ʱ���ڶ���״̬������ϵ�ͻ����������˽���ϸ�����'
		RETURN 2
	END

	IF @StunDown<>0
	BEGIN
		SET @strErrorDescribe=N'��Ǹ����Ҫǩ�����û��˺�ʹ���˰�ȫ�رչ��ܣ��������¿�ͨ����ܼ���ʹ�á�'
		RETURN 3
	END

	-- ��¼��ѯ
	SELECT @RecordID=RecordID FROM RecordCheckIn WHERE UserID=@dwUserID AND DATEDIFF(D,CollectDate,GETDATE())=0 
	IF @RecordID IS NOT NULL
	BEGIN
		SET @strErrorDescribe=N'��Ǹ����������ǩ��,�����ظ�������'
		RETURN 4
	END

	-- ǩ���߼�
	DECLARE @dwPresentGold	INT  -- ������ȡ���
	DECLARE @dwPresentCount	INT  -- ������ȡ����
	DECLARE @dwLxCount		INT  -- ������������
	DECLARE @dwLxGold		INT  -- �����������		
	DECLARE @dwLastLxCount	INT  -- �ϴ���������
	DECLARE @dwLastLxGold	INT  -- �ϴ��������

	SET @dwPresentCount=1

	SELECT @dwLastLxCount=LxCount,@dwLastLxGold=LxGold FROM RecordCheckIn WHERE UserID=@dwUserID AND DATEDIFF(D,CollectDate,GETDATE())=1
	IF @dwLastLxCount IS NULL
	BEGIN
		SELECT @dwPresentGold=PresentGold FROM GlobalCheckIn WHERE ID=1
		SET @dwLxCount=1
		SET @dwLxGold=@dwPresentGold
	END
	ELSE
	BEGIN
		IF @dwLastLxCount=7
		BEGIN			
			SET @dwLxCount=1
			SELECT @dwPresentGold=PresentGold FROM GlobalCheckIn WHERE ID=@dwLxCount
			SET @dwLxGold=@dwPresentGold
		END
		ELSE
		BEGIN			
			SET @dwLxCount=@dwLastLxCount+1
			SELECT @dwPresentGold=PresentGold FROM GlobalCheckIn WHERE ID=@dwLxCount
			SET @dwLxGold=@dwLastLxGold+@dwPresentGold
		END
	END

	-- ǩ����¼
	INSERT INTO RecordCheckIn(UserID,PresentGold,PresentCount,LxCount,LxGold)
	VALUES(@dwUserID,@dwPresentGold,@dwPresentCount,@dwLxCount,@dwLxGold) 

	-- ���½��
	UPDATE GameScoreInfo SET Score=Score+@dwPresentGold WHERE UserID=@dwUserID
	IF @@ROWCOUNT=0
	BEGIN
		INSERT GameScoreInfo(UserID,Score,RegisterIP,LastLogonIP)
		VALUES (@dwUserID,@dwPresentGold,@strClientIP,@strClientIP)
	END
	
END
RETURN 0
GO
