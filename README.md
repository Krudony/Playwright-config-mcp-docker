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

### 🐛 [MCP Docker Windows Fix](./mcp-docker-windows-fix.md)
แก้ไขปัญหา Claude ไม่สามารถเชื่อมต่อกับ MCP Docker Servers บน Windows:
- วิเคราะห์สาเหตุรากของปัญหา
- แก้ไขการกำหนดค่า Docker เฉพาะ Windows
- สคริปต์ติดตั้งอัตโนมัติ
- รองรับภาษาไทย

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
- [GitHub Issue #2 - MCP Docker Windows Connectivity](https://github.com/Krudony/Playwright-config-mcp-docker/issues/2) ✅ **RESOLVED**

## 📋 เครื่องมือที่มีให้ (Available Tools)

### 🎭 Browser Automation (Headful Mode)
- **สคริปต์**: `docker-setup-simple.ps1`, `install-playwright-final.ps1`
- **คอนฟิก**: `playwright-headful-config.json`, `claude-desktop-config-playwright.json`
- **ความสามารถ**: มองเห็นการทำงานของบราวเซอร์จริง, ถ่ายภาพ, ทดสอบอัตโนมัติ

### 🐳 Docker Connectivity (Windows)
- **สคริปต์**: `docker-setup-simple.ps1`
- **คอนฟิก**: `claude-desktop-docker-config.json`
- **แก้ไข**: ปัญหาการเชื่อมต่อ MCP Docker บน Windows
- **สถานะ**: ✅ **แก้ไขแล้ว** - Issue #2

### 📚 Documentation (Thai/English)
- **คู่มือ**: `MCP-Configuration-Guide.md` (ภาษาไทย)
- **แก้ไขปัญหา**: `mcp-docker-windows-fix.md`
- **สรุป**: `SOLUTION-ISSUE-2.md`

## 🏷️ Labels
`browser-automation` `playwright` `windows` `troubleshooting` `headful-mode` `docker-connectivity` `thai-support`

---

**💡 Pro Tip**: ใช้เทมเพลตการแก้ปัญหาเพื่อการแก้ไขปัญหาเชิงระบบในโปรเจคอื่นๆ!
**🎯 ความสำเร็จ**: แก้ไข Issue #2 สำเร็จแล้ว - Claude สามารถเชื่อมต่อกับ MCP Docker บน Windows ได้แล้ว!
