<#
    .SYNOPSIS
    SMT MODE : SYSTEM MAINTENANCE TOOL (GUI EDITION)
    Version: 5.0
    Author: WEDTOBER
    Theme: Cyberpunk
#>

# --- 1. Admin Check (Self-Elevation) ---
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# --- 2. Load Assembly ---
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- 3. UI Setup & Theme ---
$CyberBlack  = [System.Drawing.Color]::FromArgb(20, 20, 20)
$CyberDark   = [System.Drawing.Color]::FromArgb(45, 45, 45)
$CyberCyan   = [System.Drawing.Color]::FromArgb(0, 255, 240)
$CyberPink   = [System.Drawing.Color]::FromArgb(255, 0, 128)
$CyberGrey   = [System.Drawing.Color]::FromArgb(200, 200, 200)

$Form = New-Object System.Windows.Forms.Form
$Form.Text = "SMT MODE :: SYSTEM MAINTENANCE TOOL V5.0"
$Form.Size = New-Object System.Drawing.Size(900, 650)
$Form.StartPosition = "CenterScreen"
$Form.BackColor = $CyberBlack
$Form.FormBorderStyle = "FixedSingle"
$Form.MaximizeBox = $false

# --- Title Label ---
$Title = New-Object System.Windows.Forms.Label
$Title.Text = "S M T   M O D E   //   G U I   E D I T I O N"
$Title.Font = New-Object System.Drawing.Font("Consolas", 18, [System.Drawing.FontStyle]::Bold)
$Title.ForeColor = $CyberCyan
$Title.Location = New-Object System.Drawing.Point(20, 15)
$Title.AutoSize = $true
$Form.Controls.Add($Title)

$Credit = New-Object System.Windows.Forms.Label
$Credit.Text = "Dev by WEDTOBER"
$Credit.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$Credit.ForeColor = $CyberPink
$Credit.Location = New-Object System.Drawing.Point(20, 45)
$Credit.AutoSize = $true
$Form.Controls.Add($Credit)

# --- Log Box (Console Output) ---
$LogBox = New-Object System.Windows.Forms.TextBox
$LogBox.Multiline = $true
$LogBox.ReadOnly = $true
$LogBox.ScrollBars = "Vertical"
$LogBox.BackColor = $CyberDark
$LogBox.ForeColor = $CyberGrey
$LogBox.Font = New-Object System.Drawing.Font("Consolas", 9)
$LogBox.Location = New-Object System.Drawing.Point(20, 480)
$LogBox.Size = New-Object System.Drawing.Size(845, 120)
$Form.Controls.Add($LogBox)

function Log-Write($Text) {
    $Timestamp = Get-Date -Format "HH:mm:ss"
    $LogBox.AppendText("[$Timestamp] $Text`r`n")
    $LogBox.ScrollToCaret()
}

Log-Write "SYSTEM INITIALIZED..."
Log-Write "Welcome, $env:USERNAME"

# --- Tab Control ---
$TabControl = New-Object System.Windows.Forms.TabControl
$TabControl.Location = New-Object System.Drawing.Point(20, 80)
$TabControl.Size = New-Object System.Drawing.Size(845, 390)
$TabControl.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$Form.Controls.Add($TabControl)

# Helper function to create tabs
function New-Tab($Title) {
    $Page = New-Object System.Windows.Forms.TabPage
    $Page.Text = $Title
    $Page.BackColor = $CyberBlack
    $Page.ForeColor = $CyberCyan
    $TabControl.Controls.Add($Page)
    return $Page
}

# Helper function to create buttons
function New-CyberButton($Parent, $Text, $X, $Y, $Color, $Action) {
    $Btn = New-Object System.Windows.Forms.Button
    $Btn.Text = $Text
    $Btn.Location = New-Object System.Drawing.Point($X, $Y)
    $Btn.Size = New-Object System.Drawing.Size(250, 40)
    $Btn.FlatStyle = "Flat"
    $Btn.BackColor = $CyberDark
    $Btn.ForeColor = $Color
    $Btn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $Btn.Cursor = [System.Windows.Forms.Cursors]::Hand
    $Btn.Add_Click($Action)
    $Parent.Controls.Add($Btn)
}

# --- TAB 1: LOCAL CONFIG ---
$Tab1 = New-Tab "  [1] Local Config  "
New-CyberButton $Tab1 "Thai Init (Time/Lang/Font)" 20 30 $CyberCyan {
    Log-Write "Executing Thai Initialization..."
    Start-Process tzutil -ArgumentList "/s `""SE Asia Standard Time`""" -NoNewWindow -Wait
    Set-WinHomeLocation -GeoId 222
    $List = New-WinUserLanguageList en-US
    $List.Add('th-TH')
    Set-WinUserLanguageList $List -Force
    Set-Culture th-TH
    # Grave Key
    New-ItemProperty -Path "HKCU:\Keyboard Layout\Toggle" -Name "Hotkey" -Value "3" -PropertyType String -Force | Out-Null
    # Font Logic would go here (simplified for GUI speed)
    Log-Write "Timezone, Region, Grave Key Set."
    [System.Windows.Forms.MessageBox]::Show("Thai Init Complete. Please Restart for Grave Key.", "SMT Mode")
}

