# Install Playwright MCP (Final Version)
Write-Host "🎭 Installing Microsoft Playwright MCP" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan

# Step 1: Install browser binaries
Write-Host "🌐 Step 1: Installing browser binaries..." -ForegroundColor Yellow
try {
    npx @playwright/mcp@latest browser_install
    Write-Host "✅ Browser binaries installed!" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Manual browser installation required" -ForegroundColor Yellow
}

# Step 2: Create config directory
Write-Host "📁 Step 2: Setting up configuration directory..." -ForegroundColor Yellow
$configDir = "$env:USERPROFILE\.claude"
if (!(Test-Path $configDir)) {
    New-Item -ItemType Directory -Force -Path $configDir | Out-Null
}
Write-Host "✅ Config directory created: $configDir" -ForegroundColor Green

# Step 3: Copy configuration files
Write-Host "📋 Step 3: Copying configuration files..." -ForegroundColor Yellow
Copy-Item "C:\Users\User\Desktop\test\claude-desktop-config-playwright.json" "$configDir\claude_desktop_config.json" -Force
Copy-Item "C:\Users\User\Desktop\test\playwright-headful-config.json" "$configDir\" -Force
Write-Host "✅ Configuration files copied!" -ForegroundColor Green

# Step 4: Set environment variables
Write-Host "🔧 Step 4: Setting environment variables..." -ForegroundColor Yellow
[Environment]::SetEnvironmentVariable("CLAUDE_CONFIG_DIR", $configDir, "User")
Write-Host "✅ Environment variables set!" -ForegroundColor Green

Write-Host ""
Write-Host "🎉 Installation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📝 Next steps:" -ForegroundColor Cyan
Write-Host "1. Restart Claude Desktop" -ForegroundColor White
Write-Host "2. Use playwright tools with visible browser" -ForegroundColor White
Write-Host "3. Try commands like browser_navigate, browser_type, browser_click" -ForegroundColor White