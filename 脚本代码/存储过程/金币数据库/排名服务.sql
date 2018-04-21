----------------------------------------------------------------------------------------------------

USE QPAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_AddPointConfig]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_AddPointConfig]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_UserAddPoint]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_UserAddPoint]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_UserGetAddRank]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_UserGetAddRank]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_UpAddRankAward]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_UpAddRankAward]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON
GO


-- ���ӻ��ֵ���
CREATE PROC GSP_GR_AddPointConfig
	@iRankIdex INT								-- �����Ŀ
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN
	
	IF @iRankIdex = 0
	BEGIN
		SELECT * FROM QPPlatformDBLink.QPPlatformDB.dbo.WeakAddRankConfig	
	END
	
	IF @iRankIdex = 1
	BEGIN
		SELECT * FROM QPPlatformDBLink.QPPlatformDB.dbo.QuarterAddRankConfig	
	END
	
	IF @iRankIdex = 2
	BEGIN
		SELECT * FROM QPPlatformDBLink.QPPlatformDB.dbo.YearAddRankConfig	
	END
	
	RETURN 0
END

GO


-- ���ӻ��ֵ���
CREATE PROC GSP_GR_UserAddPoint
	@dwUserID INT,								-- �û� I D
	@iAddPoint INT								-- �����Ŀ
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN
	
	IF NOT EXISTS (SELECT UserID FROM AccountsWeakAddRank(NOLOCK) WHERE UserID=@dwUserID)
	BEGIN
		INSERT INTO [dbo].[AccountsWeakRank] ([UserID], [LastLogonTime],[UserPoint]) VALUES (@dwUserID, GETDATE(),0)
	END
	
	IF NOT EXISTS (SELECT UserID FROM AccountsQuarterAddRank(NOLOCK) WHERE UserID=@dwUserID)
	BEGIN
		INSERT INTO [dbo].[AccountsMonthRank] ([UserID], [LastLogonTime],[UserPoint]) VALUES (@dwUserID, GETDATE(),0)
	END
	
	IF NOT EXISTS (SELECT UserID FROM AccountsYearAddRank(NOLOCK) WHERE UserID=@dwUserID)
	BEGIN
		INSERT INTO [dbo].[AccountsYearRank] ([UserID], [LastLogonTime],[UserPoint]) VALUES (@dwUserID, GETDATE(),0)
	END
	
	-- ��������
	UPDATE AccountsWeakAddRank SET UserPoint=UserPoint+@iAddPoint	
	WHERE UserID=@dwUserID
	
	-- ��������
	UPDATE AccountsQuarterAddRank SET UserPoint=UserPoint+@iAddPoint	
	WHERE UserID=@dwUserID
	
	-- ��������
	UPDATE AccountsYearAddRank SET UserPoint=UserPoint+@iAddPoint	
	WHERE UserID=@dwUserID
	
	RETURN 0
END

GO


