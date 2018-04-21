
----------------------------------------------------------------------------------------------------

USE QPTreasureDB
GO

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_WriteGameScore]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_WriteGameScore]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- ��Ϸд��
CREATE PROC GSP_GR_WriteGameScore

	-- �û���Ϣ
	@dwUserID INT,								-- �û� I D
	@dwDBQuestID INT,							-- �����ʶ
	@dwInoutIndex INT,							-- ��������

	-- ����ɼ�
	@lVariationScore BIGINT,					-- �û�����
	@lVariationGrade BIGINT,					-- �û��ɼ�
	@lVariationInsure BIGINT,					-- �û�����
	@lVariationRevenue BIGINT,					-- ��Ϸ˰��
	@lVariationWinCount INT,					-- ʤ������
	@lVariationLostCount INT,					-- ʧ������
	@lVariationDrawCount INT,					-- �;�����
	@lVariationFleeCount INT,					-- ������Ŀ
	@lVariationUserMedal INT,					-- �û�����
	@lVariationExperience INT,					-- �û�����
	@lVariationLoveLiness INT,					-- �û�����
	@dwVariationPlayTimeCount INT,				-- ��Ϸʱ��

	-- ������Ϣ
	@wKindID INT,								-- ��Ϸ I D
	@wServerID INT,								-- ���� I D
	@strClientIP NVARCHAR(15)					-- ���ӵ�ַ

WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ִ���߼�
BEGIN

	DECLARE @TreasureScore BIGINT
	SELECT @TreasureScore=Score+@lVariationScore FROM QPTreasureDBLink.QPTreasureDB.dbo.GameScoreInfo WHERE UserID=@dwUserID
	
	if @TreasureScore < 0
	BEGIN							
		SET @TreasureScore=0
	END	
	
	-- �û�����
	UPDATE QPTreasureDBLink.QPTreasureDB.dbo.GameScoreInfo SET Score=@TreasureScore,
		WinCount=WinCount+@lVariationWinCount, LostCount=LostCount+@lVariationLostCount, DrawCount=DrawCount+@lVariationDrawCount,
		FleeCount=FleeCount+@lVariationFleeCount, PlayTimeCount=PlayTimeCount+@dwVariationPlayTimeCount
	WHERE UserID=@dwUserID

	-- ȫ����Ϣ
	IF @lVariationExperience>0 OR @lVariationLoveLiness>0 OR @lVariationUserMedal>0
	BEGIN
		UPDATE QPAccountsDBLink.QPAccountsDB.dbo.AccountsInfo SET Experience=Experience+@lVariationExperience, LoveLiness=LoveLiness+@lVariationLoveLiness,
			UserMedal=UserMedal+@lVariationUserMedal
		WHERE UserID=@dwUserID
	END

END

RETURN 0

GO

----------------------------------------------------------------------------------------------------