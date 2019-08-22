Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName PresentationFramework

# Creation of form object
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Zero Account Creation'
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
$label.Text = 'Please enter APRA username:'
$form.Controls.Add($label)

# TextBox object
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,40)
$textBox.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBox)

$form.Topmost = $true

$form.Add_Shown({$textBox.Select()})

Do
{
    # open Dailog
    $result = $form.ShowDialog()

    Try
    {
        # if 'Ok' was clicked
        if ($result -eq [System.Windows.Forms.DialogResult]::OK){
            $getUsername = $textBox.Text.Trim()
            $checkUsername = Get-ADUser -Identity $getUsername -Properties *
   
        }

        # if 'Cancel' was clicked
        if($result -eq [System.Windows.Forms.DialogResult]::Cancel){
            Exit
        }
    }
    Catch
    {
        # Couldn't be found the user, Show message:
        [System.Windows.MessageBox]::Show('Cannot find APRA account for ' + $textBox.Text)

        # Restart loop
        $getUsername = $null
    }

}
While ($getUsername -eq $null)

# Clear variable from previous use
$zeroaccountname = $null

try{
    # Zero account SamAccountName variable
    $AccountName = "0" + $checkUsername.SamAccountName
    # get the 0 account
    $zeroaccountname = Get-ADUser -Identity $AccountName -Properties *

}catch{
    # could not get the 0 account, error to log
    write-error "No existing zero account exists"
    
}finally{
    # Zero account doesnt exist
    if($zeroaccountname -eq $null){

        # create zero account variables from APRA account details
        $AccountName = "0" + $checkUsername.SamAccountName
        $FirstName = $checkUsername.GivenName
        $Surname = $checkUsername.Surname
        $Name = $checkUsername.Name + " (Zero)"
        $UserPrincipalName = "0" + $checkUsername.UserPrincipalName

        # Create a new 0 account user in 'Administrative Accounts' in AD
    	New-ADUser `
            -SamAccountName $AccountName `
            -UserPrincipalName $UserPrincipalName `
            -Name "$Name" `
            -GivenName $Firstname `
            -Surname $Surname `
            -Enabled $True `
            -DisplayName "$Name" `
            -Description "Created By Zero Account creater" `
            -Path 'OU=Administrative Accounts, dc=internal,dc=*******,dc=gov,dc=au' `
            -AccountPassword (convertto-securestring "" -AsPlainText -Force) -ChangePasswordAtLogon $True

        [System.Windows.MessageBox]::Show('Zero Account Created for ')
    }else {
        # user already exists
        [System.Windows.MessageBox]::Show('Zero Account Exists for ' + $zeroaccountname.SamAccountName)
    }

    #Exit
}
