# Contributing to VoiceLog

Thank you for your interest in contributing to VoiceLog. This document provides guidelines for contributing to the project.

## Getting Started

### Prerequisites

- Go 1.21 or later
- PortAudio development libraries
- Git

### Windows (MSYS2)
```bash
pacman -S mingw-w64-x86_64-portaudio
```

### Linux (Ubuntu/Debian)
```bash
sudo apt-get install libportaudio2 portaudio19-dev
```

## Development Setup

1. Fork the repository
2. Clone your fork: `git clone https://github.com/your-username/voicelog.git`
3. Navigate to the project: `cd voicelog`
4. Install dependencies: `go mod download`
5. Build the project: `go build -o voicelog main.go`

## Making Changes

### Code Style

- Follow Go standard formatting: `gofmt -s`
- Use meaningful variable and function names
- Add comments for public functions and complex logic
- Keep functions focused and reasonably sized

### Testing

- Add tests for new functionality
- Ensure existing tests pass: `go test ./...`
- Test audio functionality on your target platform

### Audio Development

- Test with different audio devices and configurations
- Verify recording and playback quality
- Consider cross-platform audio compatibility

## Submitting Changes

### Pull Request Process

1. Create a feature branch: `git checkout -b feature/your-feature-name`
2. Make your changes and test thoroughly
3. Commit with clear messages: `git commit -m "Add feature: brief description"`
4. Push to your fork: `git push origin feature/your-feature-name`
5. Open a pull request with a clear description

### Pull Request Guidelines

- Provide a clear title and description
- Reference any related issues
- Include testing instructions
- Ensure CI passes
- Keep changes focused and atomic

## Issue Reporting

When reporting issues, please include:

- Operating system and version
- Go version
- Steps to reproduce
- Expected vs actual behavior
- Audio device information (if relevant)

## Code of Conduct

- Be respectful and constructive
- Focus on the code, not the person
- Help others learn and improve
- Follow the project's technical decisions

## Questions

For questions about contributing, please open a discussion or issue on GitHub.
