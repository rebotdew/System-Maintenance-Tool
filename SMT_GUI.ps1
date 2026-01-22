<#
    .SYNOPSIS
    SMT MODE : TERMINAL EDITION
    Version: 7.0 (Universal Region + GitHub API Driver Engine)
    Theme: Minimal Green / Matrix Style
    Author: WEDTOBER
#>

# --- 1. Admin Check ---
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# --- 2. Load Assembly ---
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- 3. THEME SETTINGS ---
$ThemeBlack     = [System.Drawing.Color]::FromArgb(12, 12, 12)
$ThemeGreen     = [System.Drawing.Color]::FromArgb(0, 255, 65)
$ThemeDimGreen  = [System.Drawing.Color]::FromArgb(0, 50, 20)
$ThemeText      = [System.Drawing.Color]::FromArgb(0, 255, 65)

$GlobalFont     = New-Object System.Drawing.Font("Consolas", 10)
$HeaderFont     = New-Object System.Drawing.Font("Consolas", 16, [System.Drawing.FontStyle]::Bold)

# --- Main Form ---
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "SMT_MODE :: SYSTEM_MAINTENANCE_TERMINAL_"
$Form.Size = New-Object System.Drawing.Size(1000, 750)
$Form.StartPosition = "CenterScreen"
$Form.BackColor = $ThemeBlack
$Form.ForeColor = $ThemeText
$Form.FormBorderStyle = "FixedSingle"
$Form.MaximizeBox = $false

# --- HEADER SECTION ---
$HeaderPanel = New-Object System.Windows.Forms.Panel
$HeaderPanel.Size = New-Object System.Drawing.Size(1000, 90)
$HeaderPanel.Dock = "Top"
$HeaderPanel.BackColor = $ThemeBlack
$Form.Controls.Add($HeaderPanel)

$Title = New-Object System.Windows.Forms.Label
$Title.Text = "> SMT_MODE_EXEC"
$Title.Font = $HeaderFont
$Title.ForeColor = $ThemeGreen
$Title.Location = New-Object System.Drawing.Point(20, 15)
$Title.AutoSize = $true
$HeaderPanel.Controls.Add($Title)

# System Stats
function Get-SysInfo {
    $OS = (Get-CimInstance Win32_OperatingSystem).Caption
    $RAM = [Math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 0)
    return "USER: $env:USERNAME | OS: $OS | RAM: ${RAM}GB | HOST: $env:COMPUTERNAME"
}

$HudLabel = New-Object System.Windows.Forms.Label
$HudLabel.Text = "[LOADING SYSTEM STATS...]"
$HudLabel.Font = New-Object System.Drawing.Font("Consolas", 9)
$HudLabel.ForeColor = [System.Drawing.Color]::Gray
$HudLabel.Location = New-Object System.Drawing.Point(25, 50)
$HudLabel.AutoSize = $true
$HeaderPanel.Controls.Add($HudLabel)

$Form.Add_Shown({ $HudLabel.Text = "[ " + (Get-SysInfo) + " ]" })

# --- LOG BOX & PROGRESS ---
$LogBox = New-Object System.Windows.Forms.TextBox
$LogBox.Multiline = $true
$LogBox.ReadOnly = $true
$LogBox.ScrollBars = "Vertical"
$LogBox.BackColor = [System.Drawing.Color]::Black
$LogBox.ForeColor = $ThemeGreen
$LogBox.Font = New-Object System.Drawing.Font("Consolas", 9)
$LogBox.Location = New-Object System.Drawing.Point(20, 580)
$LogBox.Size = New-Object System.Drawing.Size(945, 110)
$LogBox.BorderStyle = "FixedSingle"
$Form.Controls.Add($LogBox)

$ProgressBar = New-Object System.Windows.Forms.ProgressBar
$ProgressBar.Location = New-Object System.Drawing.Point(20, 560)
$ProgressBar.Size = New-Object System.Drawing.Size(945, 10)
$Form.Controls.Add($ProgressBar)

