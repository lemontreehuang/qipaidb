USE QPTreasureDB
GO
-- ת��  
CREATE PROC GSP_GR_FengziZZJL  
 @dwUserID INT,        -- �û���ʶ  
 @strErrorDescribe NVARCHAR(127) OUTPUT  -- �����Ϣ  
WITH ENCRYPTION AS  
  
-- ��������  
SET NOCOUNT ON  
  
-- ִ���߼�  
BEGIN  

  SELECT t2.Accounts as SourceAccounts, t3.Accounts as TargetAccounts,t3.GameID , t1.SwapScore, t1.Revenue, t1.CollectDate
  FROM RecordInsure t1, QPAccountsDBLink.QPAccountsDB.dbo.AccountsInfo t2, QPAccountsDBLink.QPAccountsDB.dbo.AccountsInfo t3
  WHERE t1.SourceUserID = t2.UserID
  AND   t1.TargetUserID = t3.UserID
  AND   (t1.SourceUserID = @dwUserID or t1.TargetUserID = @dwUserID) Order by t1.CollectDate desc
  
END  
  
RETURN 0  
  