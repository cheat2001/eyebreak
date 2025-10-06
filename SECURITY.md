# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Reporting a Vulnerability

We take security seriously at EyeBreak. If you discover a security vulnerability, please follow these steps:

### How to Report

**DO NOT** open a public issue for security vulnerabilities.

Instead:

1. **Email**: Send details to [chansocheatsok2001@gmail.com](mailto:chansocheatsok2001@gmail.com) with the subject "EyeBreak Security Vulnerability"
2. **Include**:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)
   - Your contact information

### What to Expect

- **Acknowledgment**: We'll acknowledge your report within 48 hours
- **Updates**: We'll keep you informed about our progress
- **Fix**: We'll work on a fix and release a patch as soon as possible
- **Credit**: We'll credit you in the release notes (unless you prefer to remain anonymous)

### Scope

Security issues we're interested in:

- **Privacy violations**: Data leaking outside the app
- **Privilege escalation**: Unauthorized access to system resources
- **Code injection**: Ability to execute arbitrary code
- **Permission bypasses**: Circumventing macOS security features

### Out of Scope

- Issues requiring physical access to an unlocked device
- Social engineering attacks
- Issues in third-party dependencies (report to the dependency maintainers)

## Security Best Practices

EyeBreak follows these security practices:

### Data Privacy
- ✅ All data stored locally using UserDefaults
- ✅ No network requests or data transmission
- ✅ No analytics or telemetry
- ✅ No third-party SDKs or dependencies

### macOS Security
- ✅ App Sandbox enabled
- ✅ Hardened Runtime enabled
- ✅ Code signing required
- ✅ Proper entitlements for screen recording
- ✅ User permission requests for all privileged operations

### Code Security
- ✅ Swift's memory safety features
- ✅ No use of unsafe pointers (except in IdleDetector with IOKit)
- ✅ Input validation where applicable
- ✅ Secure coding practices

### Permissions
The app requests only necessary permissions:
- **Screen Recording**: Required only for screen blur feature
- **Notifications**: Optional, for break reminders

Users can deny permissions and the app gracefully degrades functionality.

## Disclosure Policy

- Security vulnerabilities will be disclosed after a fix is available
- We'll publish a security advisory with details of:
  - The vulnerability
  - Affected versions
  - The fix
  - Credit to the reporter
- Critical vulnerabilities will be fixed within 7 days
- Non-critical vulnerabilities will be fixed in the next release

## Security Checklist for Contributors

When contributing code, please ensure:

- [ ] No hardcoded secrets or credentials
- [ ] No unnecessary permissions requested
- [ ] Input validation for user-provided data
- [ ] Proper error handling
- [ ] No use of deprecated APIs
- [ ] Follow Swift security best practices
- [ ] Test permission denial scenarios

## Additional Resources

- [Apple Platform Security](https://support.apple.com/guide/security/welcome/web)
- [macOS Security Compliance](https://developer.apple.com/documentation/security)
- [Swift Security Guide](https://swift.org/documentation/security/)

## Contact

For non-security issues, please use [GitHub Issues](https://github.com/cheat2001/eyebreak/issues).

For security issues, email: [YOUR-EMAIL@example.com]

---

Thank you for helping keep EyeBreak secure! 🔒✨
