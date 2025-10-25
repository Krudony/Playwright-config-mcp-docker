# คู่มือการแก้ปัญหาการตั้งค่า MCP (Model Context Protocol)

## ปัญหาที่พบ
ไม่สามารถใช้งาน MCP (Model Context Protocol) ได้ แม้จะตั้งค่า environment variables แล้วก็ตาม

## การวินิจฉัยปัญหา

### 1. ตรวจสอบสถานะปัจจุบัน
```powershell
# ตรวจสอบว่าตัวแปรสภาพแวดล้อมถูกตั้งค่าหรือไม่
echo $env:CLAUDE_CONFIG_DIR
echo $env:ANTHROPIC_BASE_URL
echo $env:ANTHROPIC_AUTH_TOKEN
echo $env:ANTHROPIC_MODEL
```

### 2. ปัญหาที่อาจเกิดขึ้นได้
- **ไม่มีไฟล์การตั้งค่า MCP**: ไม่พบไฟล์ `claude_desktop_config.json` ในโฟลเดอร์ที่ระบุ
- **โฟลเดอร์ config ไม่ถูกสร้าง**: โฟลเดอร์ `C:\Users\User\.claude-zz` อาจไม่มีอยู่จริง
- **การตั้งค่าไม่ถูกต้อง**: รูปแบบการตั้งค่าอาจไม่ถูกต้องตามรูปแบบของ MCP
- **Environment variables ไม่ถูกโหลด**: ตัวแปรสภาพแวดล้อมอาจไม่ถูกโหลดใน session ปัจจุบัน

## วิธีแก้ปัญหา

### ขั้นตอนที่ 1: สร้างโฟลเดอร์ Config
```powershell
# สร้างโฟลเดอร์สำหรับเก็บการตั้งค่า
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude-zz"
```

### ขั้นตอนที่ 2: สร้างไฟล์การตั้งค่า MCP
```powershell
# สร้างไฟล์ config สำหรับ Claude Desktop
$configPath = "$env:USERPROFILE\.claude-zz\claude_desktop_config.json"

# เนื้อหาไฟล์ config
$configContent = @{
    mcpServers = @{
        # เพิ่ม MCP servers ที่ต้องการใช้งานที่นี่
        # ตัวอย่าง:
        # "filesystem" = @{
        #     command = "npx"
        #     args = @("-y", "@modelcontextprotocol/server-filesystem", "C:\Users\User\Documents")
        # }
    }
} | ConvertTo-Json -Depth 10

# เขียนไฟล์ config
Set-Content -Path $configPath -Value $configContent -Encoding UTF8
```

### ขั้นตอนที่ 3: ตั้งค่า Environment Variables แบบถาวร
```powershell
# สำหรับ PowerShell (Current User)
[Environment]::SetEnvironmentVariable("CLAUDE_CONFIG_DIR", "$env:USERPROFILE\.claude-zz", "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL", "https://api.z.ai/api/anthropic", "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_AUTH_TOKEN", "YOUR_TOKEN_HERE", "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_MODEL", "glm-4.6", "User")

# หรือใช้คำสั่งนี้สำหรับ session ปัจจุบัน
$env:CLAUDE_CONFIG_DIR = "$env:USERPROFILE\.claude-zz"
$env:ANTHROPIC_BASE_URL = "https://api.z.ai/api/anthropic"
$env:ANTHROPIC_AUTH_TOKEN = "YOUR_TOKEN_HERE"
$env:ANTHROPIC_MODEL = "glm-4.6"
```

### ขั้นตอนที่ 4: รีสตาร์ท PowerShell/Command Prompt
```powershell
# ปิดและเปิด PowerShell ใหม่เพื่อโหลด environment variables ใหม่
```

### ขั้นตอนที่ 5: ตรวจสอบการตั้งค่า
```powershell
# ตรวจสอบว่า environment variables ถูกตั้งค่าอย่างถูกต้อง
Get-ChildItem Env: | Where-Object Name -like "*CLAUDE*" -or Name -like "*ANTHROPIC*"

# ตรวจสอบว่าไฟล์ config ถูกสร้างแล้ว
Test-Path "$env:USERPROFILE\.claude-zz\claude_desktop_config.json"

# ดูเนื้อหาในไฟล์ config
Get-Content "$env:USERPROFILE\.claude-zz\claude_desktop_config.json" | ConvertFrom-Json | ConvertTo-Json -Depth 10
```

### ขั้นตอนที่ 6: ทดสอบการใช้งาน Claude
```powershell
# ทดสอบการเรียกใช้งาน Claude
claude --dangerously-skip-permissions chat
```

## การตั้งค่า MCP Servers ตัวอย่าง

