
----------------------------------------------------------------------------------------------------

USE QPTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_GameRecord_List_RecordID]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_GameRecord_List_RecordID]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_PrivateGameRecord]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_PrivateGameRecord]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_PrivateGameRecord_Child]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_PrivateGameRecord_Child]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_RecordDrawInfo]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_RecordDrawInfo]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_RecordDrawScore]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_RecordDrawScore]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_BeginnerPlayGame]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_BeginnerPlayGame]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_PrivateGameRecord]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_PrivateGameRecord]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_PrivateGameRecordChild]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_PrivateGameRecordChild]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_PrivateGameRecordUserRecordID]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_PrivateGameRecordUserRecordID]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_BeginnerPlayGame]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_BeginnerPlayGame]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------
-- ��Ϸ��¼
CREATE PROC GSP_GP_GameRecord_List_RecordID
	@dwUserID INT								-- �û� I D
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN

	SELECT  TOP 10 RecordID FROM PrivateGameRecordUserRecordID WHERE UserID = @dwUserID ORDER BY InsertTime DESC
END

RETURN 0

GO
----------------------------------------------------------------------------------------------------
-- ��Ϸ��¼
CREATE PROC GSP_GP_PrivateGameRecord
	@dwRecordID INT								-- �û� I D
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN
	SELECT UserDate FROM PrivateGameRecord WHERE RecordID=@dwRecordID
END

RETURN 0

GO
----------------------------------------------------------------------------------------------------
-- ��Ϸ��¼
CREATE PROC GSP_GP_PrivateGameRecord_Child
	@dwRecordID INT								
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN
	SELECT * FROM PrivateGameRecordChild WHERE RecordID=@dwRecordID
END

RETURN 0

GO

GO
----------------------------------------------------------------------------------------------------

-- ��Ϸ��¼
CREATE PROC GSP_GR_RecordDrawInfo

	-- ������Ϣ
	@wKindID INT,								-- ��Ϸ I D
	@wServerID INT,								-- ���� I D

	-- ������Ϣ
	@wTableID INT,								-- ���Ӻ���
	@wUserCount INT,							-- �û���Ŀ
	@wAndroidCount INT,							-- ������Ŀ

	-- ˰�����
	@lWasteCount BIGINT,						-- �����Ŀ
	@lRevenueCount BIGINT,						-- ��Ϸ˰��

	-- ͳ����Ϣ
	@dwUserMemal BIGINT,						-- �����Ŀ
	@dwPlayTimeCount INT,						-- ��Ϸʱ��

	-- ʱ����Ϣ
	@SystemTimeStart DATETIME,					-- ��ʼʱ��
	@SystemTimeConclude DATETIME,				-- ����ʱ��

	@dataUserDefine image						-- ��Ϸ�Զ�������
	
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN

	-- �����¼
	INSERT RecordDrawInfo(KindID,ServerID,TableID,UserCount,AndroidCount,Waste,Revenue,UserMedal,StartTime,ConcludeTime,DrawCourse)
	VALUES (@wKindID,@wServerID,@wTableID,@wUserCount,@wAndroidCount,@lWasteCount,@lRevenueCount,@dwUserMemal,@SystemTimeStart,@SystemTimeConclude,@dataUserDefine)
	
	-- ��ȡ��¼
	SELECT SCOPE_IDENTITY() AS DrawID

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- ��Ϸ��¼
CREATE PROC GSP_GR_RecordDrawScore

	-- ������Ϣ
	@dwDrawID INT,								-- ������ʶ
	@dwUserID INT,								-- �û���ʶ
	@wChairID INT,								-- ���Ӻ���

	-- �û���Ϣ
	@dwDBQuestID INT,							-- �����ʶ
	@dwInoutIndex INT,							-- ��������

	-- �ɼ���Ϣ
	@lScore BIGINT,								-- �û�����
	@lGrade BIGINT,								-- �û��ɼ�
	@lRevenue BIGINT,							-- �û�˰��
	@dwUserMedal INT,							-- ������Ŀ
	@dwPlayTimeCount INT						-- ��Ϸʱ��

WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN

	-- �����¼
	INSERT RecordDrawScore(DrawID,UserID,ChairID,Score,Grade,Revenue,UserMedal,PlayTimeCount,DBQuestID,InoutIndex,InsertTime)
	VALUES (@dwDrawID,@dwUserID,@wChairID,@lScore,@lGrade,@lRevenue,@dwUserMedal,@dwPlayTimeCount,@dwDBQuestID,@dwInoutIndex,GetDate())
	
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

-- ��Ϸ��¼
CREATE PROC GSP_GR_PrivateGameRecord
	@dataUserDefine image						-- ��Ϸ�Զ�������
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN

	-- �����¼
	INSERT PrivateGameRecord(UserDate)
	VALUES (@dataUserDefine)
	
	-- ��ȡ��¼
	SELECT SCOPE_IDENTITY() AS RecordID

END

RETURN 0

GO
----------------------------------------------------------------------------------------------------

-- ��Ϸ��¼
CREATE PROC GSP_GR_PrivateGameRecordChild
	@dwRecordID INT,
	@dataUserDefine image						-- ��Ϸ�Զ�������
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN

	-- �����¼
	INSERT PrivateGameRecordChild(UserDate,RecordID)VALUES (@dataUserDefine,@dwRecordID)
	
END

RETURN 0

GO
----------------------------------------------------------------------------------------------------


-- ��Ϸ��¼
CREATE PROC GSP_GR_PrivateGameRecordUserRecordID
	@dwRecordID INT,
	@dwUserID INT	
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN

	-- �����¼
	INSERT PrivateGameRecordUserRecordID(RecordID,UserID)VALUES (@dwRecordID,@dwUserID)
	
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

	-- ��������	
	DECLARE	@return_value int

	EXEC @return_value = QPAccountsDBLink.QPAccountsDB.dbo.GSP_GR_BeginnerPlayGame
		 @dwUserID = @dwUserID

	RETURN @return_value
END

GO