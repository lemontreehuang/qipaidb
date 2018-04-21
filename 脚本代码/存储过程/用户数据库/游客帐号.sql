
----------------------------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------

USE QPAccountsDB
GO


IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[GSP_GR_EfficacyVisitorID]') and OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[GSP_GR_EfficacyVisitorID]
GO

SET QUOTED_IDENTIFIER ON 
GO

SET ANSI_NULLS ON 
GO

----------------------------------------------------------------------------------------------------

-- I D ��¼
CREATE PROC GSP_GR_EfficacyVisitorID
	@strClientIP NVARCHAR(15),					-- ���ӵ�ַ
	@strMachineSerial NCHAR(32)				-- ������ʶ
WITH ENCRYPTION AS

-- ��������
SET NOCOUNT ON

-- ������Ϣ
DECLARE @strAccounts AS NVARCHAR(31)

-- ��������
DECLARE @EnjoinLogon BIGINT
DECLARE @ErrorDescribe AS NVARCHAR(128)

-- ִ���߼�
BEGIN
	-- Ч���ַ
	SELECT @EnjoinLogon=EnjoinLogon FROM ConfineAddress(NOLOCK) WHERE AddrString=@strClientIP AND GETDATE()<EnjoinOverDate
	IF @EnjoinLogon IS NOT NULL AND @EnjoinLogon<>0
	BEGIN
		SELECT [ErrorDescribe]=N'��Ǹ��֪ͨ����ϵͳ��ֹ�������ڵ� IP ��ַ����Ϸ��¼Ȩ�ޣ�����ϵ�ͻ����������˽���ϸ�����'
		RETURN 4
	END
	
	-- Ч�����
	SELECT @EnjoinLogon=EnjoinLogon FROM ConfineMachine(NOLOCK) WHERE MachineSerial=@strMachineSerial AND GETDATE()<EnjoinOverDate
	IF @EnjoinLogon IS NOT NULL AND @EnjoinLogon<>0
	BEGIN
		SELECT [ErrorDescribe]=N'��Ǹ��֪ͨ����ϵͳ��ֹ�����Ļ�������Ϸ��¼Ȩ�ޣ�����ϵ�ͻ����������˽���ϸ�����'
		RETURN 7
	END
	
	SELECT @strAccounts = 'V'+RIGHT(1000001+ISNULL(RIGHT(MAX(VisitorIdex),6),0),6) FROM Visitor
	
	INSERT Visitor (VisitorIdex)
	VALUES (@strAccounts)
	
	-- �������
	SELECT @strAccounts AS Accounts
END

RETURN 0

GO

----------------------------------------------------------------------------------------------------