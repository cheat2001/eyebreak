# EyeBreak Testing Guide

## 🚀 Quick Start

### 1. Launch the App
The app is now running! Look for the **eye icon (👁️)** in your Mac's menu bar (top-right corner).

### 2. First Launch - Onboarding

If this is your first time:
- **Welcome screen** will appear
- Click **"Continue"** through the pages
- Learn about the 20-20-20 rule:
  - Every **20 minutes** of work
  - Look **20 feet** away
  - For **20 seconds**
- **Grant permissions** when asked:
  - ✅ Notifications (Required)
  - ✅ Screen Recording (Optional - for screen blur)

### 3. Click "Get Started"

---

## 🧪 Testing Features

### Test 1: Menu Bar Icon
- **Look at:** Top-right corner of screen
- **You should see:** An eye icon
- **Click it:** A menu appears with timer controls

### Test 2: Start Timer
1. Click the eye icon
2. Select **"Start Timer"**
3. **Expected:** Timer starts counting down
4. **Menu shows:** "Next break in XX:XX"

### Test 3: Settings
1. Click the eye icon
2. Select **"Settings"**
3. **Expected:** Settings window opens
4. **Try adjusting:**
   - Work interval (default: 20 minutes)
   - Break duration (default: 20 seconds)
   - Pre-break warning time (default: 30 seconds)
   - Sound notifications
   - Break overlay style

### Test 4: Take Break Now
1. Click the eye icon
2. Select **"Take Break Now"**
3. **Expected:** 
   - Break overlay appears immediately
   - Screen may blur (if permission granted)
   - Timer counts down from 20 seconds
   - Sound plays (if enabled)

### Test 5: Statistics
1. Click the eye icon
2. Select **"Statistics"**
3. **Expected:**
   - Window shows break history
   - Daily break counts
   - Streak information
   - Total breaks taken

### Test 6: Notifications
Wait for a break reminder (or set work interval to 1 minute for testing):
- **30 seconds before break:** Notification appears
  - "Break Time Soon - Wrap up your work..."
- **At break time:** Another notification
  - "Time for a Break! Look away..."
- **After break:** Completion notification
  - "Great Job! Break complete..."

### Test 7: Pause/Resume
1. Click the eye icon
2. Select **"Stop Timer"** (or just close your laptop)
3. **Expected:** Timer pauses
4. Click **"Start Timer"** again
5. **Expected:** Timer resumes from where it left off

### Test 8: Idle Detection
1. Start the timer
2. Lock your Mac or step away for 5+ minutes
3. **Expected:** 
   - Timer automatically pauses
   - Notification: "Timer Paused - You seem to be away..."
4. Come back and move your mouse
5. **Expected:** Timer resumes automatically

---

## 🔍 What to Look For

### ✅ Working Correctly:
- Eye icon appears in menu bar
- Timer counts down properly
- Notifications appear at right times
- Break overlay shows during breaks
- Settings save and apply correctly
- Statistics track breaks accurately

### ⚠️ Potential Issues:
- **No notifications:** Check System Settings → Notifications → EyeBreak
- **No screen blur:** Check System Settings → Privacy & Security → Screen Recording → EyeBreak
- **Timer doesn't start:** Check console for errors
- **App crashes:** Check Console.app for crash logs

---

## 🎯 Quick Testing (Fast Mode)

To test quickly without waiting 20 minutes:

1. **Open Settings**
2. **Change work interval to 1 minute**
3. **Change break duration to 10 seconds**
4. **Start timer**
5. **Wait 1 minute** - break should trigger
6. **Test all features** in this accelerated mode
7. **Reset to defaults** when done:
   - Work: 20 minutes
   - Break: 20 seconds
   - Warning: 30 seconds

---

## 🛠️ Development Testing

### Running from Xcode:
```bash
# Open project
open EyeBreak.xcodeproj

# Or build and run from terminal
xcodebuild -scheme EyeBreak -configuration Debug build
```

### View Console Logs:
1. Open **Console.app**
2. Filter by "EyeBreak"
3. Watch for debug messages

### Check Permissions:
```bash
# Check notifications
open "x-apple.systempreferences:com.apple.preference.notifications"

# Check screen recording
open "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture"
```

---

## 📝 Manual Testing Checklist

- [ ] App launches successfully
- [ ] Menu bar icon appears
- [ ] Onboarding shows on first launch
- [ ] Can start/stop timer
- [ ] Timer counts down correctly
- [ ] Pre-break notification appears
- [ ] Break overlay displays
- [ ] Screen blurs during break (if permission granted)
- [ ] Break completion notification shows
- [ ] Can skip break
- [ ] Can take manual break
- [ ] Settings window opens and saves
- [ ] Statistics window shows data
- [ ] Idle detection pauses timer
- [ ] App survives Mac sleep/wake
- [ ] App quits cleanly

---

## 🐛 Troubleshooting

### App Not Showing in Menu Bar?
```bash
# Kill and restart
pkill -f EyeBreak
open ~/Library/Developer/Xcode/DerivedData/EyeBreak-*/Build/Products/Debug/EyeBreak.app
```

### Permission Issues?
- Go to **System Settings**
- **Privacy & Security**
- Grant permissions manually

### Reset All Settings?
```bash
# Clear user defaults
defaults delete com.eyebreak.app
```

### Check if App is Running?
```bash
# See if process exists
ps aux | grep EyeBreak
```

---

## ✨ Expected Behavior Summary

**Normal Flow:**
1. Timer starts → counts down from 20 minutes
2. At 19:30 → pre-break notification
3. At 20:00 → break starts, overlay appears
4. During break → screen blurs, timer shows countdown
5. After 20 seconds → break ends, overlay disappears
6. Timer resets → cycle repeats

**Menu States:**
- **Idle:** "Start Timer" available
- **Working:** Shows countdown, "Stop Timer" and "Take Break Now" available
- **Breaking:** Shows break countdown, "Skip Break" available
- **Paused:** Shows "Resume Timer"

Enjoy testing your eye health app! 👁️✨
