
----------------------------------------------------------------------------------------------------

USE QPAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_BeginnerQueryInfo]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_BeginnerQueryInfo]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_BeginnerDone]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_BeginnerDone]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_BeginnerPlayGame]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_BeginnerPlayGame]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_LoadBeginnerConfig]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_LoadBeginnerConfig]
GO


SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------
-- ���ֽ���
CREATE PROC GSP_GP_LoadBeginnerConfig
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN

	-- ��ѯ����
	SELECT * FROM QPPlatformDBLink.QPPlatformDB.dbo.BeginnerConfig	

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
-- ���һ����Ϸ
CREATE PROC GSP_GR_BeginnerPlayGame
	@dwUserID INT								-- �û� I D
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN
	UPDATE AccountsBeginner SET LastGameTime = GetDate() WHERE UserID = @dwUserID
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
-- ��ѯ���ֻ
CREATE PROC GSP_GR_BeginnerQueryInfo
	@dwUserID INT,								-- �û� I D
	@strPassword NCHAR(32),						-- �û�����
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- �����Ϣ
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN

	-- ��ѯ�û�
	IF not exists(SELECT * FROM AccountsInfo WHERE UserID=@dwUserID AND LogonPass=@strPassword)
	BEGIN
		SET @strErrorDescribe = N'��Ǹ������û���Ϣ�����ڻ������벻��ȷ��'
		return 1
	END

	-- ǩ����¼
	DECLARE @wSeriesDate INT	
	DECLARE @StartDateTime DateTime
	DECLARE @LastDateTime DateTime
	DECLARE @LastGameTime DateTime
	SELECT @StartDateTime=StartDateTime,@LastDateTime=LastDateTime,@wSeriesDate=SeriesDate,@LastGameTime=LastGameTime FROM AccountsBeginner 	
	WHERE UserID=@dwUserID
	IF @StartDateTime IS NULL OR @LastDateTime IS NULL OR @wSeriesDate IS NULL OR @wSeriesDate IS NULL
	BEGIN
		SELECT @StartDateTime=GetDate(),@LastDateTime=0,@wSeriesDate=0
		INSERT INTO AccountsBeginner VALUES(@dwUserID,@StartDateTime,@LastDateTime,0,0)		
	END

	-- �����ж�
	DECLARE @TodayCheckIned TINYINT
	DECLARE @LastCheckIned TINYINT
	SET @TodayCheckIned = 0
	SET @LastCheckIned = 1
	IF @LastDateTime <> 0 and  DateDiff(dd,@LastDateTime,GetDate()) = 0 	
	BEGIN
		SET @TodayCheckIned = 1
	END
	
	if @LastGameTime <> 0 and  DateDiff(dd,@LastGameTime,@LastDateTime) < 0 and DateDiff(dd,@LastGameTime,GetDate()) <> 0
	BEGIN
		SET @LastCheckIned = 0;
	END
	
	-- �׳�����
	SELECT @wSeriesDate AS SeriesDate,@TodayCheckIned AS TodayCheckIned,@LastCheckIned AS LastCheckIned
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- ��ȡ����
CREATE PROC GSP_GR_BeginnerDone
	@dwUserID INT,								-- �û� I D
	@strPassword NCHAR(32),						-- �û�����
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- �����Ϣ
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN

	-- ��ѯ�û�
	IF not exists(SELECT * FROM AccountsInfo WHERE UserID=@dwUserID AND LogonPass=@strPassword)
	BEGIN
		SET @strErrorDescribe = N'��Ǹ������û���Ϣ�����ڻ������벻��ȷ��'
		return 1
	END


	-- ǩ����¼
	DECLARE @wSeriesDate INT	
	DECLARE @StartDateTime DateTime
	DECLARE @LastDateTime DateTime
	DECLARE @LastGameTime DateTime
	SELECT @StartDateTime=StartDateTime,@LastDateTime=LastDateTime,@wSeriesDate=SeriesDate,@LastGameTime=LastGameTime FROM AccountsBeginner 	
	WHERE UserID=@dwUserID
	IF @StartDateTime IS NULL OR @LastDateTime IS NULL OR @wSeriesDate IS NULL 
	BEGIN
		SELECT @StartDateTime=GetDate(),@LastDateTime=GetDate(),@wSeriesDate=0
		INSERT INTO AccountsBeginner VALUES(@dwUserID,@StartDateTime,@LastDateTime,0,0)		
	END

	-- �����Ƿ��Ѿ���ȡ
	IF DateDiff(d,@LastDateTime,GetDate()) = 0 
	BEGIN
		SET @strErrorDescribe = N'��Ǹ���������Ѿ���ȡ�����ˣ�'
		return 3		
	END

	-- �����Ƿ��Ѿ��Ѿ�������Ϸ
	 IF @LastGameTime = 0 OR DateDiff(d,@LastDateTime,@LastGameTime) = 0 
	 BEGIN
		SET @strErrorDescribe = N'��Ǹ��Ҫ����һ����Ϸ�����콱��'
		return 4		
	 END
	
	-- ��ѯ����
	DECLARE @lRewardGold BIGINT
	DECLARE @lRewardType BIGINT
	SELECT @lRewardGold=RewardGold,@lRewardType=RewardType FROM QPPlatformDBLink.QPPlatformDB.dbo.BeginnerConfig WHERE DayID=(@wSeriesDate+1)
	IF @lRewardGold IS NULL 
	BEGIN
		SET @strErrorDescribe = N'���ݿ����'
		return 5		
	END	
	
	-- ���¼�¼
	UPDATE AccountsBeginner SET LastDateTime = @LastGameTime ,SeriesDate = SeriesDate + 1 WHERE UserID = @dwUserID
	
	IF @lRewardType = 1
	BEGIN
		-- �������	
		UPDATE QPTreasureDBLink.QPTreasureDB.dbo.GameScoreInfo SET Score = Score + @lRewardGold WHERE UserID = @dwUserID
		
		SET @strErrorDescribe = N'������ֻ���� '+convert(varchar,@lRewardGold)+N' �Ľ�ң�'
	END	


	-- ��ѯ���
	DECLARE @lScore BIGINT	
	SELECT @lScore=Score FROM QPTreasureDBLink.QPTreasureDB.dbo.GameScoreInfo WHERE UserID = @dwUserID 	
	IF @lScore IS NULL SET @lScore = 0
	
		
	-- �׳�����
	SELECT @lScore AS AwardCout,@lRewardType AS AwardType		
END
RETURN 0

GO