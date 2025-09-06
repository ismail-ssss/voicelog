# VoiceLog

A terminal-based voice memo application built with Go and Bubble Tea.

## Screenshots

### Main Screen
The main interface showing the memo list, ASCII art speaker visualization, and help information.

<img src="voicelog-screenshot-1.png" alt="VoiceLog Main Screen" width="600">

### Settings Screen
Audio configuration interface displaying hardware/audio settings, available devices, and help.

<img src="voicelog-screenshot-2.png" alt="VoiceLog Settings Screen" width="600">

## Features

### Audio Recording and Playback
- Record audio using PortAudio
- Playback with real-time controls
- WAV file format support
- Configurable audio devices and settings
- Test tone generation (440Hz sine wave)

### Memo Management
- List view with navigation
- Rename memos
- Add tags for organization
- Delete memos
- Export memos to Downloads folder

### User Interface
- Terminal user interface using Bubble Tea
- Keyboard navigation
- Settings screen for audio configuration
- Help screen with keybindings
- ASCII art speaker visualization with two-tone coloring
- Professional color scheme with rounded borders

## Installation

### Prerequisites
- Go 1.21 or later
- PortAudio development libraries

### Windows (MSYS2)
```bash
pacman -S mingw-w64-x86_64-portaudio
```

### Build and Run
```bash
# Clone the repository
git clone https://github.com/Cod-e-Codes/voicelog.git
cd voicelog

# Download dependencies
go mod download

# Build the binary
go build -o voicelog.exe main.go

# Run
./voicelog.exe
```

## Usage

### Keybindings

| Key | Action |
|-----|---------|
| `SPACE` | Start/Stop recording |
| `ENTER` | Play/Pause selected memo |
| `↑/↓` | Navigate memo list |
| `ctrl+r` | Rename memo |
| `ctrl+g` | Add tag |
| `ctrl+d` | Delete memo |
| `ctrl+e` | Export memo |
| `ctrl+x` | Stop playback |
| `?` | Show help |
| `ctrl+s` | Settings |
| `ctrl+t` | Generate test file |
| `ESC/q` | Quit |

### Basic Operations

1. **Recording**: Press `SPACE` to start/stop recording
2. **Playback**: Select a memo and press `ENTER` to play
3. **Settings**: Press `ctrl+s` to configure audio devices
4. **Test File**: Press `ctrl+t` to generate a 5-second 440Hz test tone
5. **Export**: Press `e` to export selected memo to Downloads folder

## Configuration

Configuration is stored in `~/.voicelog/config.json` and includes:
- Audio device settings
- Sample rate and format preferences
- Memo storage path
- Keybindings

### File Structure
```
~/.voicelog/
├── config.json          # Application configuration
├── memos/               # Voice memo storage
│   ├── metadata.json    # Memo metadata
│   └── memo_*.wav       # Audio files
└── voicelog.log         # Application logs
```

## Technical Details

Built with:
- **[Bubble Tea](https://github.com/charmbracelet/bubbletea)** - TUI framework
- **[PortAudio](https://github.com/gordonklaus/portaudio)** - Audio I/O
- **Go** - Programming language
