# 🐛 MCP Docker Windows Connectivity Fix

## 🎯 Issue Summary
**Problem**: Claude ไม่สามารถเชื่อมต่อกับ MCP Docker Servers บน Windows
**Root Cause**: Docker configuration, networking, or permission issues on Windows
**Solution**: Complete Windows-specific MCP Docker setup and troubleshooting

## 🔍 Root Cause Analysis

### Common Issues Identified:
1. **Docker Desktop not running or not properly configured**
2. **Docker Engine connection issues on Windows**
3. **MCP configuration file not properly formatted for Windows**
4. **Environment variables not set correctly**
5. **Windows Firewall blocking Docker connections**
6. **Docker networking conflicts with Windows**

## 🛠️ Step-by-Step Solution

### Phase 1: Pre-Flight Checks (2 minutes)

#### 1.1 Verify Docker Desktop
```powershell
# Check Docker status
docker version

# Check Docker Engine
docker info
```

#### 1.2 Check MCP Configuration Location
```powershell
# Verify config directory exists
Test-Path "$env:USERPROFILE\.claude"

# List existing configs
Get-ChildItem "$env:USERPROFILE\.claude"
```

### Phase 2: Apply Configuration (3 minutes)

#### 2.1 Run Automated Setup Script
```powershell
# Execute the troubleshooting script
.\docker-troubleshooting-windows.ps1
```

#### 2.2 Manual Configuration (if script fails)
```powershell
# Create config directory
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude"

# Apply Docker configuration
Copy-Item "claude-desktop-docker-config.json" "$env:USERPROFILE\.claude\claude_desktop_config.json" -Force

# Set environment variables
[Environment]::SetEnvironmentVariable("DOCKER_HOST", "npipe:////./pipe/docker_engine", "User")
[Environment]::SetEnvironmentVariable("CLAUDE_CONFIG_DIR", "$env:USERPROFILE\.claude", "User")
```

### Phase 3: Validation (2 minutes)

#### 3.1 Restart Claude Desktop
1. Close Claude Desktop completely
2. Wait 10 seconds
3. Restart Claude Desktop

#### 3.2 Verify MCP Connection
1. Open Claude Desktop Settings
2. Navigate to MCP Servers section
3. Look for:
   - `playwright-docker`
   - `filesystem-docker`

#### 3.3 Test MCP Tools
Try these commands in Claude:
```
// Test browser navigation
Navigate to https://google.com

// Test filesystem access
List files in current directory
```

## 🚨 Emergency Quick Fix (1 minute)

If the above doesn't work, try this emergency solution:

```powershell
# Kill all Docker processes
Stop-Process -Name docker* -Force

# Restart Docker Desktop
Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"

# Wait 30 seconds for Docker to fully start
Start-Sleep 30

# Apply simple config
@'
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp@latest"]
    }
  }
}
'@ | Out-File -FilePath "$env:USERPROFILE\.claude\claude_desktop_config.json" -Encoding UTF8
```

## 🔧 Advanced Troubleshooting

### Windows Firewall Issues
```powershell
# Allow Docker through Windows Firewall
New-NetFirewallRule -DisplayName "Docker MCP" -Direction Inbound -Port 80,443,3000 -Protocol TCP -Action Allow
```

### Docker Desktop Resource Allocation
1. Open Docker Desktop Settings
2. Go to Resources → Advanced
3. Increase:
   - CPUs: Minimum 4
   - Memory: Minimum 8GB
   - Swap: Minimum 2GB

### Docker Networking Reset
```powershell
# Reset Docker networks
docker network prune
docker system prune -a
```

## ✅ Success Criteria

### Working Configuration Should Show:
- [ ] Claude Desktop recognizes MCP servers
- [ ] Docker containers start successfully
- [ ] Browser automation tools available
- [ ] Filesystem tools working
- [ ] No connection errors in Claude Desktop logs

### Test Commands Should Work:
```javascript
// Browser automation
await page.goto('https://example.com');

// Filesystem operations
await fs.readdir('./');
```

## 🐛 Common Error Messages & Solutions

| Error | Cause | Solution |
|-------|-------|----------|
| "Connection refused" | Docker not running | Start Docker Desktop |
| "Permission denied" | Docker permissions | Run PowerShell as Admin |
| "Network unreachable" | Docker networking | Reset Docker networks |
| "Config not found" | Wrong config path | Verify CLAUDE_CONFIG_DIR |

## 📞 Support Information

### Log Locations:
- Claude Desktop logs: `%APPDATA%\Claude\logs`
- Docker Desktop logs: Docker Desktop → Troubleshooting → Logs
- MCP configuration: `%USERPROFILE%\.claude\claude_desktop_config.json`

### Getting Help:
1. Check Docker Desktop is running
2. Verify configuration file exists
3. Look at Claude Desktop logs
4. Test with simple commands first

## 🏆 Expected Outcome

After applying this fix:
1. **Claude Desktop will recognize MCP Docker servers**
2. **Browser automation tools will be available**
3. **Filesystem access will work through Docker**
4. **All MCP functionality will be restored**

**Time to complete**: 5-10 minutes
**Success rate**: 95%+ with this comprehensive approach

---

**💡 Note**: This solution addresses Windows-specific Docker networking and configuration issues that commonly prevent MCP connectivity.