-- �������
CREATE PROC GSP_GR_UserGetAddRank
	@dwUserID INT,								-- �û� I D
	@strPassword NCHAR(32),						-- �û�����
	@iRankIdex INT,								-- �������� 1 ������ 2 �������� 3 ������
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- �����Ϣ
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN
	-- ��ѯ�û�
	IF not exists(SELECT * FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID AND LogonPass=@strPassword)
	BEGIN
		SET @strErrorDescribe = N'��Ǹ������û���Ϣ�����ڻ������벻��ȷ��'
		return 1
	END
	DECLARE @userID AS INT
	DECLARE @UserPoint AS BIGINT
	DECLARE @FaceID AS INT
	DECLARE @CustomID AS INT
	DECLARE @haveResoult AS INT
	DECLARE @NickName NVARCHAR(32) 
	
	DECLARE @tempRankBack TABLE
	(
      UserID INT,
      NickName NVARCHAR(32) ,
      UserPoint BIGINT,
      FaceID INT,
      CustomID INT
	);
	
	SET @haveResoult = 2;
	
	
	IF @iRankIdex = 0
	BEGIN
		-- �����α�
		DECLARE C_Employees CURSOR FAST_FORWARD FOR
			SELECT  TOP 50 UserID,UserPoint 
			FROM AccountsWeakAddRank
			ORDER BY UserPoint DESC
			
		OPEN C_Employees;

		-- ȡ��һ����¼
		FETCH NEXT FROM C_Employees INTO @UserID,@UserPoint;

		WHILE @@FETCH_STATUS=0
		BEGIN
			
			SELECT @NickName=NickName,@FaceID=FaceID,@CustomID=CustomID FROM AccountsInfo(NOLOCK) WHERE UserID=@UserID
			
			IF @NickName IS NOT NULL
			BEGIN
				INSERT INTO @tempRankBack ([UserID],[NickName], [UserPoint],[FaceID],[CustomID]) VALUES (@UserID,@NickName,@UserPoint,@FaceID,@CustomID)
			END
			
			-- ȡ��һ����¼
			FETCH NEXT FROM C_Employees INTO @UserID,@UserPoint
		END

		-- �ر��α�
		CLOSE C_Employees;

		-- �ͷ��α�
		DEALLOCATE C_Employees;
		
		SELECT * FROM @tempRankBack
		
		return 0
	END
	
	IF @iRankIdex = 1
	BEGIN
	
		-- �����α�
		DECLARE C_Employees CURSOR FAST_FORWARD FOR
			SELECT  TOP 50 UserID,UserPoint 
			FROM AccountsQuarterAddRank
			ORDER BY UserPoint DESC
			
		OPEN C_Employees;

		-- ȡ��һ����¼
		FETCH NEXT FROM C_Employees INTO @UserID,@UserPoint;

		WHILE @@FETCH_STATUS=0
		BEGIN
			
			SELECT @NickName=NickName,@FaceID=FaceID,@CustomID=CustomID FROM AccountsInfo(NOLOCK) WHERE UserID=@UserID
			
			IF @NickName IS NOT NULL
			BEGIN
				INSERT INTO @tempRankBack ([UserID],[NickName], [UserPoint],[FaceID],[CustomID]) VALUES (@UserID,@NickName,@UserPoint,@FaceID,@CustomID)
			END
			
			-- ȡ��һ����¼
			FETCH NEXT FROM C_Employees INTO @UserID,@UserPoint
		END

		-- �ر��α�
		CLOSE C_Employees;

		-- �ͷ��α�
		DEALLOCATE C_Employees;
		
		SELECT * FROM @tempRankBack
		
		return 0
	END
	
	IF @iRankIdex = 2
	BEGIN
		-- �����α�
		DECLARE C_Employees CURSOR FAST_FORWARD FOR
			SELECT  TOP 50 UserID,UserPoint 
			FROM AccountsYearAddRank
			ORDER BY UserPoint DESC
			
		OPEN C_Employees;

		-- ȡ��һ����¼
		FETCH NEXT FROM C_Employees INTO @UserID,@UserPoint;

		WHILE @@FETCH_STATUS=0
		BEGIN
			
			SELECT @NickName=NickName,@FaceID=FaceID,@CustomID=CustomID FROM AccountsInfo(NOLOCK) WHERE UserID=@UserID
			
			IF @NickName IS NOT NULL
			BEGIN
				INSERT INTO @tempRankBack ([UserID],[NickName], [UserPoint],[FaceID],[CustomID]) VALUES (@UserID,@NickName,@UserPoint,@FaceID,@CustomID)
			END
			
			-- ȡ��һ����¼
			FETCH NEXT FROM C_Employees INTO @UserID,@UserPoint
		END

		-- �ر��α�
		CLOSE C_Employees;

		-- �ͷ��α�
		DEALLOCATE C_Employees;
		
		SELECT * FROM @tempRankBack
		
		return 0
	END

	
	IF @iRankIdex = 3
	BEGIN
		-- �����α�
		DECLARE C_Employees CURSOR FAST_FORWARD FOR
			SELECT  TOP 50 UserID,Score 
			FROM QPTreasureDBLink.QPTreasureDB.dbo.GameScoreInfo
			ORDER BY Score DESC
			
		OPEN C_Employees;

		-- ȡ��һ����¼
		FETCH NEXT FROM C_Employees INTO @UserID,@UserPoint;

		WHILE @@FETCH_STATUS=0
		BEGIN
			
			SELECT @NickName=NickName,@FaceID=FaceID,@CustomID=CustomID FROM AccountsInfo(NOLOCK) WHERE UserID=@UserID
			
			IF @NickName IS NOT NULL
			BEGIN
				INSERT INTO @tempRankBack ([UserID],[NickName], [UserPoint],[FaceID],[CustomID]) VALUES (@UserID,@NickName,@UserPoint,@FaceID,@CustomID)
			END
			
			-- ȡ��һ����¼
			FETCH NEXT FROM C_Employees INTO @UserID,@UserPoint
		END

		-- �ر��α�
		CLOSE C_Employees;

		-- �ͷ��α�
		DEALLOCATE C_Employees;
		
		SELECT * FROM @tempRankBack
		
		return 0
	END
	RETURN 0
