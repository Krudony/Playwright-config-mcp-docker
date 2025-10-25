# MCP Playwright Simple Setup
# Simple script to setup MCP with Playwright

Write-Host "🎭 MCP Playwright Setup" -ForegroundColor Cyan
Write-Host "=====================" -ForegroundColor Cyan

# 1. Create config directory
$configDir = "$env:USERPROFILE\.claude-zz"
New-Item -ItemType Directory -Force -Path $configDir | Out-Null
Write-Host "✅ Created config directory: $configDir" -ForegroundColor Green

# 2. Create MCP config with Playwright
$configPath = "$configDir\claude_desktop_config.json"
$configContent = '{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-playwright"]
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "C:\\Users\\User\\Documents"]
    }
  }
}'

Set-Content -Path $configPath -Value $configContent -Encoding UTF8
Write-Host "✅ Created config file: $configPath" -ForegroundColor Green

# 3. Set environment variables
[Environment]::SetEnvironmentVariable("CLAUDE_CONFIG_DIR", $configDir, "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL", "https://api.z.ai/api/anthropic", "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_MODEL", "glm-4.6", "User")
Write-Host "✅ Set environment variables" -ForegroundColor Green

# 4. Test Playwright MCP server
Write-Host "`n🧪 Testing Playwright MCP server..." -ForegroundColor Yellow
try {
    $test = & npx -y @modelcontextprotocol/server-playwright --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Playwright MCP server works!" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Need to install Playwright MCP server" -ForegroundColor Yellow
    }
} catch {
    Write-Host "⚠️ Cannot test Playwright MCP server" -ForegroundColor Yellow
}

Write-Host "`n🎉 MCP Playwright setup complete!" -ForegroundColor Green
Write-Host "`n📝 How to use:" -ForegroundColor Cyan
Write-Host "1. Close and reopen PowerShell" -ForegroundColor White
Write-Host "2. Run: claude --dangerously-skip-permissions chat" -ForegroundColor White
Write-Host "3. Try browser automation commands like:" -ForegroundColor White
Write-Host "   - browser_navigate (to open a website)" -ForegroundColor White
Write-Host "   - browser_snapshot (to see the page)" -ForegroundColor White
Write-Host "   - browser_click (to click elements)" -ForegroundColor White
Write-Host "`n⚠️ Remember to restart PowerShell before using!" -ForegroundColor Yellow