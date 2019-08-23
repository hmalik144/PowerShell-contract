$printerName = "HP_Wireless_Printer"
$printerInfPath = "Private\LAN\Drivers\Printers\Hp\UPD\PCL5_v5.5\x64\hpcu130t.inf"
$printDriverName = "HP Color LaserJet Enterprise Flow MFP M577z"
$printerIP = "169.254.228.56"


$portExists = Get-Printerport -Name $printerName -ErrorAction SilentlyContinue

if (-not $portExists) {
  Add-PrinterPort -name $printerName -PrinterHostAddress $printerIP
}

$printDriverExists = Get-PrinterDriver -name $printDriverName -ErrorAction SilentlyContinue

if (-not $printDriverExists) {
    Add-PrinterDriver -Name $printDriverName -InfPath $printerInfPath
}else{
    
}

Add-Printer -Name "HP Wireless Printer" -PortName $printerName -DriverName $printDriverName
