Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '384,397'
$Form.text                       = "Form"
$Form.TopMost                    = $false

$PictureBox1                     = New-Object system.Windows.Forms.PictureBox
$PictureBox1.width               = 148
$PictureBox1.height              = 100
$PictureBox1.location            = New-Object System.Drawing.Point(20,36)
$PictureBox1.imageLocation       = "Private\Printing\Scripts\img_1.jpg"
$PictureBox1.SizeMode            = [System.Windows.Forms.PictureBoxSizeMode]::zoom
$bottom                          = New-Object system.Windows.Forms.Label
$bottom.text                     = "Bottom Floor"
$bottom.AutoSize                 = $true
$bottom.width                    = 25
$bottom.height                   = 10
$bottom.location                 = New-Object System.Drawing.Point(26,13)
$bottom.Font                     = 'Microsoft Sans Serif,10'

$WinForm1                        = New-Object system.Windows.Forms.Form
$WinForm1.ClientSize             = '400,400'
$WinForm1.text                   = "Form"
$WinForm1.TopMost                = $false

$topFloor                        = New-Object system.Windows.Forms.Label
$topFloor.text                   = "Top Floor"
$topFloor.AutoSize               = $true
$topFloor.width                  = 25
$topFloor.height                 = 10
$topFloor.location               = New-Object System.Drawing.Point(205,13)
$topFloor.Font                   = 'Microsoft Sans Serif,10'

$WinForm2                        = New-Object system.Windows.Forms.Form
$WinForm2.ClientSize             = '400,400'
$WinForm2.text                   = "Form"
$WinForm2.TopMost                = $false

$WinForm3                        = New-Object system.Windows.Forms.Form
$WinForm3.ClientSize             = '400,400'
$WinForm3.text                   = "Form"
$WinForm3.TopMost                = $false

$PictureBox2                     = New-Object system.Windows.Forms.PictureBox
$PictureBox2.width               = 148
$PictureBox2.height              = 100
$PictureBox2.location            = New-Object System.Drawing.Point(205,36)
$PictureBox2.imageLocation       = "Private\Printing\Scripts\img_2.jpg"
$PictureBox2.SizeMode            = [System.Windows.Forms.PictureBoxSizeMode]::zoom
$SelectText                      = New-Object system.Windows.Forms.Label
$SelectText.text                 = "Select your printer:"
$SelectText.AutoSize             = $true
$SelectText.width                = 25
$SelectText.height               = 10
$SelectText.location             = New-Object System.Drawing.Point(26,153)
$SelectText.Font                 = 'Microsoft Sans Serif,10'

$Cancel                          = New-Object system.Windows.Forms.Button
$Cancel.text                     = "Cancel"
$Cancel.width                    = 60
$Cancel.height                   = 30
$Cancel.location                 = New-Object System.Drawing.Point(276,348)
$Cancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$Cancel.Font                     = 'Microsoft Sans Serif,10'

$okButton                        = New-Object system.Windows.Forms.Button
$okButton.text                   = "OK"
$okButton.width                  = 60
$okButton.height                 = 30
$okButton.location               = New-Object System.Drawing.Point(202,348)
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$okButton.Font                   = 'Microsoft Sans Serif,10'

$Groupbox1                       = New-Object system.Windows.Forms.Groupbox
$Groupbox1.height                = 158
$Groupbox1.width                 = 322
$Groupbox1.text                  = "Group Box"
$Groupbox1.location              = New-Object System.Drawing.Point(23,175)

$RadioButton1                    = New-Object system.Windows.Forms.RadioButton
$RadioButton1.text               = "Printer 1"
$RadioButton1.AutoSize           = $true
$RadioButton1.width              = 104
$RadioButton1.height             = 20
$RadioButton1.location           = New-Object System.Drawing.Point(12,15)
$RadioButton1.Font               = 'Microsoft Sans Serif,10'

