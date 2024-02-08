function Display-ToastNotification() {
    # Loading necessary Windows.UI.Notifications and Windows.Data.Xml.Dom assemblies
    $Load = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
    $Load = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]

    # Load the notification into the required format
    $ToastXML = New-Object -TypeName Windows.Data.Xml.Dom.XmlDocument
    $ToastXML.LoadXml($Toast.OuterXml)
    
    # Display the toast notification
    try {
        [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($App).Show($ToastXml)
    }
    catch { 
        # Display a warning if something goes wrong
        Write-Output -Message 'Something went wrong when displaying the toast notification' -Level Warn
        Write-Output -Message 'Make sure the script is running as the logged on user' -Level Warn     
    }
}

# Define URIs for images and save them to local files
$LogoImageUri = "https://www.COMPANY lOGO"
$HeroImageUri = "https://www.COMPANY.COM"
$LogoImage = "$env:TEMP\ToastLogoImage.png"
$HeroImage = "$env:TEMP\ToastHeroImage.png"
$Uptime= get-computerinfo | Select-Object OSUptime 

# Fetch images from URI
Invoke-WebRequest -Uri $LogoImageUri -OutFile $LogoImage
Invoke-WebRequest -Uri $HeroImageUri -OutFile $HeroImage

# Define Toast notification settings
$Scenario = 'reminder' # <!-- Possible values are: reminder | short | long -->
        
# Load Toast Notification text
$AttributionText = "COMPANY ICT Department"
$HeaderText = "Computer Restart is needed!"
$TitleText = "Your device has not performed a restart in the last $($Uptime.OsUptime.Days) days"
$BodyText1 = "For performance and stability reasons, we suggest switching off or restarting your device every night"
$BodyText2 = "Please save your work and restart your device today. Thank you in advance."
$BodyText3 = "If not restarted, your device will restart in 16 HOURS automatically, which may result in loss of unsaved work."

# Action to be performed on clicking the notification
$actionScriptCmdDelay = @'
PowerShell  -Command 
shutdown -r -t 14200
'@
$actionScriptCmdDelay

# Reboot device in 16 Hours
PowerShell -Command shutdown -r -t 28000

# Check and register AppID in the registry for use with the Action Center, if required
$RegPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings'
$App = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'

# Creating registry entries if they don't exist
if (-NOT(Test-Path -Path "$RegPath\$App")) {
    New-Item -Path "$RegPath\$App" -Force
    New-ItemProperty -Path "$RegPath\$App" -Name 'ShowInActionCenter' -Value 1 -PropertyType 'DWORD'
}

# Make sure the app used with the Action Center is enabled
if ((Get-ItemProperty -Path "$RegPath\$App" -Name 'ShowInActionCenter' -ErrorAction SilentlyContinue).ShowInActionCenter -ne '1') {
    New-ItemProperty -Path "$RegPath\$App" -Name 'ShowInActionCenter' -Value 1 -PropertyType 'DWORD' -Force
}

# Formatting the toast notification XML
[xml]$Toast = @"
<!-- Toast notification XML -->
<toast scenario="$Scenario">
    <visual>
        <binding template="ToastGeneric">
            <image placement="hero" src="$HeroImage"/>
            <image id="1" placement="appLogoOverride" hint-crop="circle" src="$LogoImage"/>
            <text placement="attribution">$AttributionText</text>
            <text>$HeaderText</text>
            <group>
                <subgroup>
                    <text hint-style="title" hint-wrap="true" >$TitleText</text>
                </subgroup>
            </group>
            <group>
                <subgroup>     
                    <text hint-style="body" hint-wrap="true" >$BodyText1</text>
                </subgroup>
            </group>
            <group>
                <subgroup>     
                    <text hint-style="body" hint-wrap="true" >$BodyText3</text>
                </subgroup>
            </group>
            <group>
                <subgroup>     
                    <text hint-style="body" hint-wrap="true" >$BodyText2</text>
                </subgroup>
            </group>
        </binding>
    </visual>
    <actions>
        <action activationType="system" arguments="dismiss" content="$DismissButtonContent"/>
    </actions>
</toast>
"@

# Send the notification
Display-ToastNotification
Exit 0
