#region
#Form formate that might come in handy later unsure of the .Net Framwork
# # Init PowerShell GUI
# Add-Type -AssemblyName System.Windows.Forms

# # Create a new form
# $LocalPrinterForm = New-Object system.Windows.Forms.Form

# # Define the size, title, and background color
# $LocalPrinterForm.ClientSize = '1080,1920'
# $LocalPrinterForm.Text = "Tech Buddy"
# $LocalPrinterForm.BackColor = "#ffffff"

# # Add a label with your message
# $stringGreeting = New-Object System.Windows.Forms.Label
# $stringGreeting.Text = "Welcome to Tech Buddy!"
# $stringGreeting.Location = '50,50'
# $stringGreeting.AutoSize = $true
# $LocalPrinterForm.Controls.Add($label)

# # Display the form
# [void]$LocalPrinterForm.ShowDialog()
#endregion

function StartUpTitle{
    Write-Host '`n'
    Write-Host '          ############    #######       ###    ##   ##        #####      ##   ##    ####       ####    ##      ##'
    Write-Host '              ###         ##          ##       ##   ##        ##   ##    ##   ##    ##  #      ##  #    ##    ##'
    Write-Host '              ###         ##         ##        ##   ##        ##    #    ##   ##    ##   #     ##   #    ##  ##'
    Write-Host '              ###         #######    ##        #######        ######     ##   ##    ##    #    ##    #     ##'
    Write-Host '              ###         ##         ##        ##   ##        ##    #    ##   ##    ##    #    ##    #    ##'
    Write-Host '              ###         ##          ##       ##   ##        ##   ##    ##   ##    ##   #     ##   #    ##'
    Write-Host '              ###         #######       ###    ##   ##        #####      #######    ####       ####     ##'
    #Function runs to show a please wait message so the rest of the script can load. 
    stringdotAnimation
}

#Visual Helpers 
function stringdotAnimation{
    #Variables
    $LoadingAnimation = ""  #Holds the . being used to animate the please wait string
    $MaxDots = 5    #max amount of dots shown before resetting. this will show 4 dots on screen
    
    # Nested Function to clear the current line
    function Clear-Line {
        $Host.UI.RawUI.CursorPosition = @{X=0; Y=$Host.UI.RawUI.CursorPosition.Y}
        Write-Host (" " * ($MaxDots + 12)) -NoNewline
        $Host.UI.RawUI.CursorPosition = @{X=0; Y=$Host.UI.RawUI.CursorPosition.Y}
    }
    
    Write-Host "Please wait" -NoNewline # Shows Please Wait Text

    # Create a Stopwatch object
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

    # Loop while true
    while ($true) {
        # Add a dot to the loading animation
        $LoadingAnimation += "."

        # Write the current state of the loading animation
        Write-Host "`rPlease wait$LoadingAnimation" -NoNewline

        # Reset the animation if it reaches the max number of dots
        if ($LoadingAnimation.Length -ge $MaxDots) {
            Clear-Line
            Write-Host "`rPlease wait" -NoNewline  # Clear the line and write 'Please wait'
            $LoadingAnimation = ""  # Reset the loading animation string
        }

        # Sleep for 1 second
        Start-Sleep -Seconds 1

        # Check if 6 seconds have passed
        if ($stopwatch.Elapsed.TotalSeconds -ge 6) {
            break
        }
    }

    # Stop the stopwatch
    $stopwatch.Stop()
    Clear-Line
    Write-Host "`rDone"
    GreetingLogs
}

function GreetingLogs{
    #Variables 
    $GreetMessage = "Hello, I'm Your Tech Buddy, Here to help`n
    I just need to get some of your details before I start`n"
    Write-Host "$GreetMessage"
    LaptopInfo
}

function LaptopInfo {
    # Variables
    $Username = whoami.exe
    $LaptopModelInternal = (Get-ComputerInfo -Property csModel).CsModel
    $serialNumber = (Get-ComputerInfo -Property biosSerialNumber).biosSerialNumber
    $assetNumber = (Get-ComputerInfo -Property csName).csName
    $uuidNumber = (Get-WmiObject -Class Win32_ComputerSystemProduct).UUID
    $DatenTime = Get-Date

    # Create Custom Object
    $computerInfo = [PSCustomObject]@{
        'Username'      = $Username
        'Model'         = $LaptopModelInternal
        'Asset'         = $assetNumber
        'Serial Number' = $serialNumber
        'UUID'          = $uuidNumber
        'Date'          = $DatenTime
    }

    # Display the custom object
    $computerInfo | Format-List

    # Nested function to store data inside a text file
    function StoreData {
        param (
            [string]$FilePath,
            [PSCustomObject]$Data
        )
        
        # Combine and format the output
        $formattedOutput = @"
Username       : $($Data.Username)
Model          : $($Data.Model)
Asset          : $($Data.Asset)
Serial Number  : $($Data.'Serial Number')
UUID           : $($Data.UUID)
Date           : $($Data.Date)
"@

        # Write the formatted output to the specified file
        $formattedOutput | Out-File -FilePath $FilePath -Append

        # Optionally, confirm the file was written
        Write-Host "The information has been written to $FilePath"
    }

    # Define the primary and backup file paths
    $primaryPath = "C:\Users\David\Desktop\PowerShell Projects\PowerShell_Lab\ComputerInformationLogs"
    $backupPath = "C:\Users\David\Desktop\PowerShell Projects\PowerShell_Lab\BackupLogs"
    $fileName = "$serialNumber.txt"
    $filePath = Join-Path -Path $primaryPath -ChildPath $fileName
    $backupFilePath = Join-Path -Path $backupPath -ChildPath $fileName

    function bugCheckSection{
        # Check if the primary path is valid
    if (Test-Path -Path $primaryPath) {
        # Check if the file already exists
        if (Test-Path -Path $filePath) {
            Write-Host "File already exists. Updating the file."
        } else {
            Write-Host "File does not exist. Creating a new file."
        }
        # Call the StoreData function with the extracted data
        StoreData -FilePath $filePath -Data $computerInfo
    } else {
        Write-Host "Primary path is invalid. Checking backup path."
        # Check if the backup path is valid
        if (Test-Path -Path $backupPath) {
            Write-Host "Backup path is valid."
            # Check if the file already exists in the backup path
            if (Test-Path -Path $backupFilePath) {
                Write-Host "File already exists in backup path. Updating the file."
            } else {
                Write-Host "File does not exist in backup path. Creating a new file."
            }
            # Call the StoreData function with the extracted data
            StoreData -FilePath $backupFilePath -Data $computerInfo
        } else {
            Write-Host "Both primary and backup paths are invalid. Stopping the script."
            throw "Both primary and backup paths are invalid. Script execution stopped."
        }
    }
    }
    bugCheckSection
}

function mainRun{
    StartUpTitle
}
mainRun


# ################################## END ############################################