function Log-Write($Text) {
    $Timestamp = Get-Date -Format "HH:mm:ss"
    $LogBox.AppendText("root@smt:~$ $Text`r`n")
    $LogBox.ScrollToCaret()
    [System.Windows.Forms.Application]::DoEvents()
}

Log-Write "Initializing Terminal Interface..."

# --- TAB CONTROL ---
$TabControl = New-Object System.Windows.Forms.TabControl
$TabControl.Location = New-Object System.Drawing.Point(20, 90)
$TabControl.Size = New-Object System.Drawing.Size(945, 460)
$TabControl.Font = $GlobalFont
$Form.Controls.Add($TabControl)

function New-Tab($Title) {
    $Page = New-Object System.Windows.Forms.TabPage
    $Page.Text = $Title
    $Page.BackColor = $ThemeBlack
    $Page.ForeColor = $ThemeGreen
    $TabControl.Controls.Add($Page)
    return $Page
}

# --- UI COMPONENTS ---
$SoftwareList = @()
function New-TerminalCheckbox($Parent, $Label, $CommandId, $X, $Y) {
    $Cb = New-Object System.Windows.Forms.CheckBox
    $Cb.Text = "[ ] $Label"
    $Cb.Location = New-Object System.Drawing.Point($X, $Y)
    $Cb.Size = New-Object System.Drawing.Size(220, 25)
    $Cb.ForeColor = $ThemeGreen
    $Cb.Font = $GlobalFont
    $Cb.Tag = $CommandId
    $Cb.FlatStyle = "Flat"
    $Cb.FlatAppearance.BorderColor = $ThemeGreen
    $Cb.FlatAppearance.CheckedBackColor = $ThemeGreen
    $Cb.Add_CheckedChanged({
        if ($this.Checked) { $this.Text = "[X] $Label"; $this.ForeColor = [System.Drawing.Color]::White }
        else { $this.Text = "[ ] $Label"; $this.ForeColor = $ThemeGreen }
    })
    $Parent.Controls.Add($Cb)
    global:$SoftwareList += $Cb
}

function New-TerminalButton($Parent, $Text, $X, $Y, $Width, $Action) {
    $Btn = New-Object System.Windows.Forms.Button
    $Btn.Text = "> $Text"
    $Btn.Location = New-Object System.Drawing.Point($X, $Y)
    $Btn.Size = New-Object System.Drawing.Size($Width, 40)
    $Btn.FlatStyle = "Flat"
    $Btn.BackColor = $ThemeBlack
    $Btn.ForeColor = $ThemeGreen
    $Btn.Font = $GlobalFont
    $Btn.FlatAppearance.BorderColor = $ThemeGreen
    $Btn.FlatAppearance.BorderSize = 1
    $Btn.Cursor = "Hand"
    $Btn.Add_Click($Action)
    $Btn.Add_MouseEnter({ $this.BackColor = $ThemeDimGreen; $this.ForeColor = [System.Drawing.Color]::White })
    $Btn.Add_MouseLeave({ $this.BackColor = $ThemeBlack; $this.ForeColor = $ThemeGreen })
    $Parent.Controls.Add($Btn)
}

function New-SectionLabel($Parent, $Text, $X, $Y) {
    $Lbl = New-Object System.Windows.Forms.Label
    $Lbl.Text = ":: $Text ::"
    $Lbl.ForeColor = [System.Drawing.Color]::Gray
    $Lbl.Location = New-Object System.Drawing.Point($X, $Y)
    $Lbl.AutoSize = $true
    $Lbl.Font = New-Object System.Drawing.Font("Consolas", 10, [System.Drawing.FontStyle]::Bold)
    $Parent.Controls.Add($Lbl)
}

# ==========================================
# [TAB 1] GLOBAL CONFIG (UNIVERSAL)
# ==========================================
$Tab1 = New-Tab " // 1_GLOBAL_CONFIG "

New-SectionLabel $Tab1 "UNIVERSAL REGION SELECTOR" 30 30

