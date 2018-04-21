
----------------------------------------------------------------------------------------------------

USE QPAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_CheckInQueryInfo]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_CheckInQueryInfo]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_CheckAward]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_CheckAward]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_CheckInDone]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_CheckInDone]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_LoadCheckInReward]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_LoadCheckInReward]
GO


SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO


----------------------------------------------------------------------------------------------------

-- ���ؽ���
CREATE PROC GSP_GP_LoadCheckInReward
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN

	-- ��ѯ����
	SELECT * FROM QPPlatformDBLink.QPPlatformDB.dbo.SigninConfig	

END

RETURN 0

GO
----------------------------------------------------------------------------------------------------
-- ��ѯǩ��
CREATE PROC GSP_GR_CheckInQueryInfo
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
	DECLARE @wAwardDate INT	
	DECLARE @StartDateTime DateTime
	DECLARE @LastDateTime DateTime
	SELECT @StartDateTime=StartDateTime,@LastDateTime=LastDateTime,@wSeriesDate=SeriesDate,@wAwardDate=AwardDate FROM AccountsSignin 	
	WHERE UserID=@dwUserID
	IF @StartDateTime IS NULL OR @LastDateTime IS NULL OR @wSeriesDate IS NULL OR @wSeriesDate IS NULL OR @wAwardDate IS NULL
	BEGIN
		SELECT @StartDateTime=GetDate(),@LastDateTime=GetDate(),@wSeriesDate=0
		INSERT INTO AccountsSignin VALUES(@dwUserID,@StartDateTime,@LastDateTime,0,0)		
	END

	-- �����ж�
	DECLARE @TodayCheckIned TINYINT
	SET @TodayCheckIned = 0
	IF DateDiff(dd,@LastDateTime,GetDate()) = 0 	
	BEGIN
		IF @wSeriesDate > 0 SET @TodayCheckIned = 1
	END ELSE
	BEGIN	
		DECLARE @iMaxDay INT
		SELECT @iMaxDay =  MAX(RewardDay) FROM QPPlatformDBLink.QPPlatformDB.dbo.SigninConfig
		
		if @wAwardDate = @iMaxDay OR @wAwardDate > @iMaxDay
		BEGIN
			SELECT @StartDateTime = GetDate(),@LastDateTime = GetDate(),@wSeriesDate = 0,@wAwardDate = 0
			INSERT INTO AccountsSignin VALUES(@dwUserID,@StartDateTime,@LastDateTime,0,0)		
		END	
		--IF DateDiff(dd,@StartDateTime,GetDate()) <> @wSeriesDate
		--BEGIN
		--	SET @wSeriesDate = 0
		--	SET @wAwardDate = 0
		--	UPDATE AccountsSignin SET StartDateTime=GetDate(),LastDateTime=GetDate(),SeriesDate=0,AwardDate=0 WHERE UserID=@dwUserID									
		--END
	END

	
	
	-- �׳�����
	SELECT @wSeriesDate AS SeriesDate,@wAwardDate AS AwardDate,@TodayCheckIned AS TodayCheckIned	
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- ��ȡ��Ʒ
CREATE PROC GSP_GR_CheckAward
	@dwUserID INT,								-- �û� I D
	@strPassword NCHAR(32),						-- �û�����
	@strClientIP NVARCHAR(15),					-- ���ӵ�ַ
	@strMachineID NVARCHAR(32),					-- ������ʶ
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
	DECLARE @wAwardDate INT	
	DECLARE @StartDateTime DateTime
	DECLARE @LastDateTime DateTime
	SELECT @StartDateTime=StartDateTime,@LastDateTime=LastDateTime,@wSeriesDate=SeriesDate,@wAwardDate=AwardDate  FROM AccountsSignin 
	WHERE UserID=@dwUserID
	IF @StartDateTime IS NULL OR @LastDateTime IS NULL OR @wSeriesDate IS NULL
	BEGIN
		SELECT @StartDateTime = GetDate(),@LastDateTime = GetDate(),@wSeriesDate = 0,@wAwardDate = 0
		INSERT INTO AccountsSignin VALUES(@dwUserID,@StartDateTime,@LastDateTime,0,0)		
	END

	-- ǩ���ж�
	IF @wAwardDate = @wSeriesDate AND @wAwardDate > 0
	BEGIN
		SET @strErrorDescribe = N'��Ǹ���������Ѿ���ȡ�����ˣ�'
		return 3		
	END
	
	-- ��ѯ����
	DECLARE @lRewardGold BIGINT
	DECLARE @lRewardType BIGINT
	DECLARE @lRewardDay BIGINT
	SELECT @lRewardGold=RewardGold,@lRewardType=RewardType,@lRewardDay=RewardDay FROM QPPlatformDBLink.QPPlatformDB.dbo.SigninConfig WHERE DayID=(@wAwardDate+1)
	IF @lRewardGold IS NULL 
	BEGIN
		SELECT @StartDateTime = GetDate(),@LastDateTime = GetDate(),@wSeriesDate = 0,@wAwardDate = 0
		INSERT INTO AccountsSignin VALUES(@dwUserID,@StartDateTime,@LastDateTime,0,0)		
		SET @strErrorDescribe = N'��Ǹ������������ȡ���������'
		return 3		
	END	
	if @lRewardDay > @wSeriesDate
	BEGIN
		SET @strErrorDescribe = N'��Ǹ������������ȡ���������'
		return 3		
	END	
	
	-- ���¼�¼
	SET @wAwardDate = @wAwardDate+1
	UPDATE AccountsSignin SET AwardDate = @wAwardDate WHERE UserID = @dwUserID
	
	IF @lRewardType = 1
	BEGIN
		-- �������	
		UPDATE QPTreasureDBLink.QPTreasureDB.dbo.GameScoreInfo SET Score = Score + @lRewardGold WHERE UserID = @dwUserID
		IF @@rowcount = 0
		BEGIN
			-- ��������
			INSERT INTO QPTreasureDBLink.QPTreasureDB.dbo.GameScoreInfo (UserID,Score, LastLogonIP, LastLogonMachine, RegisterIP, RegisterMachine)
			VALUES (@dwUserID, @lRewardGold, @strClientIP, @strMachineID, @strClientIP, @strMachineID)
		END
		
		SET @strErrorDescribe = N'��ȡ�ɹ������ '+convert(varchar,@lRewardGold)+N' �Ľ�ң�'
	END	


	-- ��ѯ���
	DECLARE @lScore BIGINT	
	SELECT @lScore=Score FROM QPTreasureDBLink.QPTreasureDB.dbo.GameScoreInfo WHERE UserID = @dwUserID 	
	IF @lScore IS NULL SET @lScore = 0
	
		
	-- �׳�����
	SELECT @lScore AS Score	
