# Script สำหรับตั้งค่า MCP กับ Playwright
# วิธีใช้: .\setup-playwright-mcp.ps1

function Write-ColorText {
    param([string]$Text, [string]$Color = "White")
    Write-Host $Text -ForegroundColor $Color
}

Write-ColorText "🎭 MCP Playwright Setup Script" "Cyan"
Write-ColorText "==============================" "Cyan"

# ตรวจสอบ Node.js
try {
    $nodeVersion = node --version 2>$null
    Write-ColorText "✅ Node.js: $nodeVersion" "Green"
} catch {
    Write-ColorText "❌ ไม่พบ Node.js กรุณาติดตั้งจาก https://nodejs.org" "Red"
    exit 1
}

# สร้างโฟลเดอร์ config
$configDir = "$env:USERPROFILE\.claude-zz"
if (!(Test-Path $configDir)) {
    New-Item -ItemType Directory -Force -Path $configDir | Out-Null
    Write-ColorText "✅ สร้างโฟลเดอร์: $configDir" "Green"
}

# สร้างไฟล์ config พร้อม Playwright
$configPath = "$configDir\claude_desktop_config.json"
$config = @{
    mcpServers = @{
        "playwright" = @{
            command = "npx"
            args = @("-y", "@modelcontextprotocol/server-playwright")
        }
        "filesystem" = @{
            command = "npx"
            args = @("-y", "@modelcontextprotocol/server-filesystem", "C:\Users\User\Documents")
        }
    }
}

$jsonContent = $config | ConvertTo-Json -Depth 10
Set-Content -Path $configPath -Value $jsonContent -Encoding UTF8

Write-ColorText "✅ สร้างไฟล์ config: $configPath" "Green"

# ตั้งค่า Environment Variables
$envVars = @{
    "CLAUDE_CONFIG_DIR" = $configDir
    "ANTHROPIC_BASE_URL" = "https://api.z.ai/api/anthropic"
    "ANTHROPIC_AUTH_TOKEN" = "YOUR_TOKEN_HERE"
    "ANTHROPIC_MODEL" = "glm-4.6"
}

foreach ($var in $envVars.GetEnumerator()) {
    [Environment]::SetEnvironmentVariable($var.Key, $var.Value, "User")
    Set-Item -Path "env:$($var.Key)" -Value $var.Value
    Write-ColorText "✅ ตั้งค่า $($var.Key)" "Green"
}

# ทดสอบ Playwright MCP server
Write-ColorText "`n🧪 ทดสอบ Playwright MCP server..." "Yellow"
try {
    $testResult = npx -y @modelcontextprotocol/server-playwright --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-ColorText "✅ Playwright MCP server ทำงานได้" "Green"
    } else {
        Write-ColorText "⚠️ ต้องติดตั้ง Playwright MCP server ก่อน" "Yellow"
        Write-ColorText "รัน: npx -y @modelcontextprotocol/server-playwright --help" "Cyan"
    }
} catch {
    Write-ColorText "⚠️ ไม่สามารถทดสอบ Playwright MCP server ได้" "Yellow"
}

Write-ColorText "`n🎉 ตั้งค่า MCP กับ Playwright เรียบร้อย!" "Green"
Write-ColorText "`n📝 วิธีใช้งาน:" "Cyan"
Write-ColorText "1. รีสตาร์ท PowerShell" "White"
Write-ColorText "2. รัน: claude --dangerously-skip-permissions chat" "White"
Write-ColorText "3. ใน chat ให้พิมพ์: /help เพื่อดูคำสั่งที่ใช้ได้" "White"
Write-ColorText "4. ลองใช้คำสั่ง browser automation เช่น:" "White"
Write-ColorText "   - mcp__MCP_DOCKER__browser_navigate" "White"
Write-ColorText "   - mcp__MCP_DOCKER__browser_snapshot" "White"
Write-ColorText "   - mcp__MCP_DOCKER__browser_click" "White"

Write-ColorText "`n⚠️ จำเป็นต้องรีสตาร์ท PowerShell ก่อนใช้งาน!" "Yellow"