$RadioButton2                    = New-Object system.Windows.Forms.RadioButton
$RadioButton2.text               = "Printer 2"
$RadioButton2.AutoSize           = $true
$RadioButton2.width              = 104
$RadioButton2.height             = 20
$RadioButton2.location           = New-Object System.Drawing.Point(12,63)
$RadioButton2.Font               = 'Microsoft Sans Serif,10'

$RadioButton3                    = New-Object system.Windows.Forms.RadioButton
$RadioButton3.text               = "Printer 3"
$RadioButton3.AutoSize           = $true
$RadioButton3.width              = 104
$RadioButton3.height             = 20
$RadioButton3.location           = New-Object System.Drawing.Point(12,110)
$RadioButton3.Font               = 'Microsoft Sans Serif,10'

$RadioButton4                    = New-Object system.Windows.Forms.RadioButton
$RadioButton4.text               = "Printer 4"
$RadioButton4.AutoSize           = $true
$RadioButton4.width              = 104
$RadioButton4.height             = 20
$RadioButton4.location           = New-Object System.Drawing.Point(174,15)
$RadioButton4.Font               = 'Microsoft Sans Serif,10'

$RadioButton5                    = New-Object system.Windows.Forms.RadioButton
$RadioButton5.text               = "Printer 5"
$RadioButton5.AutoSize           = $true
$RadioButton5.width              = 104
$RadioButton5.height             = 20
$RadioButton5.location           = New-Object System.Drawing.Point(174,63)
$RadioButton5.Font               = 'Microsoft Sans Serif,10'



$Form.controls.AddRange(@($PictureBox1,$bottom,$topFloor,$PictureBox2,$SelectText,$Cancel,$okButton,$Groupbox1))
$Groupbox1.controls.AddRange(@($RadioButton1,$RadioButton2,$RadioButton3,$RadioButton4,$RadioButton5))

do{
$result = $form.ShowDialog()
$selection = $null
#bool isAnyRadioButtonChecked = false;

    if($result -eq [System.Windows.Forms.DialogResult]::Cancel){
        Exit
    }

    if ($result -eq [System.Windows.Forms.DialogResult]::OK){

    
    
        foreach ($CurrentRadioButton in $Groupbox1.Controls){

            if($CurrentRadioButton.Checked){
                installPrinter($CurrentRadioButton.Text)

                break;
            }
        
        }



    }


}while($selection = $null)


Function installPrinter($SelectedText){
$selection = $null
$prefix = "\\sydprt01v\"
$Printer =$null
$ColourPrinter = $null

    switch($SelectedText){
        "Printer 1" {
            $selection = 1 
            $Printer = $prefix + "SYD-41-City-North"
            $ColourPrinter = $prefix + "SYD-41-City-Colour"
            ;break
        }"Printer 2" {
            $selection = 2 
            $Printer = $prefix + "SYD-41-City-West"
            $ColourPrinter = $prefix + "SYD-41-City-West-Colour"
            ;break
        }"Printer 3" {
            $selection = 3 
            $Printer = $prefix + "Cockle-Bay"
            $ColourPrinter = $prefix + "Cockle-Bay-Colour"
            ;break
        }"Printer 4" {
            $selection = 4 
            $Printer = $prefix + "Harbour"
            $ColourPrinter = $prefix + "Harbour-Colour"
            ;break
        }"Printer 5" {
            $selection = 5 
            $Printer = $prefix + "Botany-Bay"
            $ColourPrinter = $prefix + "Botany-Bay-Colour"
            ;break
        }default {
            [System.Windows.MessageBox]::Show('No Printer selected') }
    }

    if($selection -isnot $null){
        Add-Printer -ConnectionName $Printer
        Add-Printer -ConnectionName $ColourPrinter
        $DefaultPrinter = Get-WmiObject win32_Printer -Filter "ConnectionName=$Printer"
        $DefaultPrinter.SetDefaultPrinter()

        [System.Windows.MessageBox]::Show('Printer ' + $selection + ' installed')
    }
}
