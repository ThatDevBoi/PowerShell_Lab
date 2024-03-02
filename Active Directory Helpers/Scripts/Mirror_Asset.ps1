# Get the names of the source and destination laptops from user input
$sourceLaptopName = Read-Host "Enter the name of the source laptop (e.g., L1234L)"
$destinationLaptopName = Read-Host "Enter the name of the destination laptop (e.g., L5678L)"

# Construct the full computer object names based on the laptop names
$sourceComputer = $sourceLaptopName + "$"
$destinationComputer = $destinationLaptopName + "$"

# Get the groups of the source computer
$sourceComputerGroups = Get-ADComputer -Identity $sourceComputer | Get-ADPrincipalGroupMembership

# Remove existing group memberships from the destination computer (optional)
#Get-ADComputer -Identity $destinationComputer | Get-ADPrincipalGroupMembership | ForEach-Object {
    #Remove-ADGroupMember -Identity $_ -Members $destinationComputer -Confirm:$false
#}

# Add the source computer's group memberships to the destination computer
foreach ($group in $sourceComputerGroups) {
    Add-ADGroupMember -Identity $group -Members $destinationComputer
}

Write-Host "Group memberships from $sourceComputer copied to $destinationComputer."