#Setting power defaults
cmd /c Powercfg /Change standby-timeout-dc 180
cmd /c Powercfg /Change standby-timeout-ac 0
 
cmd /c Powercfg /Change monitor-timeout-ac 60
cmd /c Powercfg /Change monitor-timeout-dc 20

#Registry key paths 
$paths = @("HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel",
"HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu")
#Property name 
$name = "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" 

foreach ($path in $paths){
    $item = Get-ItemProperty -Path $path -Name $name -ErrorAction SilentlyContinue
     
    if($item) { 
        #set property value 
        Set-ItemProperty  -Path $path -name $name -Value 0  
    } Else { 
        #create a new property 
        New-ItemProperty -Path $path -Name $name -Value 0 -PropertyType DWORD  | Out-Null  
    } 

}


$edgePath = "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main"

New-ItemProperty -Path $registryPath -Name "HomeButtonPage" -Value "C:\Program Files\BCG\BCGHomepage\BCGHomepage.html" 
    -PropertyType SZ -Force | Out-Null

New-ItemProperty -Path $registryPath -Name "HomeButtonEnabled" -Value 1 
    -PropertyType DWORD -Force | Out-Null
