# Audio Source Switcher

An AppleScript utility to quickly switch between audio input and output devices on macOS using keyboard navigation.

## Prerequisites

Install `SwitchAudioSource` via Homebrew:

```bash
brew install switchaudio-osx
```

## Installation

### Option 1: Run directly
```bash
osascript AudioSourceSwitcher.applescript
```

### Option 2: Create an Application
1. Open `AudioSourceSwitcher.applescript` in Script Editor
2. File → Export → File Format: Application
3. Save to Applications folder or Desktop
4. Optionally assign a keyboard shortcut using Automator or third-party tools like Alfred/Raycast

### Option 3: Assign a keyboard shortcut (Automator)
1. Open Automator → New Document → Quick Action
2. Set "Workflow receives" to "no input"
3. Add "Run AppleScript" action
4. Paste the script contents
5. Save with a name like "Audio Switcher"
6. Go to System Settings → Keyboard → Keyboard Shortcuts → Services
7. Assign your preferred shortcut

## Usage

When launched, the utility presents a menu with three options:

1. **Switch Output Device** - Select from available output devices (speakers, headphones, etc.)
2. **Switch Input Device** - Select from available input devices (microphones)
3. **Show Current Devices** - Display current input/output devices with quick switch options

### Keyboard Navigation
- Use **↑/↓** arrow keys to navigate the list
- Press **Enter** to select
- Press **Escape** to cancel
- Type to filter/search devices

The current device is marked with ✓ in the selection list.

## Features

- Dynamically lists all connected audio devices at runtime
- Shows current device selection with checkmark indicator
- macOS native notifications on successful switch
- Works with both Apple Silicon and Intel Macs
- No hardcoded device names - adapts to your system
