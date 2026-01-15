# ⚡ SMT MODE :: SYSTEM MAINTENANCE TOOL (GUI EDITION)

![Version](https://img.shields.io/badge/Version-5.0-neon?style=for-the-badge&color=00fff0)
![Platform](https://img.shields.io/badge/Platform-Windows_10%2F11-blue?style=for-the-badge)
![PowerShell](https://img.shields.io/badge/Built_with-PowerShell-blue?style=for-the-badge&logo=powershell)

> **"High-performance system deployment tool."**

**SMT MODE (GUI)** คือเครื่องมือ System Administrator Utility แบบ All-in-One (Post-Install Tasks)

---

## 📸 Screenshots
![Alt text](https://private-user-images.githubusercontent.com/250131209/536175757-8c3e3aa4-1032-45b3-96b0-28528c264750.png?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3Njg0NzUwNjEsIm5iZiI6MTc2ODQ3NDc2MSwicGF0aCI6Ii8yNTAxMzEyMDkvNTM2MTc1NzU3LThjM2UzYWE0LTEwMzItNDViMy05NmIwLTI4NTI4YzI2NDc1MC5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjYwMTE1JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI2MDExNVQxMDU5MjFaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT00YjNmZGY0ZmJlMWY2NWEwMjY1YzYzMzY5YzI5MGE5ZjYwM2I0NmIxMjQzMDNiMjk3ZDU5ZTUwNWQ0YTEzMGY4JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.rc27rhmPCeLdypY-8bcs4D6fFL4M9tLFbq32xTxsYyo)


---

## 🚀 Features (ความสามารถหลัก)

โปรแกรมแบ่งการทำงานออกเป็น Tab เพื่อง่ายต่อการใช้งาน:

### 🔰 [1] Local Config
จัดการค่าพื้นฐานของเครื่องให้พร้อมใช้งานสำหรับผู้ใช้ในประเทศไทยและ Gamer
* **Thai Init:** ตั้งค่า Timezone (SE Asia), Region (Thailand), Add Layout TH/EN และตั้งค่าปุ่มเปลี่ยนภาษา (Grave Key/ตัวหนอน) อัตโนมัติ
* **System Override:** เปิดโหมด **Ultimate Performance**, ลบ Bloatware (BingWeather, People)
* **Win11 Fix:** คืนค่า Context Menu แบบ Classic (Right-click) ให้เหมือน Windows 10

### 📦 [2] Software Hub
ติดตั้งโปรแกรมสามัญประจำเครื่องผ่าน **Winget** (ไม่ต้องหาโหลดเอง)
* **Essentials:** Google Chrome, 7-Zip
* **Office / Work:** LINE PC, Zoom
* **Media / Fun:** VLC Media Player, Spotify

### 🔧 [3] Drivers Center
รวมศูนย์การอัปเดตไดรเวอร์
* **Snappy Driver Installer Origin**
* **Intel DSA**
* **Nvidia GeForce Experience**

### 🔐 [4] Advanced Tools
เครื่องมือสำหรับช่างเทคนิค
* **WiFi Revealer:** ดึงรหัสผ่าน WiFi ที่เคยเชื่อมต่อทั้งหมดในเครื่องออกมาแสดง
* **DNS Override:** ตั้งค่า DNS เป็น Cloudflare (1.1.1.1) เพื่อความเร็วและความเป็นส่วนตัว
* **Medic Station:** รันคำสั่งซ่อมไฟล์ระบบ (`sfc /scannow`)

### ☁️ [5] Cloud Uplink
เชื่อมต่อกับสคริปต์ยอดนิยมจากภายนอก
* **ChrisTitus Tech WinUtil:** เครื่องมือ Debloat ระดับเทพ
* **MAS (Microsoft Activation Scripts):** (For educational purposes)

---

## 🛠️ Requirements (สิ่งที่ต้องมี)

* **OS:** Windows 10 หรือ Windows 11
* **PowerShell:** v5.1 ขึ้นไป (ติดมากับเครื่องอยู่แล้ว)
* **Internet Connection:** จำเป็นสำหรับการโหลดโปรแกรมและไดรเวอร์
* **Admin Rights:** โปรแกรมจะขอสิทธิ์ Administrator โดยอัตโนมัติเมื่อเปิดใช้งาน

---

## 📥 How to Run (วิธีใช้งาน)

### Method 1: Download & Run
1. ดาวน์โหลดไฟล์ `SMT_GUI.ps1` หรือ Clone repository นี้
2. คลิกขวาที่ไฟล์ เลือก **"Run with PowerShell"**
3. หากมีหน้าต่างแจ้งเตือน Execution Policy ให้ตอบ **Yes** หรือ **Run once**

### Method 2: Command Line
เปิด PowerShell หรือ CMD Run as Administrator 
แล้วรันคำสั่ง: irm bit.ly/SMT_GUI | iex