# --- 1. Dropdown: Region ---
$ComboRegion = New-Object System.Windows.Forms.ComboBox
$ComboRegion.Location = New-Object System.Drawing.Point(30, 60)
$ComboRegion.Size = New-Object System.Drawing.Size(420, 30)
$ComboRegion.Font = $GlobalFont
$ComboRegion.BackColor = $ThemeBlack
$ComboRegion.ForeColor = $ThemeGreen
$ComboRegion.FlatStyle = "Flat"
$ComboRegion.DropDownStyle = "DropDownList"

$AllCultures = [System.Globalization.CultureInfo]::GetCultures('SpecificCultures') | Sort-Object EnglishName
$CultureMap = @{}

foreach ($C in $AllCultures) {
    $DisplayName = "$($C.EnglishName) [$($C.Name)]"
    $ComboRegion.Items.Add($DisplayName) | Out-Null
    $CultureMap[$DisplayName] = $C
}
$ComboRegion.SelectedIndex = 0

$Tab1.Controls.Add($ComboRegion)

# --- 2. Dropdown: Timezone ---
New-SectionLabel $Tab1 "TIMEZONE SELECTION" 30 100

$ComboTimezone = New-Object System.Windows.Forms.ComboBox
$ComboTimezone.Location = New-Object System.Drawing.Point(30, 130)
$ComboTimezone.Size = New-Object System.Drawing.Size(420, 30)
$ComboTimezone.Font = $GlobalFont
$ComboTimezone.BackColor = $ThemeBlack
$ComboTimezone.ForeColor = $ThemeGreen
$ComboTimezone.FlatStyle = "Flat"
$ComboTimezone.DropDownStyle = "DropDownList"

$AllTimezones = [System.TimeZoneInfo]::GetSystemTimeZones()
foreach ($T in $AllTimezones) {
    $ComboTimezone.Items.Add($T.Id) | Out-Null
}
$CurrentTZ = [System.TimeZoneInfo]::Local.Id
if ($ComboTimezone.Items.Contains($CurrentTZ)) {
    $ComboTimezone.SelectedItem = $CurrentTZ
}

$Tab1.Controls.Add($ComboTimezone)

# --- 3. Execute Button ---
New-TerminalButton $Tab1 "APPLY GLOBAL SETTINGS" 470 58 350 {
    $SelectedRegionName = $ComboRegion.SelectedItem
    $SelectedTimezone = $ComboTimezone.SelectedItem
    
    if (-not $SelectedRegionName -or -not $SelectedTimezone) { return }

    $CultureObj = $CultureMap[$SelectedRegionName]
    $GeoId = $CultureObj.GeoId
    $CultureCode = $CultureObj.Name

    Log-Write "Applying Settings for: [$SelectedRegionName]..."

    Log-Write " > Setting Timezone: [$SelectedTimezone]"
    Start-Process tzutil -ArgumentList "/s `"$SelectedTimezone`"" -NoNewWindow -Wait

    Log-Write " > Setting Location ID: $GeoId"
    Set-WinHomeLocation -GeoId $GeoId

    Log-Write " > Setting Format: $CultureCode"
    $CurrentList = Get-WinUserLanguageList
    if (-not ($CurrentList.LanguageTag -contains $CultureCode)) {
        Log-Write "   (Installing language pack requirement...)"
        $CurrentList.Add($CultureCode)
        Set-WinUserLanguageList $CurrentList -Force
    }
    Set-Culture $CultureCode

    if ($CultureCode -eq "th-TH") {
        Log-Write " > Detected Thai Region: Applying Grave Key (~)..."
        New-ItemProperty -Path "HKCU:\Keyboard Layout\Toggle" -Name "Hotkey" -Value "3" -PropertyType String -Force | Out-Null
    }

    Log-Write "Global Configuration Complete."
    [System.Windows.Forms.MessageBox]::Show("Settings Applied.`nPlease Restart PC.", "TERMINAL")
}

New-SectionLabel $Tab1 "SYSTEM OVERRIDES" 30 190

