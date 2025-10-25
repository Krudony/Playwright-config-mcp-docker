# 🎭 MCP Playwright Headful Browser Setup

## 📋 Overview
Complete solution for MCP Playwright headful browser visibility issues on Windows systems. Make browser automation visible and controllable!

## 🚀 Quick Start (5 Minutes)

### 1. Update Configuration
```json
// playwright-headful-config.json
{
  "browser": {
    "browserName": "chromium",
    "launchOptions": {
      "headless": false,
      "args": [
        "--start-maximized",
        "--disable-gpu",
        "--disable-backgrounding-occluded-windows",
        "--disable-renderer-backgrounding"
      ]
    }
  }
}
```

### 2. Restart Browser
```bash
# Kill all Chrome processes
powershell -Command "Stop-Process -Name chrome -Force"

# Start fresh
powershell -Command "Start-Process chrome -ArgumentList 'https://google.com' -WindowStyle Maximized"
```

### 3. Connect MCP
```javascript
await page.goto('https://google.com');
window.moveTo(0, 0);
window.focus();
```

## 📚 Documentation

### 📄 [Issue Template](./headful-browser-setup-template.md)
Complete GitHub issue template for systematic troubleshooting:
- Root cause analysis
- Step-by-step solutions
- Acceptance criteria
- Alternative approaches

### 🚀 [Quick Fix Guide](./quick-fix-headful-browser.md)
Emergency solutions and comprehensive troubleshooting:
- 5-minute emergency fix
- 15-minute complete solution
- Advanced scenarios
- Last resort methods

## ✅ Verification Checklist

### Pre-Flight:
- [ ] Chrome latest version installed
- [ ] PowerShell execution enabled
- [ ] MCP Playwright config path correct
- [ ] No VPN/proxy blocking

### Post-Fix:
- [ ] Browser window visible on screen
- [ ] All MCP tools functional
- [ ] No console errors
- [ ] Screenshots working

## 🛠️ Technical Details

### Root Causes Identified:
- Configuration parameters insufficient
- GPU acceleration issues on Windows
- Background processes hiding windows
- Multiple Chrome instances causing confusion

### Solution Pattern:
1. **Update Config** → Add visibility & safety parameters
2. **Clean Restart** → Kill old processes, start fresh
3. **Force Visibility** → Control window position & size
4. **Validate** → Test all functions

## 🎯 Success Metrics
- Browser launch time < 10 seconds
- Zero lag during automation
- Proper window sizing
- Full MCP tool functionality

## 🔗 Related Resources
- [Playwright Documentation](https://playwright.dev/)
- [Chrome Command Line Switches](https://peter.sh/experiments/chromium-command-line-switches/)
- [GitHub Issue #1](https://github.com/Krudony/Playwright-config-mcp-docker/issues/1)

## 🏷️ Labels
`browser-automation` `playwright` `windows` `troubleshooting` `headful-mode`

---

**💡 Pro Tip**: Use the issue template for systematic problem solving in other projects!
