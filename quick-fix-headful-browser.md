# 🚀 Quick Fix Guide: MCP Playwright Headful Browser (Windows)

## ⚡ **Emergency Fix (5 นาที)**

### 1. แก้ไข Config ทันที
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

### 2. รีสตาร์ททันที
```bash
# ฆ่า Chrome ทั้งหมด
powershell -Command "Stop-Process -Name chrome -Force"

# เปิดใหม่ด้วย PowerShell
powershell -Command "Start-Process chrome -ArgumentList 'https://google.com' -WindowStyle Maximized"
```

### 3. เชื่อมต่อ MCP
```javascript
await page.goto('https://google.com');
window.moveTo(0, 0);
window.focus();
```

## 🔧 **Complete Solution (15 นาที)**

### Step 1: Environment Check
```bash
# ตรวจสอบ Chrome path
dir "C:\Program Files\Google\Chrome\Application\chrome.exe"

# ตรวจสอบกระบวนการที่ทำงานอยู่
tasklist | findstr chrome
```

### Step 2: Configuration Update
```json
// เพิ่ม parameters ทั้งหมดใน args array
[
  "--start-maximized",
  "--no-sandbox",
  "--disable-gpu",
  "--disable-dev-shm-usage",
  "--disable-extensions",
  "--disable-background-timer-throttling",
  "--disable-backgrounding-occluded-windows",
  "--disable-renderer-backgrounding"
]
```

### Step 3: Process Management
```bash
# Clean restart
powershell -Command "Get-Process chrome | Stop-Process -Force"

# Fresh start with custom profile
powershell -Command "Start-Process chrome -ArgumentList '--user-data-dir=C:\\temp\\chrome-profile','--start-maximized','https://google.com'"
```

### Step 4: Window Control
```javascript
// Force window to be visible
window.moveTo(0, 0);
window.resizeTo(1920, 1080);
window.focus();
window.minimize(); // แล้ว maximize ให้แน่ใจว่าแสดง
window.maximize();
```

## 🛠️ **Advanced Troubleshooting**

### Multiple Display Setup
```javascript
// ตรวจสอบว่าหน้าต่างอยู่จอไหน
const screens = window.screen;
console.log('Screen width:', screens.width);
console.log('Screen height:', screens.height);

// ย้ายไปจอหลัก
window.moveTo(0, 0);
```

### Virtual Machine Issues
```json
// เพิ่ม parameters สำหรับ VM
{
  "args": [
    "--disable-accelerated-2d-canvas",
    "--disable-accelerated-jpeg-decoding",
    "--disable-accelerated-mjpeg-decode",
    "--disable-accelerated-video-decode"
  ]
}
```

### Security Policy Issues
```json
// สำหรับระบบที่มีนโยบายความปลอดภัยเข้มงวด
{
  "args": [
    "--disable-web-security",
    "--disable-features=VizDisplayCompositor",
    "--no-sandbox"
  ]
}
```

## 📋 **Checklist Before Use**

### Pre-Flight Check:
- [ ] Chrome เวอร์ชันล่าสุดติดตั้งแล้ว
- [ ] PowerShell สามารถ execute scripts ได้
- [ ] MCP Playwright config path ถูกต้อง
- [ ] ไม่มี VPN หรือ proxy บล็อกการทำงาน

### Post-Fix Validation:
- [ ] เห็นหน้าต่าง Chrome บนหน้าจอ
- [ ] MCP tools ทำงานได้ครบ
- [ ] ไม่มี error ใน console
- [ ] สามารถ capture screenshot ได้

## 🔄 **When All Else Fails**

### Last Resort Method:
1. **Uninstall MCP Playwright**
2. **Clear all Chrome profiles**
3. **Restart Windows**
4. **Reinstall with fresh config**
5. **Test with simple URL first**

### Alternative Tools:
- **Selenium WebDriver** - Traditional browser automation
- **Puppeteer** - Node.js based automation
- **BrowserStack** - Cloud-based testing

## 📞 **Getting Help**

### Debug Information to Collect:
```bash
# Chrome version
chrome --version

# System info
systeminfo | findstr /B /C:"OS Name" /C:"OS Version"

# MCP Playwright logs
# Check Claude Desktop logs for errors
```

### Common Error Messages:
- `"Navigation timeout exceeded"` → เพิ่ม timeout ใน config
- `"Target closed"` → กระบวนการ Chrome ถูกฆ่าไป
- `"Browser not found"` → Path ไม่ถูกต้อง

---

**💡 Pro Tip**: บันทึก config ที่ทำงานได้ไว้เป็น template สำหรับโปรเจคอื่นๆ!