New-TerminalButton $Tab1 "ACTIVATE: ULTIMATE PERFORMANCE" 30 220 400 {
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
    powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
    Log-Write "Power Scheme Updated."
}

New-TerminalButton $Tab1 "FIX: WIN11 CONTEXT MENU" 30 270 400 {
    New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Force | Out-Null
    Set-ItemProperty -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Name "(Default)" -Value "" -Force | Out-Null
    Stop-Process -Name explorer -Force
    Log-Write "Classic Menu Restored."
}

# ==========================================
# [TAB 2] SOFTWARE & DRIVERS
# ==========================================
$Tab2 = New-Tab " // 2_INSTALL_HUB "

# Column 1
New-SectionLabel $Tab2 "ESSENTIALS" 30 30
New-TerminalCheckbox $Tab2 "Google Chrome" "winget install -e --id Google.Chrome" 30 60
New-TerminalCheckbox $Tab2 "7-Zip Archiver" "winget install -e --id 7zip.7zip" 30 90
New-TerminalCheckbox $Tab2 "AnyDesk Remote" "winget install -e --id AnyDeskSoftwareSE.AnyDesk" 30 120
New-TerminalCheckbox $Tab2 "VLC Media Player" "winget install -e --id VideoLAN.VLC" 30 150
New-TerminalCheckbox $Tab2 "Spotify Music" "winget install -e --id Spotify.Spotify" 30 180

# Column 2
New-SectionLabel $Tab2 "OFFICE / WORK" 320 30
New-TerminalCheckbox $Tab2 "LINE PC" "winget install -e --id LINE.LINE" 320 60
New-TerminalCheckbox $Tab2 "Zoom Meeting" "winget install -e --id Zoom.Zoom" 320 90
New-TerminalCheckbox $Tab2 "Adobe Reader" "winget install -e --id Adobe.Acrobat.Reader.64-bit" 320 120
New-TerminalCheckbox $Tab2 "Microsoft Teams" "winget install -e --id Microsoft.Teams" 320 150
New-TerminalCheckbox $Tab2 "Discord" "winget install -e --id Discord.Discord" 320 180

# Column 3
New-SectionLabel $Tab2 "DRIVERS / RUNTIMES" 610 30
New-TerminalCheckbox $Tab2 "Snappy Driver" "winget install -e --id GlennDelahoy.SnappyDriverInstallerOrigin" 610 60
New-TerminalCheckbox $Tab2 "Nvidia GeForce" "winget install -e --id Nvidia.GeForceExperience" 610 90
New-TerminalCheckbox $Tab2 "Intel DSA" "winget install -e --id Intel.IntelDriverAndSupportAssistant" 610 120
New-TerminalCheckbox $Tab2 "DirectX Runtime" "winget install -e --id Microsoft.DirectX" 610 150
# แก้ไข ID ของ Visual C++ ให้ถูกต้อง
New-TerminalCheckbox $Tab2 "Visual C++ AIO" "winget install -e --id Abbodi.VCRedist" 610 180

# EXECUTE BUTTON
$BtnInstall = New-Object System.Windows.Forms.Button
$BtnInstall.Text = ">> EXECUTE_SELECTED_INSTALL << "
$BtnInstall.Font = New-Object System.Drawing.Font("Consolas", 12, [System.Drawing.FontStyle]::Bold)
$BtnInstall.BackColor = $ThemeBlack
$BtnInstall.ForeColor = $ThemeGreen
$BtnInstall.FlatStyle = "Flat"
$BtnInstall.FlatAppearance.BorderColor = $ThemeGreen
$BtnInstall.FlatAppearance.BorderSize = 1
$BtnInstall.Location = New-Object System.Drawing.Point(30, 360)
$BtnInstall.Size = New-Object System.Drawing.Size(870, 50)
$BtnInstall.Cursor = "Hand"
$Tab2.Controls.Add($BtnInstall)

