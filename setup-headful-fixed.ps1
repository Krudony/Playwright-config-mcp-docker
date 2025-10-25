# MCP Playwright Headful Setup - Fixed Version
Write-Host "🎭 MCP Playwright Headful Setup" -ForegroundColor Cyan
Write-Host "===============================" -ForegroundColor Cyan

# Create config directory
$configDir = "$env:USERPROFILE\.claude"
New-Item -ItemType Directory -Force -Path $configDir | Out-Null
Write-Host "✅ Created config directory: $configDir" -ForegroundColor Green

# Create headful config
$configPath = "$configDir\claude_desktop_config.json"
$configContent = @"
{
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
    }
  }
}
"@

Set-Content -Path $configPath -Value $configContent -Encoding UTF8
Write-Host "✅ Created headful config: $configPath" -ForegroundColor Green

# Set environment variables
[Environment]::SetEnvironmentVariable("CLAUDE_CONFIG_DIR", $configDir, "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL", "https://api.z.ai/api/anthropic", "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_MODEL", "glm-4.6", "User")
Write-Host "✅ Set environment variables" -ForegroundColor Green

Write-Host ""
Write-Host "🎉 Headful MCP Playwright setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📝 Next steps:" -ForegroundColor Cyan
Write-Host "1. Install X Server (VcXsrv or Xming)" -ForegroundColor White
Write-Host "2. Start X Server with remote connections enabled" -ForegroundColor White
Write-Host "3. Restart Claude Desktop" -ForegroundColor White
Write-Host "4. Use browser automation tools - you will see the actual browser window" -ForegroundColor White