# Identify Unquoted Service Paths

# Define the output file path
$outputFilePath = "C:\Temp\UnquotedServicePaths.txt"

# Check if the Temp directory exists, if not, create it
if (-not (Test-Path -Path "C:\Temp")) {
    New-Item -ItemType Directory -Path "C:\Temp"
    Write-Host "Created directory C:\Temp"
}

# Run this part as Administrator
Write-Host "Finding Unquoted Service Paths..."
$unquotedServices = wmic service get name,displayname,pathname,startmode | 
                    findstr /i "auto" | 
                    findstr /i /v "c:\windows\\" | 
                    findstr /i /v '\"'

# Check if unquoted service paths were found
if (-not [string]::IsNullOrWhiteSpace($unquotedServices)) {
    Write-Host "Unquoted Service Paths Found: "
    Write-Host $unquotedServices

    # Save results to the specified file
    $unquotedServices | Out-File -FilePath $outputFilePath
    Write-Host "Results saved to $outputFilePath"
} else {
    Write-Host "No unquoted service paths found."
}