$BtnInstall.Add_Click({
    $SelectedCount = ($SoftwareList | Where-Object {$_.Checked}).Count
    if ($SelectedCount -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("NO SELECTION DETECTED.", "ERROR")
        return
    }

    $ProgressBar.Value = 0
    $ProgressStep = 100 / $SelectedCount
    Log-Write "Batch sequence initiated..."
    
    foreach ($Item in $SoftwareList) {
        if ($Item.Checked) {
            $Cmd = $Item.Tag
            Log-Write "Deploying: $($Item.Text -replace '\[X\] ','')..."
            $FullCmd = "$Cmd --accept-package-agreements --accept-source-agreements"
            Invoke-Expression $FullCmd | Out-Null
            $ProgressBar.Value += $ProgressStep
        }
    }
    $ProgressBar.Value = 100
    Log-Write "Sequence completed."
    [System.Windows.Forms.MessageBox]::Show("Operation Successful.", "TERMINAL")
})

# ==========================================
# [TAB 3] DRIVER OPERATIONS
# ==========================================
$Tab3 = New-Tab " // 3_DRIVER_OPS "

New-SectionLabel $Tab3 "HARDWARE DIAGNOSTICS" 30 30

# --- 1. Hardware Scanner ---
New-TerminalButton $Tab3 "SCAN: MISSING / ERROR DRIVERS" 30 60 450 {
    Log-Write "Initializing Hardware Scan..."
    $ErrorDevices = Get-CimInstance Win32_PnPEntity | Where-Object { $_.ConfigManagerErrorCode -ne 0 }
    
    if ($ErrorDevices) {
        Log-Write "Warning: Found devices with driver issues!"
        foreach ($Dev in $ErrorDevices) {
            Log-Write " [!] MISSING: $($Dev.Name)"
            Log-Write "     ID: $($Dev.DeviceID)"
        }
        [System.Windows.Forms.MessageBox]::Show("Found $($ErrorDevices.Count) missing drivers!`nPlease use the 'AUTO INSTALL' button below.", "DIAGNOSTIC")
    } else {
        Log-Write "Diagnostic Result: ALL SYSTEMS GREEN."
        Log-Write "No missing drivers detected."
        [System.Windows.Forms.MessageBox]::Show("Your system drivers look healthy!", "DIAGNOSTIC")
    }
}

New-SectionLabel $Tab3 "DRIVER AUTO-INSTALLER (CLEAN)" 30 120

