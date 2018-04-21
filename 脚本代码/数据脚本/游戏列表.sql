
----------------------------------------------------------------------------------------------------

USE QPPlatformDB
GO

-- ɾ������
DELETE GameTypeItem
DELETE GameKindItem
DELETE GameNodeItem
DELETE GameGameItem
DELETE DataBaseInfo
DELETE PrivateInfo
GO

----------------------------------------------------------------------------------------------------

INSERT DataBaseInfo (DBAddr, DBPort, DBUser, DBPassword,MachineID,Information) VALUES ('127.0.0.1',1433,'sa','fangyuan1793','','')

----------------------------------------------------------------------------------------------------

-- ��������
INSERT GameTypeItem (TypeID, TypeName, SortID, Nullity) VALUES ( 1, '�Ƹ���Ϸ',100, 0)
INSERT GameTypeItem (TypeID, TypeName, SortID, Nullity) VALUES ( 2, '������Ϸ',200, 0)
INSERT GameTypeItem (TypeID, TypeName, SortID, Nullity) VALUES ( 3, '������Ϸ',300, 0)
INSERT GameTypeItem (TypeID, TypeName, SortID, Nullity) VALUES ( 4, '�齫��Ϸ',400, 0)
INSERT GameTypeItem (TypeID, TypeName, SortID, Nullity) VALUES ( 5, '������Ϸ',500, 0)
INSERT GameTypeItem (TypeID, TypeName, SortID, Nullity) VALUES ( 6, '��Ƶ��Ϸ',600, 0)

----------------------------------------------------------------------------------------------------

INSERT GameKindItem (KindID, GameID, TypeID, JoinID,SortID,KindName,ProcessName,GameRuleUrl,DownLoadUrl,Nullity) VALUES ( 122,122,2,0,100, '�ټ���','BaccaratNew.exe',0,0,0)
INSERT GameGameItem (GameID, GameName, SuporType, DataBaseAddr,DataBaseName,ServerVersion,ClientVersion,ServerDLLName,ClientExeName) VALUES ( 122, '�ټ���',1,'127.0.0.1','QPTreasureDB',101056515,101056515,'BaccaratNewServer','BaccaratNew.exe')

INSERT GameKindItem (KindID, GameID, TypeID, JoinID,SortID,KindName,ProcessName,GameRuleUrl,DownLoadUrl,Nullity) VALUES ( 27,27,2,0,100, 'ţ���','OxNew.exe',0,0,0)
INSERT GameGameItem (GameID, GameName, SuporType, DataBaseAddr,DataBaseName,ServerVersion,ClientVersion,ServerDLLName,ClientExeName) VALUES ( 27, 'ţ���',1,'127.0.0.1','QPTreasureDB',101056515,101056515,'OxNewServer','OxNew.exe')

INSERT GameKindItem (KindID, GameID, TypeID, JoinID,SortID,KindName,ProcessName,GameRuleUrl,DownLoadUrl,Nullity) VALUES ( 302,302,2,0,100, 'Ѫս�齫','SparrowXZ.exe',0,0,0)
INSERT GameGameItem (GameID, GameName, SuporType, DataBaseAddr,DataBaseName,ServerVersion,ClientVersion,ServerDLLName,ClientExeName) VALUES ( 302, 'Ѫս�齫',1,'127.0.0.1','QPTreasureDB',101056515,101056515,'SparrowXZServer','SparrowXZ.exe')

INSERT PrivateInfo 	(KindID, PlayCout1, PlayCost1,PlayCout2, PlayCost2,PlayCout3, PlayCost3,PlayCout4, PlayCost4,CostGold) 
			VALUES ( 310, 8,1,16,2,0,0,0,0,50)
INSERT PrivateInfo 	(KindID, PlayCout1, PlayCost1,PlayCout2, PlayCost2,PlayCout3, PlayCost3,PlayCout4, PlayCost4,CostGold) 
			VALUES ( 302, 6,1,12,2,0,0,0,0,50)