### ตัวอย่างที่ 1: Filesystem MCP Server
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "C:\\Users\\User\\Documents"
      ]
    }
  }
}
```

### ตัวอย่างที่ 2: GitHub MCP Server
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-github",
        "--github-personal-access-token",
        "YOUR_GITHUB_TOKEN"
      ]
    }
  }
}
```

### ตัวอย่างที่ 3: Web Search MCP Server
```json
{
  "mcpServers": {
    "web-search": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-web-search"
      ]
    }
  }
}
```

## การแก้ปัญหาเพิ่มเติม

### ปัญหา: Permission Denied
```powershell
# ตรวจสอบสิทธิ์ในการเข้าถึงโฟลเดอร์
icacls "$env:USERPROFILE\.claude-zz"

# ถ้าจำเป็นต้องให้สิทธิ์เต็ม
icacls "$env:USERPROFILE\.claude-zz" /grant "${env:USERNAME}:(OI)(CI)F" /T
```

### ปัญหา: Node.js/NPX ไม่พบ
```powershell
# ตรวจสอบว่า Node.js ถูกติดตั้งหรือไม่
node --version
npx --version

# ถ้าไม่มี Node.js ให้ดาวน์โหลดและติดตั้งจาก https://nodejs.org
```

### ปัญหา: MCP Server ไม่ทำงาน
```powershell
# ทดสอบ MCP server แต่ละตัวแยกกัน
npx -y @modelcontextprotocol/server-filesystem --help

# ดู log ของ Claude Desktop
# Windows: %APPDATA%\Claude\logs\
# macOS: ~/Library/Logs/Claude/
# Linux: ~/.config/claude/logs/
```

## การตรวจสอบสถานะสุดท้าย

### Script สำหรับตรวจสอบการตั้งค่า
```powershell
# สร้าง script ตรวจสอบสถานะ
function Test-MCPConfiguration {
    Write-Host "=== ตรวจสอบ Environment Variables ===" -ForegroundColor Yellow
    $envVars = @("CLAUDE_CONFIG_DIR", "ANTHROPIC_BASE_URL", "ANTHROPIC_AUTH_TOKEN", "ANTHROPIC_MODEL")

    foreach ($var in $envVars) {
        $value = [Environment]::GetEnvironmentVariable($var, "User")
        if ($value) {
            Write-Host "$var = $value" -ForegroundColor Green
        } else {
            Write-Host "$var = Not Set" -ForegroundColor Red
        }
    }

    Write-Host "`n=== ตรวจสอบไฟล์ Config ===" -ForegroundColor Yellow
    $configPath = "$env:USERPROFILE\.claude-zz\claude_desktop_config.json"

    if (Test-Path $configPath) {
        Write-Host "Config file exists: $configPath" -ForegroundColor Green
        try {
            $config = Get-Content $configPath | ConvertFrom-Json
            Write-Host "Config content is valid JSON" -ForegroundColor Green
            if ($config.mcpServers) {
                Write-Host "MCP servers configured: $($config.mcpServers.PSObject.Properties.Count)" -ForegroundColor Green
            }
        } catch {
            Write-Host "Config file contains invalid JSON" -ForegroundColor Red
        }
    } else {
        Write-Host "Config file not found: $configPath" -ForegroundColor Red
    }

    Write-Host "`n=== ตรวจสอบเครื่องมือที่จำเป็น ===" -ForegroundColor Yellow
    $tools = @("node", "npx", "claude")

    foreach ($tool in $tools) {
        try {
            $version = & $tool --version 2>$null
            Write-Host "$tool : $version" -ForegroundColor Green
        } catch {
            Write-Host "$tool : Not found" -ForegroundColor Red
        }
    }
}

# เรียกใช้ฟังก์ชัน
Test-MCPConfiguration
```

## บทสรุป

การตั้งค่า MCP ต้องการ:
1. **โฟลเดอร์ config ที่ถูกต้อง**: `$env:USERPROFILE\.claude-zz`
2. **ไฟล์ config ที่ถูกต้อง**: `claude_desktop_config.json`
3. **Environment variables ที่ถูกต้อง**: ทั้งสี่ตัวแปรต้องถูกตั้งค่า
4. **Node.js/NPX**: สำหรับรัน MCP servers
5. **MCP servers ที่ติดตั้ง**: เพื่อให้สามารถใช้งานได้จริง

ถ้าทำตามขั้นตอนทั้งหมดนี้แล้วยังไม่ได้ ให้ตรวจสอบ log ของ Claude Desktop หรือลองรีสตาร์ทเครื่องเพื่อให้แน่ใจว่า environment variables ถูกโหลดอย่างสมบูรณ์

---

**หมายเหตุ**: คู่มีนี้สร้างขึ้นเพื่อแก้ปัญหา MCP Configuration สำหรับระบบ Windows ด้วย PowerShell