# --- 2. SDIO Integration (Robust Web Scrape V2) ---
New-TerminalButton $Tab3 "ENGINE: SNAPPY DRIVER (SDIO)" 30 150 450 {
    $SDIO_Path = "$env:SystemDrive\SMT_Tools\SDIO"
    
    # 1. เช็คของเดิม (ถ้ามี EXE อยู่แล้ว ให้เปิดเลย ไม่ต้องโหลดใหม่)
    $ExistingExe = Get-ChildItem "$SDIO_Path\SDIO_x64_*.exe" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($ExistingExe) {
        Log-Write "Found existing SDIO. Launching..."
        Start-Process $ExistingExe.FullName
        return
    }

    Log-Write "Initiating Driver Engine (SDIO)..."
    Log-Write " > Connecting to Official Site..."

    try {
        # บังคับใช้ TLS 1.2 เพื่อความเสถียร
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        
        # 2. เข้าไปอ่านหน้าเว็บหลัก
        $BaseUrl = "https://www.glenn.delahoy.com"
        $PageUrl = "$BaseUrl/snappy-driver-installer-origin/"
        
        # Timeout 15 วิ กันค้าง
        $Web = Invoke-WebRequest -Uri $PageUrl -UseBasicParsing -TimeoutSec 15
        
        # 3. ค้นหาลิงก์ไฟล์ .zip
        # หาลิงก์ที่มีคำว่า 'downloads/sdio/SDIO_' และลงท้ายด้วย '.zip'
        $TargetLink = $Web.Links | Where-Object { $_.href -match "downloads/sdio/SDIO_.*\.zip$" } | Select-Object -First 1 -ExpandProperty href
        
        if (-not $TargetLink) { throw "Download link not found on the website." }

        # 4. === URI FIXER (จุดสำคัญที่แก้บั๊ก) ===
        # ถ้าลิงก์ที่ได้มา เป็นแบบย่อ (ขึ้นต้นด้วย /) ให้เอาชื่อเว็บมาต่อ
        if ($TargetLink.StartsWith("/")) {
            $DownloadUrl = "$BaseUrl$TargetLink"
        } else {
            $DownloadUrl = $TargetLink
        }

        # ดึงชื่อไฟล์ออกมาจากลิงก์
        $FileName = $DownloadUrl.Split('/')[-1]
        Log-Write " > Found Version: $FileName"
        Log-Write " > Downloading..."

        # 5. เริ่มดาวน์โหลด
        if (!(Test-Path $SDIO_Path)) { New-Item -ItemType Directory -Force -Path $SDIO_Path | Out-Null }
        $ZipPath = "$SDIO_Path\$FileName"
        
        Invoke-WebRequest -Uri $DownloadUrl -OutFile $ZipPath -UseBasicParsing

        # 6. แตกไฟล์
        Log-Write " > Extracting..."
        Expand-Archive -Path $ZipPath -DestinationPath $SDIO_Path -Force
        Remove-Item $ZipPath -Force

        # 7. หาไฟล์ EXE แล้วรัน
        $Launcher = Get-ChildItem "$SDIO_Path\SDIO_x64_*.exe" | Select-Object -First 1
        if ($Launcher) {
            Log-Write " > Launching Driver Engine..."
            Start-Process $Launcher.FullName
        } else {
            Log-Write "Error: Executable not found inside ZIP."
        }
    }
    catch {
        Log-Write "Error: $($_.Exception.Message)"
        
        # Fallback สุดท้าย: ถ้าสคริปต์พังจริงๆ ให้ User กดไปโหลดเอง
        $MsgResult = [System.Windows.Forms.MessageBox]::Show("Auto-download failed.`n`nError: $($_.Exception.Message)`n`nDo you want to open the download page manually?", "DOWNLOAD ERROR", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Error)
        
        if ($MsgResult -eq "Yes") {
            Start-Process "https://www.glenn.delahoy.com/snappy-driver-installer-origin/"
        }
    }
}
# --- 3. Windows Update Force ---
New-TerminalButton $Tab3 "FORCE: WINDOWS UPDATE DRIVERS" 30 200 450 {
    Log-Write "Triggering Windows Update Service..."
    Start-Process "usoclient" -ArgumentList "StartScan" -NoNewWindow
    Log-Write "Scan signal sent. Please check Windows Update Settings."
    Start-Process "ms-settings:windowsupdate"
}

New-SectionLabel $Tab3 "GPU SPECIFIC" 30 260

# --- 4. NVCleanInstall ---
New-TerminalButton $Tab3 "NVIDIA: CLEAN INSTALLER" 30 290 450 {
    Log-Write "Fetching NVCleanInstall..."
    $Cmd = "winget install -e --id TechPowerUp.NVCleanstall --accept-package-agreements --accept-source-agreements"
    Invoke-Expression $Cmd | Out-Null
    Log-Write "Ready. Please run NVCleanInstall from Start Menu."
    Start-Process "NVCleanstall.exe" -ErrorAction SilentlyContinue
}

# ==========================================
# [TAB 4] CLOUD UPLINK
# ==========================================
$Tab4 = New-Tab " // 4_CLOUD_UPLINK "
New-SectionLabel $Tab4 "EXTERNAL RESOURCES" 30 30

New-TerminalButton $Tab4 "CONNECT: ChrisTitus Tech WinUtil" 30 60 500 {
    Log-Write "Establishing connection..."
    Start-Process powershell -ArgumentList "iwr -useb https://christitus.com/win | iex"
}
New-TerminalButton $Tab4 "CONNECT: MAS (Activation Scripts)" 30 110 500 {
    Log-Write "Accessing Massgrave..."
    Start-Process powershell -ArgumentList "irm https://massgrave.dev/get | iex"
}

# --- Show Form ---
$Form.ShowDialog() | Out-Null
