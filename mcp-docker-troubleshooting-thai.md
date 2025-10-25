# 🔧 คู่มือแก้ปัญหา MCP Docker บน Windows (ภาษาไทย)

## 🚨 **ปัญหาฉุกเฉิน (แก้ใน 5 นาที)**

### 1. ตรวจสอบสถานะเริ่มต้น
```powershell
# ตรวจสอบว่า Docker ทำงานอยู่หรือไม่
docker --version
docker ps

# ตรวจสอบว่า Claude config มีอยู่หรือไม่
Get-ChildItem $env:USERPROFILE\.claude
```

### 2. รีสตาร์ท Services
```powershell
# รีสตาร์ท Docker Desktop
Stop-Process -Name "Docker Desktop" -Force
Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"

# รีสตาร์ท Claude ด้วย environment variables ถูกต้อง
$env:ANTHROPIC_API_KEY="your-api-key"
$env:ANTHROPIC_MODEL="glm-4.6"
claude --dangerously-skip-permissions chat
```

### 3. ตรวจสอบ MCP Config
```json
// ตรวจสอบไฟล์ %USERPROFILE%\.claude\claude_desktop_config.json
{
  "mcpServers": {
    "docker": {
      "command": "npx",
      "args": ["@mcp-docker/server"]
    }
  }
}
```

## 🛠️ **การแก้ปัญหาแบบละเอียด (15 นาที)**

### Phase 1: การตรวจสอบ Environment

#### 1.1 ตรวจสอบตัวแปรสภาพแวดล้อม
```powershell
# ตรวจสอบ ANTHROPIC_API_KEY
echo $env:ANTHROPIC_API_KEY

# ตรวจสอบ ANTHROPIC_MODEL
echo $env:ANTHROPIC_MODEL

# ตรวจสอบ PATH สำหรับ Docker
echo $env:PATH | findstr docker
```

#### 1.2 ตรวจสอบ Docker Installation
```powershell
# ตรวจสอบ Docker Desktop ทำงานหรือไม่
Get-Process "Docker Desktop" -ErrorAction SilentlyContinue

# ตรวจสอสอบ Docker daemon
docker info
docker version
```

### Phase 2: การตั้งค่า Configuration Files

#### 2.1 สร้าง Claude Config Directory
```powershell
# สร้าง directory ถ้ายังไม่มี
New-Item -ItemType Directory -Path "$env:USERPROFILE\.claude" -Force
New-Item -ItemType Directory -Path "$env:USERPROFILE\.claude\mcp-servers" -Force
```

#### 2.2 สร้าง Claude Desktop Config
```json
// ไฟล์: %USERPROFILE%\.claude\claude_desktop_config.json
{
  "mcpServers": {
    "docker": {
      "command": "npx",
      "args": ["@mcp-docker/server", "--docker-host", "npipe:////./pipe/docker_engine"],
      "env": {
        "DOCKER_HOST": "npipe:////./pipe/docker_engine"
      }
    },
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp@latest", "--config=./playwright-headful-config.json"]
    }
  }
}
```

#### 2.3 สร้าง Docker MCP Config
```json
// ไฟล์: %USERPROFILE%\.claude\mcp-servers\docker.json
{
  "name": "docker",
  "command": "npx",
  "args": ["@mcp-docker/server"],
  "env": {
    "DOCKER_HOST": "npipe:////./pipe/docker_engine"
  }
}
```

### Phase 3: Docker Service Management

#### 3.1 ตรวจสอบ Docker Services
```powershell
# ตรวจสอบ Docker service status
Get-Service -Name "com.docker.service" -ErrorAction SilentlyContinue

# ตรวจสอบ Docker daemon connectivity
docker version
docker run --rm hello-world
```

#### 3.2 แก้ไขปัญหา Docker Host
```powershell
# ตั้งค่า DOCKER_HOST สำหรับ Windows
$env:DOCKER_HOST = "npipe:////./pipe/docker_engine"

# ทดสอบการเชื่อมต่อ
docker ps
```

### Phase 4: MCP Server Management

#### 4.1 ติดตั้ง MCP Docker Server
```powershell
# ติดตั้ง MCP Docker server
npm install -g @mcp-docker/server

# ตรวจสอบการติดตั้ง
npx @mcp-docker/server --help
```

#### 4.2 ทดสอบ MCP Server Connection
```powershell
# ทดสอบ MCP server โดยตรง
npx @mcp-docker/server --verbose

# ตรวจสอบว่า MCP tools โหลดได้
# (จะแสดงใน Claude เมื่อเชื่อมต่อสำเร็จ)
```

## 🔍 **Diagnostic Commands ภาษาไทย**

