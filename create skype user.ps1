Function GetuserInfo{
    $userinfo = ""|Select-Object userid, Site, extension
    $userinfo.userid = Read-Host "Enter userid"
    $userinfo.Site = Read-Host "Enter Site (3 characters)"
    $userinfo.Extension = Read-Host "Enter user's extension (4 digits)"
    return $userinfo
}

$userinfo = GetuserInfo

Function Connect-Exchange {

    param(
        [Parameter( Mandatory=$false)]
        [string]$URL="dc1prdexc01.internal.********.gov.au"
    )
    
    $ExOPSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://$URL/PowerShell/ -Authentication Kerberos

    Import-PSSession $ExOPSession

}

Function SkypeEnableUsers{
    Param (
        [Parameter(Mandatory=$True)]
        [String]
        $userid,

        [Parameter(Mandatory=$True)]
        [validateset("ADL","CBR","BNE","MEL","SYD")]
        [String]
        $Site,

        [Parameter(Mandatory=$True)]
        [validatelength(4,4)]
        [String]
        $Extension
)

$profile = ""|select-object site, voiceplan, dialplan,LineURIPrefix, pool, extension

If ($site -like "ADL"){
    $profile.site = "Adelaide"
    $profile.voiceplan = "AU-ADL-VP"
    $profile.dialplan = "AU-ADL-DP"
    $profile.LineURIPrefix = "tel:+6188235"
    $profile.extension ="4"+ $Extension.Substring($Extension.length - 3)
    $profile.pool = "ADLPRDSBA10.internal.********.gov.au"

}elseif ($site -like "BNE") {
    $profile.site = "Brisbane"
    $profile.voiceplan = "AU-BNE-VP"
    $profile.dialplan = "AU-BNE-DP"
    $profile.LineURIPrefix = "tel:+6173001"
    $profile.extension = $Extension
    $profile.pool = "BNEPRDSBA10.internal.********.gov.au"
    
}elseif ($site -like "MEL") {
    $profile.Site = "Melbourne"
    $profile.voiceplan = "AU-MEL-VP"
    $profile.dialplan = "AU-MEL-DP"
    $profile.LineURIPrefix = "tel:+6139246"
    $profile.extension = $Extension
    $profile.pool = "MELPRDSBA10.internal.********.gov.au"
}elseif ($site -like "CBR") {
    $profile.site = "Canberra"
    $profile.voiceplan = "AU-CBR-VP"
    $profile.dialplan = "AU-CBR-DP"
    $profile.LineURIPrefix = "tel:+6126213"
    $profile.extension = $Extension
    $profile.pool = "CBRPRDSBA10.internal.********.gov.au"
    
}
elseif ($Site -like "SYD") {
    $profile.site = "Sydney"
    $profile.voiceplan = "AU-SYD-VP"
    $profile.dialplan = "AU-SYD-DP"
    $profile.LineURIPrefix = "tel:+6129210"
    $profile.extension = $Extension
    $profile.pool = "lncpool01.internal.********.gov.au"
}

    Return $profile

}

$profile = SkypeEnableUsers -userid $userinfo.userid -Site $userinfo.site -Extension $userinfo.Extension
$LineURI= $profile.LineURIPrefix+$userinfo.Extension+";ext="+$Profile.Extension

$isUniqueUser = Get-CsUser | where {$_.LineURI -eq $LineURI} |Select-Object DisplayName
$isUniqueRoom = Get-Csmeetingroom | where {$_.LineURI -eq $LineURI} |Select-Object DisplayName

if ($isUniqueUser -or $isUniqueRoom) {
    $DuplicateName=""
    if ($isUniqueUser){$DuplicateName=$isUniqueUser.DisplayName}Else{$DuplicateName=$isUniqueRoom.DisplayName}
    Write-Host "`nThis number is being used by $DuplicateName, pick a different extension number`n" -ForegroundColor Yellow
    Read-Host "Exiting the script, press enter to continue......"
    Exit
}

else {
write-host "`n"
write-host "Confirm following user details: " -f green
write-host "user ID: " $userinfo.userid
write-host "Site: " $profile.site 
write-host "Voice Plan: " $profile.voiceplan
Write-Host "Dial Plan: " $profile.dialplan

Write-Host "LineURI: " $LineURI
Write-Host "Registrar Pool: " $profile.pool
write-host "`n"

[ValidateSet('Y','N')]$Response = Read-Host "Is information above correct? (Y/N)"

if ($Response -eq 'Y') {

    write-host "Update Skype profile now ... "
    Disable-csuser $userinfo.userid
    Enable-CsUser $userinfo.userid -RegistrarPool $profile.pool -SipAddressType EmailAddress
    Start-Sleep -s 10
    set-csuser $userinfo.userid -LineURI $LineURI
    set-csuser $userinfo.userid -EnterpriseVoiceEnabled $true
    Grant-csVoicePolicy  -identity $userinfo.userid -policyname $profile.voiceplan
    Grant-csdialplan -identity $userinfo.userid -policyname $profile.dialplan
    Connect-Exchange 
    Enable-UMMailbox -Identity $userinfo.userid -UMMailboxPolicy AU-EXUM-POL -Extensions $userinfo.Extension
    
    $output = get-csuser $userinfo.userid
    $output
    
    write-host "Done!"
    }
    
    Elseif ($Response -eq 'N') {exit}
    
    
    Read-Host -Prompt "Press Enter to exit"

}
