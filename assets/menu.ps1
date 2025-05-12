# Load Windows Forms assembly
Add-Type -AssemblyName System.Windows.Forms

# Create a new form (window)
$form = New-Object System.Windows.Forms.Form
$form.Text = "Select Action"
$form.Width = 300
$form.Height = 200

# Create Open as Admin Button
$btnAdmin = New-Object System.Windows.Forms.Button
$btnAdmin.Text = "Open as Admin"
$btnAdmin.Width = 150
$btnAdmin.Height = 30
$btnAdmin.Top = 30
$btnAdmin.Left = 75

# Create Open as System Button
$btnSystem = New-Object System.Windows.Forms.Button
$btnSystem.Text = "Open as System (Hidden)"
$btnSystem.Width = 150
$btnSystem.Height = 30
$btnSystem.Top = 80
$btnSystem.Left = 75

# Define action for Open as Admin button
$btnAdmin.Add_Click({
    Set-Content -Path "flags.bat" -Value "set mode=1"
    $form.Close()
})

# Define action for Open as System button
$btnSystem.Add_Click({
    Set-Content -Path "flags.bat" -Value "set mode=2"
    $form.Close()
})

# Add buttons to the form
$form.Controls.Add($btnAdmin)
$form.Controls.Add($btnSystem)

# Initialize file
Set-Content -Path "flags.bat" -Value "set mode=0"

# Show the form
$form.ShowDialog() | Out-Null
