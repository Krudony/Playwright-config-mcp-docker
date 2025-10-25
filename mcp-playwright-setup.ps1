# MCP Playwright Setup Script
# Simple setup for MCP with Playwright

Write-Host "🎭 MCP Playwright Setup" -ForegroundColor Cyan
Write-Host "=====================" -ForegroundColor Cyan

# 1. Create config directory
$configDir = "$env:USERPROFILE\.claude-zz"
New-Item -ItemType Directory -Force -Path $configDir | Out-Null
Write-Host "✅ Created config directory: $configDir" -ForegroundColor Green

# 2. Create MCP config with Playwright
$configPath = "$configDir\claude_desktop_config.json"
$configContent = @"
{
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
}
"@

Set-Content -Path $configPath -Value $configContent -Encoding UTF8
Write-Host "✅ Created config file: $configPath" -ForegroundColor Green

# 3. Set environment variables
[Environment]::SetEnvironmentVariable("CLAUDE_CONFIG_DIR", $configDir, "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL", "https://api.z.ai/api/anthropic", "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_MODEL", "glm-4.6", "User")
Write-Host "✅ Set environment variables" -ForegroundColor Green

Write-Host ""
Write-Host "🎉 MCP Playwright setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📝 How to use:" -ForegroundColor Cyan
Write-Host "1. Close and reopen PowerShell" -ForegroundColor White
Write-Host "2. Run: claude --dangerously-skip-permissions chat" -ForegroundColor White
Write-Host "3. Try browser automation commands" -ForegroundColor White
Write-Host ""
Write-Host "⚠️ Remember to restart PowerShell before using!" -ForegroundColor Yellow