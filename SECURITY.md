# Security Policy

## Supported Versions

We provide security updates for the following versions of VoiceLog:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

If you discover a security vulnerability in VoiceLog, please report it responsibly.

### How to Report

1. **Do not** open a public issue
2. Email security details to: [security@example.com](mailto:security@example.com)
3. Include the following information:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

### What to Include

- VoiceLog version
- Operating system and version
- Go version
- Detailed reproduction steps
- Any relevant logs or error messages

### Response Timeline

- Initial response: Within 48 hours
- Status update: Within 7 days
- Resolution: Depends on severity and complexity

### Security Considerations

VoiceLog handles audio data and user files. Security concerns may include:

- Audio data handling and storage
- File system access permissions
- Audio device access
- Configuration file security
- Network communication (if applicable)

### Best Practices

- Keep VoiceLog updated to the latest version
- Run with appropriate file system permissions
- Be cautious with audio device access
- Review configuration files for sensitive data

## Security Updates

Security updates will be released as patch versions (e.g., 1.0.1, 1.0.2) and announced through:

- GitHub releases
- Security advisories
- Project documentation

## Acknowledgments

We appreciate security researchers who responsibly disclose vulnerabilities. Contributors who report valid security issues will be acknowledged in our security advisories.
