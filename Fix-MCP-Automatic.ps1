# MCP Auto-Fix Script
# สคริปต์สำหรับแก้ปัญหาการตั้งค่า MCP อัตโนมัติ

param(
    [switch]$Force,
    [switch]$Verbose
)

function Write-ColorText {
    param([string]$Text, [string]$Color = "White")
    Write-Host $Text -ForegroundColor $Color
}

function Test-AdminRights {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Set-EnvironmentVariables {
    Write-ColorText "=== ตั้งค่า Environment Variables ===" "Yellow"

    $envVars = @{
        "CLAUDE_CONFIG_DIR" = "$env:USERPROFILE\.claude-zz"
        "ANTHROPIC_BASE_URL" = "https://api.z.ai/api/anthropic"
        "ANTHROPIC_AUTH_TOKEN" = "YOUR_TOKEN_HERE"
        "ANTHROPIC_MODEL" = "glm-4.6"
    }

    foreach ($var in $envVars.GetEnumerator()) {
        try {
            [Environment]::SetEnvironmentVariable($var.Key, $var.Value, "User")
            $env:$($var.Key) = $var.Value
            Write-ColorText "✅ ตั้งค่า $($var.Key) = $($var.Value)" "Green"
        } catch {
            Write-ColorText "❌ ไม่สามารถตั้งค่า $($var.Key) ได้: $($_.Exception.Message)" "Red"
        }
    }
}

function Create-ConfigDirectory {
    Write-ColorText "=== สร้างโฟลเดอร์ Config ===" "Yellow"

    $configDir = "$env:USERPROFILE\.claude-zz"

    try {
        if (!(Test-Path $configDir)) {
            New-Item -ItemType Directory -Force -Path $configDir | Out-Null
            Write-ColorText "✅ สร้างโฟลเดอร์: $configDir" "Green"
        } else {
            Write-ColorText "ℹ️ โฟลเดอร์มีอยู่แล้ว: $configDir" "Cyan"
        }
    } catch {
        Write-ColorText "❌ ไม่สามารถสร้างโฟลเดอร์ได้: $($_.Exception.Message)" "Red"
        return $false
    }
    return $true
}

function Create-MCPConfigFile {
    Write-ColorText "=== สร้างไฟล์ Config ===" "Yellow"

    $configPath = "$env:USERPROFILE\.claude-zz\claude_desktop_config.json"

    try {
        # ตรวจสอบว่ามีไฟล์อยู่แล้วหรือไม่
        if ((Test-Path $configPath) -and !$Force) {
            Write-ColorText "⚠️ ไฟล์ config มีอยู่แล้ว ใช้ -Force เพื่อเขียนทับ" "Yellow"
            return $false
        }

        # สร้าง config พื้นฐาน
        $config = @{
            mcpServers = @{
                # เพิ่ม MCP servers ตัวอย่าง
                "filesystem" = @{
                    command = "npx"
                    args = @("-y", "@modelcontextprotocol/server-filesystem", "C:\Users\User\Documents")
                }
            }
        }

        # แปลงเป็น JSON และบันทึก
        $jsonContent = $config | ConvertTo-Json -Depth 10
        Set-Content -Path $configPath -Value $jsonContent -Encoding UTF8

        Write-ColorText "✅ สร้างไฟล์ config: $configPath" "Green"
        return $true

    } catch {
        Write-ColorText "❌ ไม่สามารถสร้างไฟล์ config ได้: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Install-MCPServers {
    Write-ColorText "=== ติดตั้ง MCP Servers ===" "Yellow"

    try {
        # ตรวจสอบ Node.js
        try {
            $nodeVersion = node --version 2>$null
            Write-ColorText "✅ Node.js: $nodeVersion" "Green"
        } catch {
            Write-ColorText "❌ ไม่พบ Node.js กรุณาติดตั้งจาก https://nodejs.org" "Red"
            return $false
        }

        # ติดตั้ง MCP servers
        $servers = @(
            "@modelcontextprotocol/server-filesystem",
            "@modelcontextprotocol/server-github",
            "@modelcontextprotocol/server-web-search"
        )

        foreach ($server in $servers) {
            Write-ColorText "กำลังติดตั้ง $server..." "Cyan"
            try {
                $result = npx -y $server --version 2>$null
                if ($LASTEXITCODE -eq 0) {
                    Write-ColorText "✅ ติดตั้ง $server สำเร็จ" "Green"
                }
            } catch {
                Write-ColorText "⚠️ ไม่สามารถติดตั้ง $server: $($_.Exception.Message)" "Yellow"
            }
        }

    } catch {
        Write-ColorText "❌ เกิดข้อผิดพลาดในการติดตั้ง MCP servers: $($_.Exception.Message)" "Red"
        return $false
    }
    return $true
}

function Test-MCPConfiguration {
    Write-ColorText "=== ทดสอบการตั้งค่า ===" "Yellow"

    $allGood = $true

    # ตรวจสอบ Environment Variables
    $envVars = @("CLAUDE_CONFIG_DIR", "ANTHROPIC_BASE_URL", "ANTHROPIC_AUTH_TOKEN", "ANTHROPIC_MODEL")

    foreach ($var in $envVars) {
        $value = [Environment]::GetEnvironmentVariable($var, "User")
        if ($value) {
            Write-ColorText "✅ $var = $value" "Green"
        } else {
            Write-ColorText "❌ $var = Not Set" "Red"
            $allGood = $false
        }
    }

    # ตรวจสอบไฟล์ Config
    $configPath = "$env:USERPROFILE\.claude-zz\claude_desktop_config.json"
    if (Test-Path $configPath) {
        Write-ColorText "✅ ไฟล์ config มีอยู่: $configPath" "Green"

        try {
            $config = Get-Content $configPath | ConvertFrom-Json
            if ($config.mcpServers) {
                $serverCount = $config.mcpServers.PSObject.Properties.Count
                Write-ColorText "✅ มี MCP servers: $serverCount ตัว" "Green"
            }
        } catch {
            Write-ColorText "❌ ไฟล์ config มีรูปแบบ JSON ไม่ถูกต้อง" "Red"
            $allGood = $false
        }
    } else {
        Write-ColorText "❌ ไม่พบไฟล์ config: $configPath" "Red"
        $allGood = $false
    }

    # ตรวจสอบเครื่องมือที่จำเป็น
    $tools = @("node", "npx")
    foreach ($tool in $tools) {
        try {
            $version = & $tool --version 2>$null
            Write-ColorText "✅ $tool : $version" "Green"
        } catch {
            Write-ColorText "❌ $tool : Not found" "Red"
            $allGood = $false
        }
    }

    return $allGood
}

# Main execution
Write-ColorText "🔧 MCP Auto-Fix Script" "Cyan"
Write-ColorText "====================" "Cyan"

# ตรวจสอบสิทธิ์ Admin
if (Test-AdminRights) {
    Write-ColorText "✅ กำลังทำงานด้วยสิทธิ์ Admin" "Green"
} else {
    Write-ColorText "⚠️ ไม่ได้ทำงานด้วยสิทธิ์ Admin" "Yellow"
}

# ดำเนินการแก้ปัญหา
try {
    Write-ColorText "`n🔄 เริ่มกระบวนการแก้ปัญหา..." "Cyan"

    Set-EnvironmentVariables

    if (Create-ConfigDirectory) {
        Create-MCPConfigFile
    }

    Install-MCPServers

    Write-ColorText "`n✅ ดำเนินการเสร็จสิ้น!" "Green"

    # ทดสอบการตั้งค่า
    $testResult = Test-MCPConfiguration

    Write-ColorText "`n📋 สรุปผลการทดสอบ:" "Yellow"
    if ($testResult) {
        Write-ColorText "✅ การตั้งค่า MCP ถูกต้องทั้งหมด!" "Green"
        Write-ColorText "`n🚀 ลองรันคำสั่งนี้เพื่อทดสอบ:" "Cyan"
        Write-ColorText "claude --dangerously-skip-permissions chat" "White"
    } else {
        Write-ColorText "❌ ยังมีปัญหาบางอย่าง กรุณาตรวจสอบข้างต้น" "Red"
    }

} catch {
    Write-ColorText "❌ เกิดข้อผิดพลาดร้ายแรง: $($_.Exception.Message)" "Red"
}

Write-ColorText "`n⚠️ หมายเหตุ: กรุณารีสตาร์ท PowerShell เพื่อให้ Environment Variables ถูกโหลดอย่างสมบูรณ์" "Yellow"