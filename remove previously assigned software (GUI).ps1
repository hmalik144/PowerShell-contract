Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName PresentationFramework

# Creation of form object
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Remove Assigned Software'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

# OK button object
$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(75,120)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = 'OK'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

# Cancel Button object
$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(150,120)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

# Label object
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please enter Asset Number:'
$form.Controls.Add($label)

# TextBox object
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,40)
$textBox.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBox)


$form.Topmost = $true
$form.Add_Shown({$textBox.Select()})

#Do/While loop while looking for a correct APRA usrename
Do
{
    #Show Dialog box
    $result = $form.ShowDialog()

    Try
    {
        #if 'Ok' is clicked
        if ($result -eq [System.Windows.Forms.DialogResult]::OK){
            $inputText = $textBox.Text.Trim()


            if ($textBox.Text.Trim().Contains('-')){
                $getAssetNumber = $inputText.ToUpper()
                $ComputerObject = Get-ADComputer $getAssetNumber
            }else{
                [System.Windows.MessageBox]::Show('Cannot find Computer for ' + $textBox.Text)
            }
        
        }
        # if 'Cancel' is clicked
        if($result -eq [System.Windows.Forms.DialogResult]::Cancel){
            Exit
        }
    }
    Catch
    {
        # Couldn't be found the user, Display message:
        [System.Windows.MessageBox]::Show('Cannot find Computer for ' + $textBox.Text)

        # restart loop
        $getAssetNumber = $null
    }

}
While ($getAssetNumber -eq $null)



$List = (Get-adcomputer $ComputerObject.DistinguishedName –Properties MemberOf).MemberOf

#Write-Warning -Message "Could not find a user with the username: $List. Please check the spelling and try again."

if ($List -eq ''){
    [System.Windows.MessageBox]::Show('No Assigned Software for ' + $textBox.Text)
}else{
    foreach($item in $List){

    $name = ($item -split ',*..=')[1]

    Write-Output $name

    remove-adgroupmember -Identity $name -Members $ComputerObject.DistinguishedName 

    }

    [System.Windows.MessageBox]::Show('No Assigned Software for ' + $textBox.Text)
}

