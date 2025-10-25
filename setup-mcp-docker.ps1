# MCP Docker Setup Script for Windows (ภาษาไทย)
# Author: Claude Code Assistant
# Version: 1.0

param(
    [switch]$Force,
    [switch]$Verbose
)

Write-Host "🚀 เริ่มการตั้งค่า MCP Docker บน Windows..." -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Yellow

# Function สำหรับตรวจสอบว่า command ทำงานได้หรือไม่
function Test-Command {
    param($Command)
    try {
        $null = Get-Command $Command -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

# Function สำหรับแสดงสถานะ
function Write-Status {
    param($Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

# Step 1: ตรวจสอบ Requirements
Write-Status "`n=== Step 1: ตรวจสอบ Requirements ===" "Cyan"

$requirements = @(
    @{Name="Docker"; Command="docker"},
    @{Name="Node.js"; Command="node"},
    @{Name="NPM"; Command="npm"}
)

$allRequirementsMet = $true
foreach ($req in $requirements) {
    if (Test-Command $req.Command) {
        Write-Status "✅ $($req.Name) ติดตั้งแล้ว" "Green"
    } else {
        Write-Status "❌ $($req.Name) ไม่พบการติดตั้ง" "Red"
        $allRequirementsMet = $false
    }
}

if (-not $allRequirementsMet) {
    Write-Status "`n❌ กรุณาติดตั้ง requirements ทั้งหมดก่อนดำเนินการต่อ" "Red"
    Write-Status "Download: Docker Desktop และ Node.js" "Yellow"
    exit 1
}

# Step 2: สร้าง Directories
Write-Status "`n=== Step 2: สร้าง Directories ===" "Cyan"

$claudeDir = "$env:USERPROFILE\.claude"
$mcpServersDir = "$env:USERPROFILE\.claude\mcp-servers"

try {
    New-Item -ItemType Directory -Path $claudeDir -Force -ErrorAction Stop | Out-Null
    Write-Status "✅ สร้าง Claude directory: $claudeDir" "Green"

    New-Item -ItemType Directory -Path $mcpServersDir -Force -ErrorAction Stop | Out-Null
    Write-Status "✅ สร้าง MCP servers directory: $mcpServersDir" "Green"
} catch {
    Write-Status "❌ ไม่สามารถสร้าง directories: $_" "Red"
    exit 1
}

# Step 3: ติดตั้ง MCP Packages
Write-Status "`n=== Step 3: ติดตั้ง MCP Packages ===" "Cyan"

$packages = @(
    "@mcp-docker/server",
    "@playwright/mcp@latest"
)

foreach ($package in $packages) {
    Write-Status "กำลังติดตั้ง $package..." "Yellow"
    try {
        $installResult = npm install -g $package 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Status "✅ ติดตั้ง $package สำเร็จ" "Green"
        } else {
            Write-Status "❌ ติดตั้ง $package ล้มเหลว: $installResult" "Red"
            if (-not $Force) {
                exit 1
            }
        }
    } catch {
        Write-Status "❌ ติดตั้ง $package ล้มเหลว: $_" "Red"
        if (-not $Force) {
            exit 1
        }
    }
}

# Step 4: สร้าง Configuration Files
Write-Status "`n=== Step 4: สร้าง Configuration Files ===" "Cyan"

# Claude Desktop Config
$claudeConfig = @"
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
"@

$claudeConfigPath = "$claudeDir\claude_desktop_config.json"
try {
    $claudeConfig | Out-File -FilePath $claudeConfigPath -Encoding UTF8 -Force
    Write-Status "✅ สร้าง Claude config: $claudeConfigPath" "Green"
} catch {
    Write-Status "❌ ไม่สามารถสร้าง Claude config: $_" "Red"
    exit 1
}

# Docker MCP Config
$dockerMcpConfig = @"
{
  "name": "docker",
  "command": "npx",
  "args": ["@mcp-docker/server"],
  "env": {
    "DOCKER_HOST": "npipe:////./pipe/docker_engine"
  }
}
"@

$dockerMcpConfigPath = "$mcpServersDir\docker.json"
try {
    $dockerMcpConfig | Out-File -FilePath $dockerMcpConfigPath -Encoding UTF8 -Force
    Write-Status "✅ สร้าง Docker MCP config: $dockerMcpConfigPath" "Green"
} catch {
    Write-Status "❌ ไม่สามารถสร้าง Docker MCP config: $_" "Red"
    exit 1
}

# Step 5: ตั้งค่า Environment Variables
Write-Status "`n=== Step 5: ตั้งค่า Environment Variables ===" "Cyan"

# ตั้งค่าสำหรับ session ปัจจุบัน
$env:DOCKER_HOST = "npipe:////./pipe/docker_engine"
$env:ANTHROPIC_MODEL = "glm-4.6"

Write-Status "✅ ตั้งค่า DOCKER_HOST: $env:DOCKER_HOST" "Green"
Write-Status "✅ ตั้งค่า ANTHROPIC_MODEL: $env:ANTHROPIC_MODEL" "Green"

# สร้าง script สำหรับ set environment variables ถาวร
$envScript = @"
# MCP Docker Environment Variables
# เพิ่มลงใน PowerShell Profile เพื่อการตั้งค่าถาวร

# Docker Host for Windows
`$env:DOCKER_HOST = "npipe:////./pipe/docker_engine"

# Anthropic Model
`$env:ANTHROPIC_MODEL = "glm-4.6"

# เพิ่ม ANTHROPIC_API_KEY ถ้ายังไม่ได้ตั้งค่า
if (-not `$env:ANTHROPIC_API_KEY) {
    Write-Host "⚠️  กรุณาตั้งค่า ANTHROPIC_API_KEY" -ForegroundColor Yellow
    Write-Host "`$env:ANTHROPIC_API_KEY = 'your-api-key-here'" -ForegroundColor Gray
}
"@

$envScriptPath = "$claudeDir\set-environment.ps1"
try {
    $envScript | Out-File -FilePath $envScriptPath -Encoding UTF8 -Force
    Write-Status "✅ สร้าง environment script: $envScriptPath" "Green"
} catch {
    Write-Status "❌ ไม่สามารถสร้าง environment script: $_" "Red"
}

# Step 6: การตรวจสอบสุดท้าย
Write-Status "`n=== Step 6: การตรวจสอบสุดท้าย ===" "Cyan"

# ทดสอบ Docker connection
Write-Status "ทดสอบ Docker connection..." "Yellow"
try {
    $dockerTest = docker version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Status "✅ Docker connection สำเร็จ" "Green"
    } else {
        Write-Status "❌ Docker connection ล้มเหลว: $dockerTest" "Red"
    }
} catch {
    Write-Status "❌ Docker connection ล้มเหลว: $_" "Red"
}

# ทดสอบ MCP server
Write-Status "ทดสอบ MCP Docker server..." "Yellow"
try {
    $mcpTest = npx @mcp-docker/server --help 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Status "✅ MCP Docker server ทำงานได้" "Green"
    } else {
        Write-Status "❌ MCP Docker server ล้มเหลว: $mcpTest" "Red"
    }
} catch {
    Write-Status "❌ MCP Docker server ล้มเหลว: $_" "Red"
}

# Step 7: สรุปและขั้นตอนต่อไป
Write-Status "`n=== 🎉 การตั้งค่าเสร็จสมบูรณ์! ===" "Green"
Write-Status "`n📋 ขั้นตอนต่อไป:" "Yellow"
Write-Status "1. รีสตาร์ท Docker Desktop (ถ้าจำเป็น)" "White"
Write-Status "2. รีสตาร์ท Claude Desktop" "White"
Write-Status "3. เปิด Claude ด้วยคำสั่ง:" "White"
Write-Status "   `$env:ANTHROPIC_API_KEY='your-api-key'; `$env:ANTHROPIC_MODEL='glm-4.6'; claude --dangerously-skip-permissions chat" "Gray"
Write-Status "4. ตรวจสอบว่า Claude เห็น MCP Docker tools" "White"

Write-Status "`n📁 ไฟล์ที่สร้าง:" "Cyan"
Write-Status "- Claude Config: $claudeConfigPath" "Gray"
Write-Status "- Docker MCP Config: $dockerMcpConfigPath" "Gray"
Write-Status "- Environment Script: $envScriptPath" "Gray"

Write-Status "`n🔧 การตั้งค่า Environment ถาวร:" "Cyan"
Write-Status "รันคำสั่งต่อไปนี้ใน PowerShell (Administrator):" "Yellow"
Write-Status ". '$envScriptPath'" "Gray"

if ($Verbose) {
    Write-Status "`n📊 ข้อมูลเพิ่มเติม:" "Magenta"
    Write-Status "User Profile: $env:USERPROFILE" "Gray"
    Write-Status "Claude Directory: $claudeDir" "Gray"
    Write-Status "MCP Servers Directory: $mcpServersDir" "Gray"
    Write-Status "Docker Host: $env:DOCKER_HOST" "Gray"
    Write-Status "Anthropic Model: $env:ANTHROPIC_MODEL" "Gray"
}

Write-Status "`n✨ ขอให้ใช้งาน MCP Docker สนุก!" "Green"