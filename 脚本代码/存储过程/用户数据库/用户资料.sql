
----------------------------------------------------------------------------------------------------

USE QPAccountsDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_QueryUserIndividual]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_QueryUserIndividual]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_QueryUserAccountInfo]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_QueryUserAccountInfo]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_ModifyUserIndividual]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_ModifyUserIndividual]
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GP_QueryUserInGameServerID]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GP_QueryUserInGameServerID]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO


----------------------------------------------------------------------------------------------------

-- ��ѯ����
CREATE PROC GSP_GP_QueryUserAccountInfo
	@dwUserID INT,								-- �û� I D
	@strClientIP NVARCHAR(15),					-- ���ӵ�ַ
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- �����Ϣ
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ������Ϣ
DECLARE @UserID INT
DECLARE @CustomID INT
DECLARE @FaceID SMALLINT
DECLARE @Accounts NVARCHAR(31)
DECLARE @NickName NVARCHAR(31)
DECLARE @UnderWrite NVARCHAR(63)
DECLARE @SpreaderID INT
DECLARE @PlayTimeCount INT

-- ���ֱ���
DECLARE @Score BIGINT
DECLARE @Insure BIGINT

-- ��չ��Ϣ
DECLARE @GameID INT
DECLARE @Gender TINYINT
DECLARE @UserMedal INT
DECLARE @Experience INT
DECLARE @LoveLiness INT
DECLARE @MemberOrder SMALLINT
DECLARE @MemberOverDate DATETIME
DECLARE @MemberSwitchDate DATETIME
-- ִ���߼�
BEGIN
	-- ��ѯ�û�
	DECLARE @Nullity TINYINT
	DECLARE @StunDown TINYINT
	DECLARE @LogonPass AS NCHAR(32)
	DECLARE @strInsurePass AS NCHAR(32)
	DECLARE @strLogonIP AS NCHAR(32)
	DECLARE @MoorMachine AS TINYINT
	SELECT @UserID=UserID, @GameID=GameID, @Accounts=Accounts, @NickName=NickName, @UnderWrite=UnderWrite, @LogonPass=LogonPass,@strInsurePass=InsurePass,
		@FaceID=FaceID, @CustomID=CustomID, @Gender=Gender, @Nullity=Nullity, @StunDown=StunDown, @UserMedal=UserMedal, @Experience=Experience,
		@LoveLiness=LoveLiness, @MemberOrder=MemberOrder, @MemberOverDate=MemberOverDate, @MemberSwitchDate=MemberSwitchDate,
		@MoorMachine=MoorMachine,@SpreaderID=SpreaderID,@PlayTimeCount=PlayTimeCount,@strLogonIP=LastLogonIP
	FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID
	
	-- ��ѯ�û�
	IF @UserID IS NULL
	BEGIN
		set @strErrorDescribe = N'δ�ҵ��û�'
		return 1
	END
	
	SELECT @Score=Score, @Insure=InsureScore FROM QPTreasureDBLink.QPTreasureDB.dbo.GameScoreInfo WHERE UserID=@UserID
	IF @Score IS NULL
	BEGIN
		set @Score = 0
		set @Insure = 0
		return 1
	END
	
	SELECT @UserID AS UserID, @GameID AS GameID, @Accounts AS Accounts, @NickName AS NickName, @UnderWrite AS UnderWrite,
		@FaceID AS FaceID, @CustomID AS CustomID, @Gender AS Gender, @UserMedal AS UserMedal, @Experience AS Experience,
		@Score AS Score, @Insure AS Insure, @LoveLiness AS LoveLiness, @MemberOrder AS MemberOrder, @MemberOverDate AS MemberOverDate,
		@MoorMachine AS MoorMachine,@SpreaderID AS SpreaderID,@strLogonIP AS LogonIP

END

RETURN 0

GO
----------------------------------------------------------------------------------------------------