INSERT GameKindItem (KindID, GameID, TypeID, JoinID,SortID,KindName,ProcessName,GameRuleUrl,DownLoadUrl,Nullity) VALUES ( 108,108,2,0,100, '���۱���','BumperCarBattle.exe',0,0,0)
INSERT GameGameItem (GameID, GameName, SuporType, DataBaseAddr,DataBaseName,ServerVersion,ClientVersion,ServerDLLName,ClientExeName) VALUES ( 108, '���۱���',1,'127.0.0.1','QPTreasureDB',101056515,101056515,'BumperCarBattleServer','BumperCarBattle.exe')

INSERT GameKindItem (KindID, GameID, TypeID, JoinID,SortID,KindName,ProcessName,GameRuleUrl,DownLoadUrl,Nullity) VALUES ( 404,404,2,0,100, '����','Round.exe',0,0,0)
INSERT GameGameItem (GameID, GameName, SuporType, DataBaseAddr,DataBaseName,ServerVersion,ClientVersion,ServerDLLName,ClientExeName) VALUES ( 404, '����',1,'127.0.0.1','QPTreasureDB',101056515,101056515,'RoundServer','Round.exe')


INSERT GameKindItem (KindID, GameID, TypeID, JoinID,SortID,KindName,ProcessName,GameRuleUrl,DownLoadUrl,Nullity) VALUES ( 310,310,2,0,100, '�����齫','HNMJ.exe',0,0,0)
INSERT GameGameItem (GameID, GameName, SuporType, DataBaseAddr,DataBaseName,ServerVersion,ClientVersion,ServerDLLName,ClientExeName) VALUES ( 310, '�����齫',1,'127.0.0.1','QPTreasureDB',101056515,101056515,'HNMJServer','HNMJ.exe')


INSERT GameKindItem (KindID, GameID, TypeID, JoinID,SortID,KindName,ProcessName,GameRuleUrl,DownLoadUrl,Nullity) VALUES ( 320,320,2,0,100, '�ϲ��齫','NCMJ.exe',0,0,0)
INSERT GameGameItem (GameID, GameName, SuporType, DataBaseAddr,DataBaseName,ServerVersion,ClientVersion,ServerDLLName,ClientExeName) VALUES ( 320, '�ϲ��齫',1,'127.0.0.1','QPTreasureDB',101056515,101056515,'NCMJServer','NCMJ.exe')


GO


USE QPGameMatchDB
GO
DELETE MatchPublic
DELETE MatchImmediate
DELETE MatchLockTime
DELETE MatchReward

INSERT MatchPublic (MatchID,MatchNo,KindID,MatchName,MatchType,MatchFeeType,MatchFee,MatchEnterScore,MemberOrder,CollectDate) VALUES (1,1,302,N'Ѫս���ױ���',1,0,100,1000,0,0)
INSERT MatchImmediate (MatchID,MatchNo,StartUserCount,AndroidUserCount,InitialBase,InitialScore,MinEnterGold,PlayCount,SwitchTableCount,PrecedeTimer) 
VALUES (1,1,4,0,100,1000,100,2,0,0)

INSERT MatchPublic (MatchID,MatchNo,KindID,MatchName,MatchType,MatchFeeType,MatchFee,MatchEnterScore,MemberOrder,CollectDate) VALUES (3,3,302,N'Ѫս���ױ���',0,0,100,1000,0,0)
INSERT MatchLockTime (MatchID,MatchNo,StartTime,EndTime,InitScore,CullScore,MinPlayCount) 
VALUES (3,3,'2016-04-21 0:0:0','2017-04-21 0:0:0',1000,100,2)

INSERT MatchReward (MatchID,MatchNo,MatchRank,RewardGold,RewardMedal,RewardExperience,RewardDescibe) VALUES (1,1,1,4000,0,0,N'���')
INSERT MatchReward (MatchID,MatchNo,MatchRank,RewardGold,RewardMedal,RewardExperience,RewardDescibe) VALUES (1,1,2,3000,0,0,N'���')
INSERT MatchReward (MatchID,MatchNo,MatchRank,RewardGold,RewardMedal,RewardExperience,RewardDescibe) VALUES (1,1,3,2000,0,0,N'���')
INSERT MatchReward (MatchID,MatchNo,MatchRank,RewardGold,RewardMedal,RewardExperience,RewardDescibe) VALUES (1,1,4,1000,0,0,N'���')
GO