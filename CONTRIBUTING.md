# Contributing to EyeBreak

First off, thank you for considering contributing to EyeBreak! It's people like you that make EyeBreak such a great tool. 🎉

## Code of Conduct

This project and everyone participating in it is governed by respect, kindness, and professionalism. By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

- Use a clear and descriptive title
- Describe the exact steps to reproduce the problem
- Provide specific examples to demonstrate the steps
- Describe the behavior you observed and what behavior you expected
- Include screenshots if relevant
- Include your macOS version and EyeBreak version
- Include any relevant console logs

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:

- A clear and descriptive title
- A detailed description of the proposed feature
- Explain why this enhancement would be useful
- List any alternative solutions you've considered
- Include mockups or examples if applicable

### Pull Requests

1. **Fork the repository** and create your branch from `main`
2. **Make your changes** following the code style guidelines below
3. **Test your changes** thoroughly:
   - Build and run the app
   - Test both with and without permissions granted
   - Test different settings configurations
   - Ensure no new warnings or errors
4. **Update documentation** if needed
5. **Commit your changes** with clear, descriptive commit messages
6. **Push to your fork** and submit a pull request

## Development Setup

### Prerequisites

- macOS 14.0 (Sonoma) or later
- Xcode 15.0 or later
- Swift 5.9+

### Setting Up Your Development Environment

1. Clone your fork:
   ```bash
   git clone https://github.com/YOUR-USERNAME/eyebreak.git
   cd eyebreak
   ```

2. Open the project in Xcode:
   ```bash
   open EyeBreak.xcodeproj
   ```

3. Select your development team in Signing & Capabilities

4. Build and run (⌘R)

### Project Structure

```
EyeBreak/
├── EyeBreakApp.swift          # Main app entry point
├── Models/                    # Data models
│   ├── TimerState.swift
│   └── Settings.swift
├── Views/                     # SwiftUI views
│   ├── MenuBarView.swift
│   ├── SettingsView.swift
│   ├── BreakOverlayView.swift
│   ├── OnboardingView.swift
│   └── StatsView.swift
├── Managers/                  # Business logic
│   ├── BreakTimerManager.swift
│   ├── IdleDetector.swift
│   ├── NotificationManager.swift
│   └── ScreenBlurManager.swift
└── Resources/                 # Assets and resources
```

## Code Style Guidelines

### Swift Style

- Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use meaningful variable and function names
- Add comments for complex logic
- Use `// MARK: -` to organize code sections
- Prefer `let` over `var` when possible
- Use explicit `self` only when required by the compiler

### SwiftUI Best Practices

- Keep views small and focused
- Extract reusable components
- Use `@State` for view-local state
- Use `@ObservedObject` or `@StateObject` for shared state
- Use `@AppStorage` for persisted settings

### Naming Conventions

- **Types**: `PascalCase` (e.g., `BreakTimerManager`)
- **Variables/Properties**: `camelCase` (e.g., `workInterval`)
- **Constants**: `camelCase` (e.g., `defaultWorkInterval`)
- **Functions**: `camelCase` with clear verb (e.g., `startTimer()`)
- **Enums**: `PascalCase` for type, `camelCase` for cases

### Code Organization

```swift
// MARK: - Properties
private var timer: Timer?
@Published var state: TimerState

// MARK: - Initialization
init() { }

// MARK: - Public Methods
func startTimer() { }
func stopTimer() { }

// MARK: - Private Methods
private func updateTimer() { }

// MARK: - Helpers
private func formatTime(_ seconds: Int) -> String { }
```

## Testing

Before submitting a pull request, ensure you've tested:

- [ ] App builds without errors or warnings
- [ ] App runs on a clean install (delete app data first)
- [ ] All core features work:
  - [ ] Timer starts and counts down correctly
  - [ ] Break overlay appears and dismisses
  - [ ] Notifications appear (with permission)
  - [ ] Idle detection pauses timer
  - [ ] Settings persist across launches
  - [ ] Statistics update correctly
- [ ] Test edge cases:
  - [ ] Mac sleeps during timer
  - [ ] Screen Recording permission denied
  - [ ] Notifications permission denied
  - [ ] Multiple displays
  - [ ] Rapid start/stop operations

## Documentation

- Update `README.md` if you change functionality
- Update `CHANGELOG.md` with your changes
- Add inline comments for complex logic
- Update relevant documentation in `/docs` folder if needed

## Commit Messages

Write clear, concise commit messages:

```
Add dark mode support to break overlay

- Implement color scheme detection
- Update overlay colors for dark mode
- Add system appearance change listener
- Test on both light and dark modes
```

Good commit message format:
- Use present tense ("Add feature" not "Added feature")
- Use imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit first line to 72 characters
- Reference issues and pull requests when relevant

## Questions?

Feel free to open an issue with the `question` label if you need help!

## License

By contributing to EyeBreak, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing! 🙏✨