END
RETURN 0

GO
----------------------------------------------------------------------------------------------------

-- ��ȡ����
CREATE PROC GSP_GR_CheckInDone
	@dwUserID INT,								-- �û� I D
	@strPassword NCHAR(32),						-- �û�����
	@strClientIP NVARCHAR(15),					-- ���ӵ�ַ
	@strMachineID NVARCHAR(32),					-- ������ʶ
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
	SELECT @StartDateTime=StartDateTime,@LastDateTime=LastDateTime,@wSeriesDate=SeriesDate FROM AccountsSignin 
	WHERE UserID=@dwUserID
	IF @StartDateTime IS NULL OR @LastDateTime IS NULL OR @wSeriesDate IS NULL
	BEGIN
		SELECT @StartDateTime = GetDate(),@LastDateTime = GetDate(),@wSeriesDate = 0
		INSERT INTO AccountsSignin VALUES(@dwUserID,@StartDateTime,@LastDateTime,0,0)		
	END

	-- ǩ���ж�
	IF DateDiff(dd,@LastDateTime,GetDate()) = 0 AND @wSeriesDate > 0
	BEGIN
		SET @strErrorDescribe = N'��Ǹ���������Ѿ�ǩ���ˣ�'
		return 3		
	END
	
	
	-- ÿ�콱����
	DECLARE @iSiginDayGold AS INT
	SELECT @iSiginDayGold=StatusValue FROM SystemStatusInfo WHERE StatusName=N'SiginDayGold'
	IF @iSiginDayGold IS NULL 
	BEGIN
		SET @strErrorDescribe = N'ǩ��Ϊ����SiginDayGold��'
		return 4		
	END

	-- ���¼�¼
	SET @wSeriesDate = @wSeriesDate+1
	UPDATE AccountsSignin SET LastDateTime = GetDate(),SeriesDate = @wSeriesDate WHERE UserID = @dwUserID
	
	-- �������	
	UPDATE QPTreasureDBLink.QPTreasureDB.dbo.GameScoreInfo SET Score = Score + @iSiginDayGold WHERE UserID = @dwUserID
	IF @@rowcount = 0
	BEGIN
		-- ��������
		INSERT INTO QPTreasureDBLink.QPTreasureDB.dbo.GameScoreInfo (UserID,Score, LastLogonIP, LastLogonMachine, RegisterIP, RegisterMachine)
		VALUES (@dwUserID, @iSiginDayGold, @strClientIP, @strMachineID, @strClientIP, @strMachineID)
	END

	SET @strErrorDescribe = N'ǩ���ɹ�!��� '+convert(varchar,@iSiginDayGold)+N' �Ľ�ң�'

	-- ��ѯ���
	DECLARE @lScore BIGINT	
	SELECT @lScore=Score FROM QPTreasureDBLink.QPTreasureDB.dbo.GameScoreInfo WHERE UserID = @dwUserID 	
	IF @lScore IS NULL SET @lScore = 0
	
	-- �׳�����
	SELECT @lScore AS Score	
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------