# Quick Start - Running EyeBreak from Xcode

## The project is now open in Xcode! 🎉

### To Run and See the App:

1. **In Xcode, look at the top-left toolbar**
   - You should see "EyeBreak" scheme selected
   - If not, click the scheme dropdown and select "EyeBreak"

2. **Click the ▶️ Play/Run button** (or press ⌘R)
   - This is the triangle button in the top-left
   - Or go to: **Product → Run**

3. **Watch for:**
   - Xcode will build the app (progress bar at top)
   - App will launch
   - Look at the **bottom panel** in Xcode for console output
   - You should see: "Notification permission granted" or similar

4. **Look at your menu bar** (top-right of screen)
   - After app launches, an **eye icon (👁️)** should appear
   - It will be near your clock/battery icons

5. **If you see the eye icon:**
   - ✅ Success! Click it to use the app
   - Select "Start Timer" to begin

### Why Run from Xcode?

Running from Xcode helps you:
- See debug console output
- Catch any runtime errors
- Set breakpoints if needed
- See when the app actually launches

### Troubleshooting:

**If build fails:**
- Check the Issues navigator (⌘5) for errors
- Look at the console output (bottom panel)

**If app launches but no icon appears:**
- Check console for errors
- Look for permission requests
- Try granting notification permissions in System Settings

**If you see a dialog asking for permissions:**
- ✅ Click "Allow" for notifications
- This is normal on first launch!

### Next Steps:

Once you see the eye icon:
1. Click it
2. Select "Settings" 
3. Change "Work Interval" to **1 minute** (for quick testing)
4. Select "Start Timer"
5. Wait 1 minute to see the break notification!

---

## Alternative: Run from Terminal (Advanced)

If you prefer terminal:

```bash
# Navigate to the built app
cd ~/Library/Developer/Xcode/DerivedData/EyeBreak-*/Build/Products/Debug/

# Run it
./EyeBreak.app/Contents/MacOS/EyeBreak
```

Keep that terminal open to see console logs.

---

**Let me know once you see the eye icon in your menu bar!** 👁️
