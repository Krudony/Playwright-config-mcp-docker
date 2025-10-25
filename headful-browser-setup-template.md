# Issue Template: MCP Playwright Headful Browser Setup (Windows)

## 🔍 **ปัญหา**
MCP Playwright ทำงานได้ แต่ไม่สามารถแสดงหน้าต่างเบราว์เซอร์จริง (headful mode) ได้บนระบบ Windows

## 📋 **ภาพรวม**
เมื่อพยายามใช้ MCP Playwright ในโหมด headful (มองเห็นหน้าต่าง) บน Windows พบว่าเบราว์เซอร์ไม่ปรากฏบนหน้าจอ แม้ว่าจะมีกระบวนการ Chrome ทำงานอยู่จริง

## 🔧 **การวินิจฉัย**

### สัญญาณที่พบ:
- [ ] MCP Playwright สามารถ navigate ไปยัง URL ได้
- [ ] มีกระบวนการ `chrome.exe` ทำงานอยู่ (เห็นใน Task Manager)
- [ ] ไม่เห็นหน้าต่างเบราว์เซอร์บนหน้าจอ
- [ ] `browser_snapshot` แสดงผลถูกต้อง แต่หน้าต่างมองไม่เห็น

### สาเหตุที่เป็นไปได้:
1. **Configuration Parameters**: การตั้งค่า launch args ไม่เพียงพอ
2. **GPU Acceleration**: ปัญหาการแสดงผลบนระบบ Windows บางรุ่น
3. **Background Processes**: Chrome ถูกคอนฟิกให้ทำงานในพื้นหลัง
4. **Multiple Instances**: กระบวนการ Chrome หลายตัวทำงานพร้อมกัน
5. **Window Position**: หน้าต่างอยู่นอกหน้าจอหรือถูกย่อขนาน

## 💡 **วิธีแก้ปัญหาแบบ Step-by-Step**

### Phase 1: ตรวจสอบและอัปเดต Configuration

1. **ตรวจสอบไฟล์คอนฟิก:**
```json
// playwright-headful-config.json
{
  "browser": {
    "browserName": "chromium",
    "launchOptions": {
      "headless": false,
      "executablePath": "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe",
      "args": [
        "--start-maximized",
        "--no-sandbox",
        "--disable-gpu",
        "--disable-dev-shm-usage",
        "--disable-extensions",
        "--disable-background-timer-throttling",
        "--disable-backgrounding-occluded-windows",
        "--disable-renderer-backgrounding"
      ]
    },
    "contextOptions": {
      "viewport": { "width": 1920, "height": 1080 }
    }
  }
}
```

2. **ตรวจสอบ Claude Desktop Config:**
```json
// claude-desktop-config-playwright.json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": [
        "@playwright/mcp@latest",
        "--config=./playwright-headful-config.json"
      ]
    }
  }
}
```

### Phase 2: ล้างกระบวนการเก่า

```bash
# ฆ่ากระบวนการ Chrome ทั้งหมด
powershell -Command "Stop-Process -Name chrome -Force"

# ตรวจสอบว่าไม่มี chrome.exe ทำงานอยู่
tasklist | findstr chrome
```

### Phase 3: เปิดเบราว์เซอร์ใหม่

```bash
# เปิด Chrome ด้วยการตั้งค่าพิเศษ
powershell -Command "Start-Process 'C:\Program Files\Google\Chrome\Application\chrome.exe' -ArgumentList '--start-maximized','--disable-gpu','https://www.google.com' -WindowStyle Maximized"
```

### Phase 4: เชื่อมต่อและปรับตำแหน่ง

1. **ใช้ MCP Playwright เชื่อมต่อ:**
```javascript
await page.goto('https://www.google.com');
```

2. **ปรับตำแหน่งและขนาดหน้าต่าง:**
```javascript
window.moveTo(0, 0);
window.resizeTo(1920, 1080);
window.focus();
```

### Phase 5: การตรวจสอบ

- [ ] เห็นหน้าต่าง Chrome บนหน้าจอ
- [ ] สามารถ navigate ไปยัง URL ได้
- [ ] `browser_snapshot` ทำงานได้
- [ ] สามารถใช้ `browser_type`, `browser_click` ได้

## 🎯 **Acceptance Criteria**

### ตัวชี้วัดความสำเร็จ:
- [ ] เบราว์เซอร์แสดงผลบนหน้าจอ Windows ได้
- [ ] MCP Playwright tools ทำงานได้ครบถ้วน
- [ ] สามารถดูและควบคุมหน้าต่างเบราว์เซอร์ได้
- [ ] ไม่มี error ใน console

### ประสิทธิภาพ:
- [ ] เวลาในการเปิดเบราว์เซอร์ < 10 วินาที
- [ ] ใช้งานได้ไม่มีการกระตุกหรือ lag
- [ ] หน้าต่างแสดงผลในขนาดที่เหมาะสม

## ⚠️ **ข้อควรระวังและข้อจำกัด**

### Environment Requirements:
- Windows 10/11
- Google Chrome เวอร์ชันล่าสุด
- MCP Playwright ติดตั้งแล้ว
- PowerShell สำหรับ process management

### Known Limitations:
- อาจทำงานไม่ได้บนระบบที่มีนโยบายความปลอดภัยเข้มงวด
- บางครั้งต้องลองหลายครั้งถ้ามี background processes รบกวน
- Virtualized environments อาจมีปัญหาเพิ่มเติม

## 🔄 **Alternative Solutions**

ถ้าวิธีหลักไม่ทำงาน:

1. **ใช้ Docker Container**: สำหรับระบบที่ต้องการ isolation
2. **Remote Debugging**: เชื่อมต่อกับ Chrome Remote Debugging Protocol
3. **Selenium Grid**: ใช้ Selenium แทน Playwright
4. **Cloud-based Browsers**: ใช้บริการ browser automation บนคลาวด์

## 📚 **References**

- [Playwright Documentation](https://playwright.dev/)
- [Chrome Command Line Switches](https://peter.sh/experiments/chromium-command-line-switches/)
- [MCP Playwright GitHub](https://github.com/microsoft/playwright-mcp)

## 🏷️ **Tags**
`bug`, `windows`, `playwright`, `browser`, `headful`, `configuration`

---

**Note**: Template นี้สามารถนำไปใช้กับโปรเจคอื่นๆ ที่ต้องการแก้ปัญหาเดียวกัน ปรับแต่งได้ตามความเหมาะสมของแต่ละโปรเจค