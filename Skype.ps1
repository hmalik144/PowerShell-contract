Disable-csuser userid
Enable-CsUser userid -RegistrarPool "lncpool01.internal.*****.***.au" -SipAddressType EmailAddress
set-csuser userid -LineURI "tel:+61*****xxxx;ext=xxxx" -EnterpriseVoiceEnabled $true
Grant-csVoicePolicy -identity userid -policyname AU-SYD-VP
Grant-csdialplan -identity userid -policyname AU-SYD-DP