### Checklist การตรวจสอบ:
```powershell
# 1. ตรวจสอบการติดตั้ง
Write-Host "=== ตรวจสอบการติดตั้ง ==="
docker --version
node --version
npm --version

# 2. ตรวจสอบ Services
Write-Host "=== ตรวจสอบ Services ==="
Get-Process "Docker Desktop" -ErrorAction SilentlyContinue
Get-Service -Name "com.docker.service" -ErrorAction SilentlyContinue

# 3. ตรวจสอบ Environment
Write-Host "=== ตรวจสอบ Environment ==="
echo "ANTHROPIC_API_KEY: ตั้งค่าแล้ว" if ($env:ANTHROPIC_API_KEY) else "ไม่ได้ตั้งค่า"
echo "DOCKER_HOST: $env:DOCKER_HOST"

# 4. ตรวจสอบ Config Files
Write-Host "=== ตรวจสอบ Config Files ==="
Test-Path "$env:USERPROFILE\.claude\claude_desktop_config.json"
Test-Path "$env:USERPROFILE\.claude\mcp-servers\docker.json"
```

## 🚨 **Common Error Messages และวิธีแก้ไข**

### Error: "MCP server not found"
**สาเหตุ**: MCP server ไม่ได้ติดตั้งหรือ path ไม่ถูกต้อง
**วิธีแก้**:
```powershell
npm install -g @mcp-docker/server
npm install -g @playwright/mcp@latest
```

### Error: "Docker daemon not running"
**สาเหตุ**: Docker Desktop ไม่ทำงาน
**วิธีแก้**:
```powershell
Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
```

### Error: "Permission denied"
**สาเหตุ**: ไม่มีสิทธิ์ในการเข้าถึง Docker
**วิธีแก้**:
- เรียกใช้ PowerShell ในฐานะ Administrator
- ตรวจสอบว่า user อยู่ใน docker-users group

### Error: "Connection refused"
**สาเหตุ**: DOCKER_HOST ไม่ถูกต้อง
**วิธีแก้**:
```powershell
$env:DOCKER_HOST = "npipe:////./pipe/docker_engine"
```

## 🔄 **Automated Setup Script**

### สร้างไฟล์ setup-mcp-docker.ps1
```powershell
# MCP Docker Setup Script for Windows
Write-Host "🚀 เริ่มการตั้งค่า MCP Docker บน Windows..."

# Step 1: สร้าง directories
New-Item -ItemType Directory -Path "$env:USERPROFILE\.claude" -Force
New-Item -ItemType Directory -Path "$env:USERPROFILE\.claude\mcp-servers" -Force

# Step 2: ติดตั้ง packages
npm install -g @mcp-docker/server
npm install -g @playwright/mcp@latest

# Step 3: สร้าง config files
$config = @"
{
  "mcpServers": {
    "docker": {
      "command": "npx",
      "args": ["@mcp-docker/server", "--docker-host", "npipe:////./pipe/docker_engine"],
      "env": {
        "DOCKER_HOST": "npipe:////./pipe/docker_engine"
      }
    }
  }
}
"@
$config | Out-File -FilePath "$env:USERPROFILE\.claude\claude_desktop_config.json" -Encoding UTF8

# Step 4: ตั้งค่า environment variables
$env:DOCKER_HOST = "npipe:////./pipe/docker_engine"
$env:ANTHROPIC_MODEL = "glm-4.6"

Write-Host "✅ การตั้งค่าเสร็จสมบูรณ์!"
Write-Host "🔄 กรุณารีสตาร์ท Claude และ Docker Desktop"
```

## 📋 **Final Verification Checklist**

### ก่อนใช้งาน:
- [ ] Docker Desktop ทำงานอยู่
- [ ] MCP Docker server ติดตั้งแล้ว
- [ ] Claude config files สร้างแล้ว
- [ ] Environment variables ตั้งค่าแล้ว
- [ ] PowerShell รันในฐานะ Administrator (ถ้าจำเป็น)

### หลังตั้งค่า:
- [ ] Claude เห็น MCP Docker tools
- [ ] สามารถใช้คำสั่ง docker ผ่าน Claude ได้
- [ ] ไม่มี error ในการเชื่อมต่อ
- [ ] Docker containers ทำงานได้ผ่าน MCP

## 🔗 **ทรัพยากรเพิ่มเติม**

- [MCP Docker Documentation](https://github.com/mcp-docker/mcp-docker)
- [Claude Desktop Setup](https://docs.anthropic.com/claude/docs/mcp)
- [Docker Desktop for Windows](https://docs.docker.com/desktop/windows/install/)

## 🆘 **การขอความช่วยเหลือ**

ถ้ายังแก้ปัญหาไม่ได้:
1. รวบรวม error messages ทั้งหมด
2. ตรวจสอบว่า Docker Desktop เวอร์ชันล่าสุด
3. ตรวจสอบว่า Claude Desktop เวอร์ชันล่าสุด
4. ลอง uninstall และ reinstall ทั้งสองโปรแกรม

---

**💡 เคล็ดลับ**: บันทึก script นี้ไว้เพื่อใช้ในกรณีฉุกเฉิน!