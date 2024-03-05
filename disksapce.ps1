# Define threshold level in percentage (e.g., 10%)
$thresholdLevel = 10

# Define email settings
$from = "akumar4k@gmail.com"
$to = "kakkerlaak@msn.com"
$subject = "Drive Space Alert"
$body = "One or more drives have fallen below the threshold level of $thresholdLevel% free space."

# Function to send email
function Send-Email {
    param (
        [string]$from,
        [string]$to,
        [string]$subject,
        [string]$body
    )

    $smtpServer = "smtp.gmail.com"
    $smtpPort = 587
    $smtpUsername = "your_email@gmail.com"
    $smtpPassword = "your_password" | ConvertTo-SecureString -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential ($smtpUsername, $smtpPassword)

    Send-MailMessage -From $from -To $to -Subject $subject -Body $body -SmtpServer $smtpServer -Port $smtpPort -UseSsl -Credential $credential
}

# Get drive information
$drives = Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3" | Select-Object DeviceID, FreeSpace, Size

# Check each drive
foreach ($drive in $drives) {
    $driveLetter = $drive.DeviceID
    $freeSpacePercent = [math]::Round(($drive.FreeSpace / $drive.Size) * 100, 2)

    # If free space is below threshold, send alert
    if ($freeSpacePercent -lt $thresholdLevel) {
        $alertMessage = "Drive $driveLetter has $freeSpacePercent% free space remaining."
        Send-Email -from $from -to $to -subject $subject -body $alertMessage
    }
}
