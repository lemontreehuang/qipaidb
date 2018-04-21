USE QPAccountsDB
GO

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT [SystemStatusInfo] ([StatusName],[StatusValue],[StatusString],[StatusTip],[StatusDescription]) VALUES ( N'BankPrerequisite',2000,N'���д�ȡ��������ȡ�����������ڴ����ſɲ�����',N'��ȡ����',N'��ֵ����ʾ��ȡ�����������ڴ����ſɴ�ȡ')
INSERT [SystemStatusInfo] ([StatusName],[StatusValue],[StatusString],[StatusTip],[StatusDescription]) VALUES ( N'EnjoinInsure',0,N'����ϵͳά������ʱֹͣ��Ϸϵͳ�ı��չ������������վ������Ϣ��',N'���з���',N'��ֵ��0-������1-�ر�')
INSERT [SystemStatusInfo] ([StatusName],[StatusValue],[StatusString],[StatusTip],[StatusDescription]) VALUES ( N'EnjoinLogon',0,N'����ϵͳά������ʱֹͣ��Ϸϵͳ�ĵ�¼������������վ������Ϣ��',N'��¼����',N'��ֵ��0-������1-�ر�')
INSERT [SystemStatusInfo] ([StatusName],[StatusValue],[StatusString],[StatusTip],[StatusDescription]) VALUES ( N'EnjoinRegister',0,N'����ϵͳά������ʱֹͣ��Ϸϵͳ��ע�������������վ������Ϣ��',N'ע�����',N'��ֵ��0-������1-�ر�')
INSERT [SystemStatusInfo] ([StatusName],[StatusValue],[StatusString],[StatusTip],[StatusDescription]) VALUES ( N'GrantIPCount',5,N'���û�ע��IPÿ���������ƣ�',N'ע��IP����',N'��ֵ����ʾͬһ��IP������͵Ĵ��������������������ͽ��')
INSERT [SystemStatusInfo] ([StatusName],[StatusValue],[StatusString],[StatusTip],[StatusDescription]) VALUES ( N'GrantScoreCount',111111,N'���û�ע��ϵͳ�ͽ�ҵ���Ŀ��',N'ע������',N'��ֵ����ʾ���͵Ľ������')
INSERT [SystemStatusInfo] ([StatusName],[StatusValue],[StatusString],[StatusTip],[StatusDescription]) VALUES ( N'GrantScoreInsure',3,N'���û�ע��ϵͳ��Ԫ������Ŀ��',N'ע������',N'��ֵ����ʾ���͵�Ԫ������')
INSERT [SystemStatusInfo] ([StatusName],[StatusValue],[StatusString],[StatusTip],[StatusDescription]) VALUES ( N'MedalRate',10,N'����ϵͳ�������ʣ�ǧ�ֱȣ������Ƹ������ÿ����Ϸ˰�շ�������ң�',N'���Ʒ���',N'��ֵ����ʾ����ϵͳ��������ֵ��ǧ�ֱȣ���')
INSERT [SystemStatusInfo] ([StatusName],[StatusValue],[StatusString],[StatusTip],[StatusDescription]) VALUES ( N'RevenueRateTake',10,N'����ȡ�����˰�ձ��ʣ�ǧ�ֱȣ���',N'ȡ��˰��',N'��ֵ����ʾ����ȡ�����˰�ձ���ֵ��ǧ�ֱȣ���')
INSERT [SystemStatusInfo] ([StatusName],[StatusValue],[StatusString],[StatusTip],[StatusDescription]) VALUES ( N'RevenueRateTransfer',10,N'����ת�˲���˰�ձ��ʣ�ǧ�ֱȣ���',N'ת��˰��',N'��ֵ����ʾ����ת�˲���˰�ձ���ֵ��ǧ�ֱȣ���')
INSERT [SystemStatusInfo] ([StatusName],[StatusValue],[StatusString],[StatusTip],[StatusDescription]) VALUES ( N'TransferNullity',1,N'��Ա��ת���Ƿ���ȡ�����ѣ�',N'ת���Ƿ���˰',N'')
INSERT [SystemStatusInfo] ([StatusName],[StatusValue],[StatusString],[StatusTip],[StatusDescription]) VALUES ( N'TransferPrerequisite',10000,N'����ת��������ת�˽����������ڴ����ſ�ת�ˣ�',N'ת������',N'��ֵ����ʾת�˽����������ڴ����ſ�ת��')
INSERT [SystemStatusInfo] ([StatusName],[StatusValue],[StatusString],[StatusTip],[StatusDescription]) VALUES ( N'SubsistenceAllowancesCondition', 1000, N'��ȡ�ͱ������Ϸ�Ҳ��ܵ���', N'�ͱ���ȡ����', N'��ֵ����ȡ�ͱ���ҽ�Ҳ��ܵ��ڸý����')
INSERT [SystemStatusInfo] ([StatusName],[StatusValue],[StatusString],[StatusTip],[StatusDescription]) VALUES ( N'SubsistenceAllowancesGold', 1000, N'ÿ�εͱ�����Ϸ����', N'�ͱ�ÿ�ν��', N'��ֵ��ÿ�εͱ��Ľ����')
INSERT [SystemStatusInfo] ([StatusName],[StatusValue],[StatusString],[StatusTip],[StatusDescription]) VALUES ( N'SubsistenceAllowancesNumber', 3, N'ÿ��ͱ�����', N'ÿ��ͱ�����', N'��ֵ��ÿ��ͱ�����')
INSERT [SystemStatusInfo] ([StatusName],[StatusValue],[StatusString],[StatusTip],[StatusDescription]) VALUES ( N'MaxSiginDay', 30, N'���ǩ������', N'', N'')
INSERT [SystemStatusInfo] ([StatusName],[StatusValue],[StatusString],[StatusTip],[StatusDescription]) VALUES ( N'SiginDayGold', 500, N'ÿ��ǩ����ȡ�������', N'', N'')
INSERT [SystemStatusInfo] ([StatusName],[StatusValue],[StatusString],[StatusTip],[StatusDescription]) VALUES ( N'PublicNotice', 0, N'��ӭ�����������ֳǣ�\n��ӭ�����������ֳǣ�\n��ӭ�����������ֳǣ�', N'', N'')
INSERT [SystemStatusInfo] ([StatusName],[StatusValue],[StatusString],[StatusTip],[StatusDescription]) VALUES ( N'HN_SC_NOTICE', 0, N'ȦȦ�Ĵ��齫�ž���ң��κ�˵����ҵĶ���ƭ�ӡ�|ȦȦ�Ĵ��齫����������Ϸ������Ĳ���', N'', N'')

INSERT [SystemStatusInfo] ([StatusName], [StatusValue], [StatusString], [StatusTip], [StatusDescription]) VALUES (N'WinExperience', 10, N'Ӯ�ֽ����ľ���ֵ', N'Ӯ�־���', N'��ֵ��Ӯ�ֽ����ľ���ֵ')
INSERT [SystemStatusInfo] ([StatusName], [StatusValue], [StatusString], [StatusTip], [StatusDescription]) VALUES (N'MedalExchangeRate', 1000, N'Ԫ������Ϸ�Ҷһ���', N'Ԫ���һ���', N'��ֵ��1��Ԫ���һ�������Ϸ��')
