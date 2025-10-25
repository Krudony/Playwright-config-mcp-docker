# MCP Docker Windows Setup - Simple Version
Write-Host "=== MCP Docker Windows Setup ===" -ForegroundColor Cyan

# Check Docker
Write-Host "Checking Docker..." -ForegroundColor Yellow
try {
    docker version | Out-Null
    Write-Host "Docker is running" -ForegroundColor Green
} catch {
    Write-Host "Docker not found. Please start Docker Desktop." -ForegroundColor Red
    exit 1
}

# Create config directory
$configDir = "$env:USERPROFILE\.claude"
New-Item -ItemType Directory -Force -Path $configDir | Out-Null
Write-Host "Config directory created: $configDir" -ForegroundColor Green

# Backup existing config
if (Test-Path "$configDir\claude_desktop_config.json") {
    Copy-Item "$configDir\claude_desktop_config.json" "$configDir\claude_desktop_config.backup.json" -Force
    Write-Host "Existing config backed up" -ForegroundColor Green
}

# Apply Docker configuration
Copy-Item "C:\Users\User\Desktop\test\claude-desktop-docker-config.json" "$configDir\claude_desktop_config.json" -Force
Write-Host "Docker MCP configuration applied" -ForegroundColor Green

# Set environment variables
[Environment]::SetEnvironmentVariable("DOCKER_HOST", "npipe:////./pipe/docker_engine", "User")
[Environment]::SetEnvironmentVariable("CLAUDE_CONFIG_DIR", $configDir, "User")
Write-Host "Environment variables set" -ForegroundColor Green

Write-Host ""
Write-Host "Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Restart Claude Desktop"
Write-Host "2. Check Claude Desktop Settings - MCP Servers"
Write-Host "3. Look for playwright-docker and filesystem-docker"
Write-Host "4. Test with browser automation commands"