END


GO




-- �������
CREATE PROC GSP_GR_UpAddRankAward
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

	DECLARE @LastWeakRank datetime
	SELECT @LastWeakRank=DayValue FROM QPPlatformDBLink.QPPlatformDB.dbo.AddRankConfig WHERE RankName=N'LastWeakRank'
	IF @LastWeakRank = NULL
	BEGIN
		SET @LastWeakRank = 0
	END
	
	DECLARE @LastQuarterRank datetime
	SELECT @LastQuarterRank=DayValue FROM QPPlatformDBLink.QPPlatformDB.dbo.AddRankConfig WHERE RankName=N'LastQuarterRank'
	IF @LastQuarterRank = NULL
	BEGIN
		SET @LastQuarterRank = 0
	END
	
	DECLARE @LastYearWeakRank datetime
	SELECT @LastYearWeakRank=DayValue FROM QPPlatformDBLink.QPPlatformDB.dbo.AddRankConfig WHERE RankName=N'LastYearWeakRank'
	IF @LastYearWeakRank = NULL
	BEGIN
		SET @LastYearWeakRank = 0
	END
	

	DECLARE @WeakIdex INT
	DECLARE @userID AS INT
	DECLARE @UserPoint AS INT
	DECLARE @DayIdex AS INT
	DECLARE @RewardGold int
	DECLARE @RewardType int
	
	set datefirst 1
	select @WeakIdex = datepart(weekday, getdate())
	
	if DATEDIFF(dd,@LastWeakRank,GETDATE()) <> 0
	BEGIN
		if @WeakIdex = 7 
		BEGIN--�ܽ���
		
			SET @DayIdex = 1
			-- �����α�
			DECLARE C_Employees CURSOR FAST_FORWARD FOR
				SELECT  TOP 50 UserID,UserPoint 
				FROM AccountsWeakAddRank
				ORDER BY UserPoint DESC
				
			OPEN C_Employees;

			-- ȡ��һ����¼
			FETCH NEXT FROM C_Employees INTO @UserID,@UserPoint;

			WHILE @@FETCH_STATUS=0
			BEGIN
				
				SELECT @RewardGold=RewardGold,@RewardType=RewardType FROM QPPlatformDBLink.QPPlatformDB.dbo.WeakAddRankConfig WHERE DayID=@DayIdex
				IF @RewardGold <> NULL and @RewardType <> NULL
				BEGIN
					IF @RewardType = 1
					BEGIN
						UPDATE GameScoreInfo SET Score= Score+RewardGold WHERE UserID = @userID
					END
				END
				
				SET @DayIdex = @DayIdex+1
				-- ȡ��һ����¼
				FETCH NEXT FROM C_Employees INTO @UserID,@UserPoint
			END

			-- �ر��α�
			CLOSE C_Employees;

			-- �ͷ��α�
			DEALLOCATE C_Employees;
			
			--------------------------------------------
			--
			UPDATE QPPlatformDBLink.QPPlatformDB.dbo.AddRankConfig SET DayValue=getdate()	
			WHERE RankName=N'LastWeakRank'
		END
	END
	
	DECLARE @MonthEndDay datetime
	select @MonthEndDay = (DATEADD(MONTH,DATEDIFF(MONTH,'19911231',GETDATE()),'19911231'))
	
	DECLARE @MonthValue INT
	DECLARE @DayValue INT
	DECLARE @MonthEndDayValue INT
	select @DayValue = DAY(GETDATE())
	select @MonthValue = MONTH(DATEADD(MONTH,DATEDIFF(MONTH,'19911231',GETDATE()),'19911231'))
	select @MonthEndDayValue = DAY(DATEADD(MONTH,DATEDIFF(MONTH,'19911231',GETDATE()),'19911231'))
	
	IF @DayValue <> @MonthEndDayValue 
	BEGIN
		return 0
	END
	
	if DATEDIFF(dd,@LastQuarterRank,GETDATE()) <> 0
	BEGIN
		IF @MonthValue = 3 OR @MonthValue = 6 OR @MonthValue = 9 OR @MonthValue = 12 
		BEGIN --���Ƚ���
			
			SET @DayIdex = 1
			-- �����α�
			DECLARE C_Employees CURSOR FAST_FORWARD FOR
				SELECT TOP 50 UserID,UserPoint 
				FROM AccountsQuarterAddRank
				ORDER BY UserPoint DESC
				
			OPEN C_Employees;

			-- ȡ��һ����¼
			FETCH NEXT FROM C_Employees INTO @UserID,@UserPoint;

			WHILE @@FETCH_STATUS=0
			BEGIN
				
				SELECT @RewardGold=RewardGold,@RewardType=RewardType FROM QPPlatformDBLink.QPPlatformDB.dbo.QuarterAddRankConfig WHERE DayID=@DayIdex
				IF @RewardGold <> NULL and @RewardType <> NULL
				BEGIN
					IF @RewardType = 1
					BEGIN
						UPDATE GameScoreInfo SET Score= Score+RewardGold WHERE UserID = @userID
					END
				END
				
				SET @DayIdex = @DayIdex+1
				-- ȡ��һ����¼
				FETCH NEXT FROM C_Employees INTO @UserID,@UserPoint
			END

			-- �ر��α�
			CLOSE C_Employees;

			-- �ͷ��α�
			DEALLOCATE C_Employees;

			--------------------------------------------
			--
		
			UPDATE QPPlatformDBLink.QPPlatformDB.dbo.AddRankConfig SET DayValue=getdate()	
			WHERE RankName=N'LastQuarterRank'
		END
	END
	
	if DATEDIFF(dd,@LastYearWeakRank,GETDATE()) <> 0
	BEGIN
		IF @MonthValue = 12
		BEGIN --�꽱��
			
			SET @DayIdex = 1
			-- �����α�
			DECLARE C_Employees CURSOR FAST_FORWARD FOR
				SELECT TOP 50 UserID,UserPoint 
				FROM AccountsYearAddRank
				ORDER BY UserPoint DESC
				
			OPEN C_Employees;

			-- ȡ��һ����¼
			FETCH NEXT FROM C_Employees INTO @UserID,@UserPoint;

			WHILE @@FETCH_STATUS=0
			BEGIN
				
				SELECT @RewardGold=RewardGold,@RewardType=RewardType FROM QPPlatformDBLink.QPPlatformDB.dbo.YearAddRankConfig WHERE DayID=@DayIdex
				IF @RewardGold <> NULL and @RewardType <> NULL
				BEGIN
					IF @RewardType = 1
					BEGIN
						UPDATE GameScoreInfo SET Score= Score+RewardGold WHERE UserID = @userID
					END
				END
				
				SET @DayIdex = @DayIdex+1
				-- ȡ��һ����¼
				FETCH NEXT FROM C_Employees INTO @UserID,@UserPoint
			END

			-- �ر��α�
			CLOSE C_Employees;

			-- �ͷ��α�
			DEALLOCATE C_Employees;

			
			--------------------------------------------
			--
			
			UPDATE QPPlatformDBLink.QPPlatformDB.dbo.AddRankConfig SET DayValue=getdate()	
			WHERE RankName=N'LastYearWeakRank'
		END
	END
	return 0
END

GO
