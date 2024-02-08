# Remediate Unquoted Service Paths

# Define the path to the file containing unquoted service paths
$inputFilePath = "C:\Temp\UnquotedServicePaths.txt"

# Check if the input file exists
if (Test-Path -Path $inputFilePath) {
    Write-Host "Starting Remediation of Unquoted Service Paths..."

    # Read the file
    $unquotedServices = Get-Content -Path $inputFilePath

    foreach ($service in $unquotedServices) {
        # Extract the service name and current path
        # Update this logic as per the format in your actual file
        $serviceName, $servicePath = $service -split ' - ', 2

        # Enclose the path in quotes
        $quotedPath = "`"$servicePath`""

        # Update the registry (This is an example, modify as needed)
        Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Services\$serviceName" -Name "ImagePath" -Value $quotedPath
        Write-Host "Updated service $serviceName with path $quotedPath"
    }

    Write-Host "Remediation script execution completed."
} else {
    Write-Host "Input file not found at $inputFilePath. Please ensure the identification script has been run."
}
