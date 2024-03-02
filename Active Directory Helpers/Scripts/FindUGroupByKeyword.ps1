# Infinite loop to keep the console open until the user decides to quit
while ($true) {
    # Store Input for the keyword
    $keyword = Read-Host -Prompt 'Enter The Word For AD Group'

    # Filter groups containing the keyword in their names (case-insensitive and with wildcards)
    $ADSearch = Get-ADGroup -Filter * | Where-Object { $_.Name -like "*$keyword*" -or $_.Name -ilike "*$keyword*" }

    # Display search results
    if ($ADSearch.Count -gt 0) {
        Write-Host "Matching AD Groups:"
        $ADSearch | ForEach-Object { Write-Host $_.Name }
    } else {
        Write-Host "No matching AD Groups found."
    }

    # Ask user for option to start again or quit
    $choice = Read-Host -Prompt "Do you want to search again? (Y/N)"

    # Check user's choice
    if ($choice -ne 'Y' -and $choice -ne 'y') {
        # User chose to quit, exit the loop
        break
    }
}