-- ��ѯ����
CREATE PROC GSP_GP_QueryUserIndividual
	@dwUserID INT,								-- �û� I D
	@strClientIP NVARCHAR(15)					-- ���ӵ�ַ
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN
	-- ��������
	DECLARE @UserID INT
	DECLARE @QQ NVARCHAR(16)
	DECLARE @EMail NVARCHAR(33)
	DECLARE @UserNote NVARCHAR(256)
	DECLARE @SeatPhone NVARCHAR(32)
	DECLARE @MobilePhone NVARCHAR(16)
	DECLARE @Compellation NVARCHAR(16)
	DECLARE @DwellingPlace NVARCHAR(128)
	DECLARE @HeadHttp NVARCHAR(256)
	DECLARE @UserChannel NVARCHAR(32)

	-- ��ѯ�û�
	SELECT @UserID=UserID, @QQ=QQ, @EMail=EMail, @UserNote=UserNote, @SeatPhone=SeatPhone,
		@MobilePhone=MobilePhone, @Compellation=Compellation, @DwellingPlace=DwellingPlace, @HeadHttp=HeadHttp, @UserChannel=UserChannel
	FROM IndividualDatum(NOLOCK) WHERE UserID=@dwUserID

	-- ��ѯ�û�
	IF @UserID IS NULL
	BEGIN
		SET @QQ=N''	
		SET @EMail=N''	
		SET @UserNote=N''	
		SET @SeatPhone=N''	
		SET @MobilePhone=N''	
		SET @Compellation=N''	
		SET @DwellingPlace=N''	
		SET @HeadHttp=N''	
		SET @UserChannel=N''	
	END

	-- �����Ϣ
	SELECT @dwUserID AS UserID, @Compellation AS Compellation, @QQ AS QQ, @EMail AS EMail, @SeatPhone AS SeatPhone,
		@MobilePhone AS MobilePhone, @DwellingPlace AS DwellingPlace, @UserNote AS UserNote, @HeadHttp AS HeadHttp, @UserChannel AS UserChannel

	RETURN 0

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

