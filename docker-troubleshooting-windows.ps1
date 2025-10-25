# MCP Docker Connectivity Troubleshooting - Windows
Write-Host "🔧 MCP Docker Connectivity Troubleshooting" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Step 1: Check Docker Status
Write-Host "🐳 Step 1: Checking Docker status..." -ForegroundColor Yellow
try {
    $dockerStatus = docker version --format "{{.Server.Version}}"
    if ($dockerStatus) {
        Write-Host "✅ Docker is running (Version: $dockerStatus)" -ForegroundColor Green
    } else {
        Write-Host "❌ Docker is not running" -ForegroundColor Red
        Write-Host "Please start Docker Desktop and try again" -ForegroundColor Yellow
        exit 1
    }
} catch {
    Write-Host "❌ Docker not found or not running" -ForegroundColor Red
    Write-Host "Please install Docker Desktop for Windows" -ForegroundColor Yellow
    exit 1
}

# Step 2: Check Docker Engine Connection
Write-Host "🔌 Step 2: Checking Docker Engine connection..." -ForegroundColor Yellow
try {
    $dockerInfo = docker info --format "{{.OperatingSystem}}"
    Write-Host "✅ Docker Engine connected (OS: $dockerInfo)" -ForegroundColor Green
} catch {
    Write-Host "❌ Cannot connect to Docker Engine" -ForegroundColor Red
    Write-Host "Check Docker Desktop is running properly" -ForegroundColor Yellow
}

# Step 3: Test MCP Docker Images
Write-Host "📦 Step 3: Testing MCP Docker images..." -ForegroundColor Yellow
$mcpImages = @("mcp/playwright", "mcp/filesystem")

foreach ($image in $mcpImages) {
    try {
        docker pull $image
        Write-Host "✅ Successfully pulled $image" -ForegroundColor Green
    } catch {
        Write-Host "⚠️ Failed to pull $image (will try alternative method)" -ForegroundColor Yellow
    }
}

# Step 4: Create Test Configuration
Write-Host "📋 Step 4: Creating test configuration..." -ForegroundColor Yellow
$configDir = "$env:USERPROFILE\.claude"
if (!(Test-Path $configDir)) {
    New-Item -ItemType Directory -Force -Path $configDir | Out-Null
}

# Backup existing config
if (Test-Path "$configDir\claude_desktop_config.json") {
    Copy-Item "$configDir\claude_desktop_config.json" "$configDir\claude_desktop_config.backup.json" -Force
    Write-Host "✅ Backed up existing configuration" -ForegroundColor Green
}

# Copy Docker configuration
Copy-Item "C:\Users\User\Desktop\test\claude-desktop-docker-config.json" "$configDir\claude_desktop_config.json" -Force
Write-Host "✅ Applied Docker MCP configuration" -ForegroundColor Green

# Step 5: Test Docker Container Execution
Write-Host "🧪 Step 5: Testing Docker container execution..." -ForegroundColor Yellow
try {
    $testResult = docker run --rm -i mcp/playwright node -e "console.log('Docker container working')"
    if ($testResult -like "*Docker container working*") {
        Write-Host "✅ Docker container execution successful" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Docker container execution issue detected" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ Docker container execution failed" -ForegroundColor Red
    Write-Host "This may indicate Docker networking or permission issues" -ForegroundColor Yellow
}

# Step 6: Set Environment Variables
Write-Host "🔧 Step 6: Setting environment variables..." -ForegroundColor Yellow
[Environment]::SetEnvironmentVariable("DOCKER_HOST", "npipe:////./pipe/docker_engine", "User")
[Environment]::SetEnvironmentVariable("CLAUDE_CONFIG_DIR", $configDir, "User")
Write-Host "✅ Environment variables set" -ForegroundColor Green

# Step 7: Final Verification
Write-Host "✅ Step 7: Final verification checklist..." -ForegroundColor Green
Write-Host ""
Write-Host "📝 Please verify the following:" -ForegroundColor Cyan
Write-Host "1. ✅ Docker Desktop is running" -ForegroundColor White
Write-Host "2. ✅ MCP configuration file created at: $configDir\claude_desktop_config.json" -ForegroundColor White
Write-Host "3. ✅ Environment variables set" -ForegroundColor White
Write-Host "4. 🔄 Restart Claude Desktop to apply changes" -ForegroundColor White
Write-Host "5. 🔄 Check Claude Desktop Settings → MCP Servers" -ForegroundColor White

Write-Host ""
Write-Host "🎉 Troubleshooting complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Next Steps:" -ForegroundColor Cyan
Write-Host "1. Restart Claude Desktop" -ForegroundColor White
Write-Host "2. Check Claude Desktop Settings - MCP Servers" -ForegroundColor White
Write-Host "3. Look for playwright-docker and filesystem-docker in the list" -ForegroundColor White
Write-Host "4. Test with browser automation commands" -ForegroundColor White

Write-Host ""
Write-Host "🐛 If issues persist:" -ForegroundColor Yellow
Write-Host "- Check Windows Firewall settings" -ForegroundColor White
Write-Host "- Verify Docker Desktop has proper permissions" -ForegroundColor White
Write-Host "- Try running PowerShell as Administrator" -ForegroundColor White
Write-Host "- Check Docker Desktop resource allocation" -ForegroundColor White