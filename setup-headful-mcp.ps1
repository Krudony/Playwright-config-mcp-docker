# Setup MCP Playwright with Headful Mode (Visual Browser)
# วิธีใช้: .\setup-headful-mcp.ps1

Write-Host "🎭 MCP Playwright Headful Setup" -ForegroundColor Cyan
Write-Host "===============================" -ForegroundColor Cyan

# 1. สร้างโฟลเดอร์ config
$configDir = "$env:USERPROFILE\.claude"
if (!(Test-Path $configDir)) {
    New-Item -ItemType Directory -Force -Path $configDir | Out-Null
    Write-Host "✅ สร้างโฟลเดอร์: $configDir" -ForegroundColor Green
}

# 2. สร้างไฟล์ config สำหรับ headful mode
$configPath = "$configDir\claude_desktop_config.json"
$configContent = '{
  "mcpServers": {
    "playwright-visual": {
      "command": "docker",
      "args": [
        "run",
        "--rm",
        "-i",
        "--shm-size=2gb",
        "--cap-add=SYS_ADMIN",
        "--security-opt=seccomp=unconfined",
        "-e", "DISPLAY=host.docker.internal:0",
        "-v", "/tmp/.X11-unix:/tmp/.X11-unix",
        "mcp/playwright",
        "node",
        "cli.js",
        "--headful",
        "--no-sandbox"
      ]
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "C:\\Users\\User\\Documents"]
    }
  }
}'

Set-Content -Path $configPath -Value $configContent -Encoding UTF8
Write-Host "✅ สร้างไฟล์ config: $configPath" -ForegroundColor Green

# 3. ตั้งค่า Environment Variables
[Environment]::SetEnvironmentVariable("CLAUDE_CONFIG_DIR", $configDir, "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL", "https://api.z.ai/api/anthropic", "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_MODEL", "glm-4.6", "User")
Write-Host "✅ ตั้งค่า Environment Variables" -ForegroundColor Green

Write-Host ""
Write-Host "🎉 Setup สำเร็จ!" -ForegroundColor Green
Write-Host ""
Write-Host "📝 วิธีใช้งาน:" -ForegroundColor Cyan
Write-Host "1. รีสตาร์ท Claude Desktop" -ForegroundColor White
Write-Host "2. เปิด X Server (สำหรับ Windows: ใช้ VcXsrv หรือ Xming)" -ForegroundColor White
Write-Host "3. ตั้งค่า X Server ให้อนุญาต remote connections" -ForegroundColor White
Write-Host "4. สั่งใช้ MCP Playwright Tools ได้เลย!" -ForegroundColor White
Write-Host ""
Write-Host "🔧 สำหรับ Windows ต้องติดตั้ง:" -ForegroundColor Yellow
Write-Host "- X Server (VcXsrv หรือ Xming)" -ForegroundColor White
Write-Host "- ตั้งค่า ALLOW_REMOTE_CONNECTIONS=1" -ForegroundColor White
Write-Host "- เปิด port 6000 สำหรับ X11 forwarding" -ForegroundColor White
Write-Host ""
Write-Host "🚀 หลังจากติดตั้งเสร็จ จะเห็นหน้าต่าง browser จริง!" -ForegroundColor Green