-- ��������
CREATE PROC GSP_GP_ModifyUserIndividual
	@dwUserID INT,								-- �û� I D
	@strPassword NCHAR(32),						-- �û�����
	@cbGender TINYINT,							-- �û��Ա�
	@strNickName NVARCHAR(32),					-- �û��ǳ�
	@strUnderWrite NVARCHAR(63),				-- ����ǩ��
	@strCompellation NVARCHAR(16),				-- ��ʵ����
	@strQQ NVARCHAR(16),						-- Q Q ����
	@strEMail NVARCHAR(33),						-- �����ʵ�
	@strSeatPhone NVARCHAR(32),					-- �̶��绰
	@strMobilePhone NVARCHAR(16),				-- �ƶ��绰
	@strDwellingPlace NVARCHAR(128),			-- ��ϸ��ַ
	@strUserNote NVARCHAR(256),					-- �û���ע		
	@strHeadHttp NVARCHAR(256),					-- ͷ��HTTP		
	@strUserChannel NVARCHAR(32),				-- ������			
	@strClientIP NVARCHAR(15),					-- ���ӵ�ַ		
	@strErrorDescribe NVARCHAR(127) OUTPUT		-- �����Ϣ
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN

	-- ��������
	DECLARE @UserID INT
	DECLARE @NickName NVARCHAR(31)
	DECLARE @Nullity BIT
	DECLARE @StunDown BIT
	DECLARE @LogonPass AS NCHAR(32)

	-- ��ѯ�û�
	SELECT @UserID=UserID, @NickName=NickName, @LogonPass=LogonPass, @Nullity=Nullity, @StunDown=StunDown
	FROM AccountsInfo(NOLOCK) WHERE UserID=@dwUserID

	-- ��ѯ�û�
	IF @UserID IS NULL
	BEGIN
		SET @strErrorDescribe=N'�����ʺŲ����ڻ������������������֤���ٴγ��ԣ�'
		RETURN 1
	END	

	-- �ʺŽ�ֹ
	IF @Nullity<>0
	BEGIN
		SET @strErrorDescribe=N'�����ʺ���ʱ���ڶ���״̬������ϵ�ͻ����������˽���ϸ�����'
		RETURN 2
	END	

	-- �ʺŹر�
	IF @StunDown<>0
	BEGIN
		SET @strErrorDescribe=N'�����ʺ�ʹ���˰�ȫ�رչ��ܣ��������¿�ͨ����ܼ���ʹ�ã�'
		RETURN 2
	END	
	
	-- �����ж�
	IF @LogonPass<>@strPassword
	BEGIN
		SET @strErrorDescribe=N'�����ʺŲ����ڻ������������������֤���ٴγ��Ե�¼��'
		RETURN 3
	END

	-- Ч���ǳ�
	IF (SELECT COUNT(*) FROM ConfineContent(NOLOCK) WHERE CHARINDEX(String,@strNickName)>0)>0
	BEGIN
		SET @strErrorDescribe=N'�����������Ϸ�ǳ������������ַ�����������ǳ������ٴ��޸ģ�'
		RETURN 4
	END

	-- �����ж�
	-- IF EXISTS (SELECT UserID FROM AccountsInfo(NOLOCK) WHERE NickName=@strNickName AND UserID<>@dwUserID)
	-- BEGIN
	-- 	SET @strErrorDescribe=N'���ǳ��ѱ��������ʹ���ˣ�������ǳ������ٴ��޸ģ�'
	-- 	RETURN 4
	-- END
	IF @strNickName = N''
	BEGIN
		SET @strNickName = @NickName
	END
	

	-- �޸�����
	-- UPDATE AccountsInfo SET NickName=@strNickName, UnderWrite=@strUnderWrite, Gender=@cbGender WHERE UserID=@dwUserID
	-- �޸�����
	UPDATE AccountsInfo SET NickName=@strNickName,Gender=@cbGender WHERE UserID=@dwUserID
	
	-- �޸��ǳƼ�¼
	IF @NickName<>@strNickName
	BEGIN
		INSERT INTO QPRecordDBLink.QPRecordDB.dbo.RecordAccountsExpend(UserID,ReAccounts,ClientIP)
		VALUES(@dwUserID,@strNickName,@strClientIP)
	END

	IF @strNickName = N''
	BEGIN
		SET @strNickName = @NickName
	END
	
	-- ��������
	DECLARE @UserChannel AS NVARCHAR(32)
	DECLARE @HeadHttp AS NVARCHAR(256)
	SELECT @UserChannel=UserChannel, @HeadHttp=HeadHttp
	FROM IndividualDatum(NOLOCK) WHERE UserID=@dwUserID
	
	-- �޸�����
	IF @UserChannel IS NULL
	BEGIN
		set @UserChannel =  N''
		set @HeadHttp =  N''
		INSERT IndividualDatum (UserID, Compellation, QQ, EMail, SeatPhone, MobilePhone, DwellingPlace, HeadHttp,UserChannel)
		VALUES (@dwUserID, @strCompellation, @strQQ, @strEMail, @strSeatPhone, @strMobilePhone, @strDwellingPlace, @strHeadHttp, @strUserChannel)
	END

	IF @strNickName = N''
	BEGIN
		SET @strNickName = @NickName
	END

	IF @strHeadHttp = N''
	BEGIN
		SET @strHeadHttp = @HeadHttp
	END
	
	IF @strUserChannel = N''
	BEGIN
		SET @strUserChannel = @UserChannel
	END
	
	-- UPDATE IndividualDatum SET Compellation=@strCompellation, QQ=@strQQ, EMail=@strEMail, SeatPhone=@strSeatPhone,
	--	MobilePhone=@strMobilePhone, DwellingPlace=@strDwellingPlace, UserNote=@strUserNote WHERE UserID=@dwUserID
	-- �޸�����
	UPDATE IndividualDatum SET HeadHttp=@strHeadHttp,UserChannel=@strUserChannel WHERE UserID=@dwUserID
		

	-- ������Ϣ
	IF @@ERROR=0 SET @strErrorDescribe=N'�������Ѿ����������������ϣ�'

	RETURN 0

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------

-- ��������
CREATE PROC GSP_GP_QueryUserInGameServerID
	@dwUserID INT								-- �û� I D
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN
	DECLARE @LockKindID INT
	DECLARE @LockServerID INT
	SELECT @LockKindID=KindID, @LockServerID=ServerID FROM QPTreasureDBLink.QPTreasureDB.dbo.GameScoreLocker WHERE UserID=@dwUserID
	
	IF @LockKindID IS NULL
	BEGIN
		set @LockKindID = 0
		set @LockServerID = 0
	END
	
	SELECT @LockKindID AS LockKindID, @LockServerID AS LockServerID
	
	RETURN 0

END

RETURN 0

GO