New-CyberButton $Tab1 "System Override (Performance)" 20 80 $CyberCyan {
    Log-Write "Applying Ultimate Performance..."
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
    powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
    Log-Write "Removing Bloatware..."
    Get-AppxPackage *BingWeather* | Remove-AppxPackage -ErrorAction SilentlyContinue
    Get-AppxPackage *Microsoft.People* | Remove-AppxPackage -ErrorAction SilentlyContinue
    Log-Write "System Optimized."
    [System.Windows.Forms.MessageBox]::Show("System Override Applied.", "SMT Mode")
}

New-CyberButton $Tab1 "Win11 Fix (Classic Context)" 20 130 $CyberCyan {
    Log-Write "Applying Windows 11 Fixes..."
    New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Force | Out-Null
    Set-ItemProperty -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Name "(Default)" -Value "" -Force | Out-Null
    Stop-Process -Name explorer -Force
    Log-Write "Explorer Restarted."
}

# --- TAB 2: SOFTWARE ---
$Tab2 = New-Tab "  [2] Software  "
New-CyberButton $Tab2 "Install ESSENTIALS" 20 30 $CyberPink {
    Log-Write "Installing Essentials via Winget..."
    Start-Process winget -ArgumentList "install -e --id Google.Chrome --accept-package-agreements --accept-source-agreements"
    Start-Process winget -ArgumentList "install -e --id 7zip.7zip --accept-package-agreements --accept-source-agreements"
}
New-CyberButton $Tab2 "Install OFFICE / WORK" 20 80 $CyberPink {
    Log-Write "Installing Work Apps..."
    Start-Process winget -ArgumentList "install -e --id LINE.LINE --accept-package-agreements --accept-source-agreements"
    Start-Process winget -ArgumentList "install -e --id Zoom.Zoom --accept-package-agreements --accept-source-agreements"
}
New-CyberButton $Tab2 "Install MEDIA / FUN" 20 130 $CyberPink {
    Log-Write "Installing Media Apps..."
    Start-Process winget -ArgumentList "install -e --id VideoLAN.VLC --accept-package-agreements --accept-source-agreements"
    Start-Process winget -ArgumentList "install -e --id Spotify.Spotify --accept-package-agreements --accept-source-agreements"
}

# --- TAB 3: DRIVERS ---
$Tab3 = New-Tab "  [3] Drivers  "
New-CyberButton $Tab3 "Snappy Driver Origin" 20 30 $CyberCyan {
    Start-Process winget -ArgumentList "install -e --id GlennDelahoy.SnappyDriverInstallerOrigin"
}
New-CyberButton $Tab3 "Intel DSA" 20 80 $CyberCyan {
    Start-Process winget -ArgumentList "install -e --id Intel.IntelDriverAndSupportAssistant"
}
New-CyberButton $Tab3 "Nvidia GeForce" 20 130 $CyberCyan {
    Start-Process winget -ArgumentList "install -e --id Nvidia.GeForceExperience"
}

# --- TAB 4: ADVANCED ---
$Tab4 = New-Tab "  [4] Advanced  "
New-CyberButton $Tab4 "WiFi Password Revealer" 20 30 $CyberPink {
    Log-Write "Dumping WiFi Profiles..."
    $Profiles = netsh wlan show profiles | Select-String "All User Profile"
    $Profiles -replace ".*: ","" | ForEach-Object {
        $name = $_
        $pass = netsh wlan show profile name="$name" key=clear | Select-String "Key Content"
        Log-Write "SSID: $name | $pass"
    }
}
New-CyberButton $Tab4 "Set DNS: Cloudflare" 20 80 $CyberPink {
    Start-Process netsh -ArgumentList "interface ip set dns name=`"Wi-Fi`" static 1.1.1.1" -NoNewWindow
    Log-Write "DNS set to 1.1.1.1"
}
New-CyberButton $Tab4 "Medic Station (SFC Scan)" 20 130 $CyberPink {
    Start-Process cmd -ArgumentList "/k sfc /scannow" -Verb RunAs
}

# --- TAB 5: CLOUD ---
$Tab5 = New-Tab "  [5] Cloud Uplink  "
New-CyberButton $Tab5 "Launch ChrisTitus WinUtil" 20 30 $CyberCyan {
    Log-Write "Launching WinUtil..."
    Start-Process powershell -ArgumentList "iwr -useb https://christitus.com/win | iex"
}
New-CyberButton $Tab5 "Launch MAS (Activation)" 20 80 $CyberCyan {
    Log-Write "Launching MAS..."
    Start-Process powershell -ArgumentList "irm https://massgrave.dev/get | iex"
}

# --- Show Form ---
$Form.ShowDialog() | Out-Null