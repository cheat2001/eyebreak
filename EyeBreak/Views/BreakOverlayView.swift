//
//  BreakOverlayView.swift
//  EyeBreak
//
//  Created on October 5, 2025.
//

import SwiftUI

struct BreakOverlayView: View {
    let duration: Int
    let style: ScreenBlurManager.OverlayStyle
    let onSkip: () -> Void
    
    @State private var remainingSeconds: Int
    @State private var timer: Timer?
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var eventMonitor: Any?
    @AccessibilityFocusState private var isMessageFocused: Bool
    
    // Get the color theme from settings
    @ObservedObject private var settings = AppSettings.shared
    
    private var currentTheme: ColorTheme {
        settings.breakOverlayTheme
    }
    
    init(duration: Int, style: ScreenBlurManager.OverlayStyle, onSkip: @escaping () -> Void) {
        self.duration = duration
        self.style = style
        self.onSkip = onSkip
        _remainingSeconds = State(initialValue: duration)
    }
    
    var body: some View {
        ZStack {
            // Theme-based background gradient
            if currentTheme.themeType == .liquidGlass {
                // Light, airy gradient for liquid glass
                LinearGradient(
                    colors: [
                        currentTheme.backgroundColor.opacity(currentTheme.backgroundOpacity),
                        currentTheme.backgroundColor.opacity(currentTheme.backgroundOpacity * 0.8),
                        Color.white.opacity(0.15)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            } else {
                // Vibrant gradient for default and custom themes
                LinearGradient(
                    colors: [
                        currentTheme.backgroundColor.opacity(currentTheme.backgroundOpacity * 0.4),
                        currentTheme.accentColor.opacity(currentTheme.accentOpacity * 0.4),
                        currentTheme.backgroundColor.opacity(currentTheme.backgroundOpacity * 0.3)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            }
            
            // Background blur
            VisualEffectView(material: .hudWindow, blendingMode: .behindWindow)
                .ignoresSafeArea()
                .opacity(0.8)
            
            // Dimming overlay with theme color
            currentTheme.backgroundColor.opacity(currentTheme.backgroundOpacity * 0.3)
                .ignoresSafeArea()
            
            // Optimized: Remove floating particles to reduce CPU usage
            
            // Content
            VStack(spacing: 40) {
                Spacer()
                
                // Main content based on style
                switch style {
                case .blur:
                    standardBreakContent
                case .exercise:
                    eyeExerciseContent
                }
                
                Spacer()
                
                // Skip hint
                skipHint
            }
            .padding(40)
            .opacity(opacity)
            .scaleEffect(scale)
        }
        .onAppear {
            startAnimation()
            startTimer()
            isMessageFocused = true
            
            // Add ESC key monitoring safely
            eventMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [onSkip] event in
                if event.keyCode == 53 { // ESC key
                    DispatchQueue.main.async {
                        onSkip()
                    }
                    return nil // Consume the event
                }
                return event
            }
        }
        .onDisappear {
            stopTimer()
            // Remove event monitor to prevent leaks
            if let monitor = eventMonitor {
                NSEvent.removeMonitor(monitor)
                eventMonitor = nil
            }
        }
        .onTapGesture {
            DispatchQueue.main.async {
                onSkip()
            }
        }
    }
    
    // MARK: - Standard Break Content
    
    private var standardBreakContent: some View {
        VStack(spacing: 32) {
            // Optimized: Simplified icon with minimal animation
            ZStack {
                // Single outer glow ring
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [
                                currentTheme.accentColor.opacity(0.3),
                                currentTheme.accentColor.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 140, height: 140)
                    .opacity(0.4)
                
                // Main icon with gradient (no animation)
                Image(systemName: "eye.slash.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                currentTheme.accentColor,
                                currentTheme.accentColor.opacity(0.8),
                                currentTheme.backgroundColor
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: currentTheme.accentColor.opacity(0.5), radius: 20)
            }
            
            // Title with gradient
            Text("Time for a Break")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(currentTheme.textGradient())
                .shadow(color: currentTheme.accentColor.opacity(0.3), radius: 10)
                .shadow(color: Color.black.opacity(0.3), radius: 10)
                .accessibilityFocused($isMessageFocused)
            
            // Instruction with subtle animation
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "arrow.left.and.right")
                        .font(.title2)
                        .foregroundColor(currentTheme.accentColor)
                    
                    Text("Look at something 20 feet away")
                        .font(.system(size: 24, weight: .medium, design: .rounded))
                        .foregroundColor(currentTheme.textColor.opacity(currentTheme.textOpacity))
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.caption)
                        .foregroundColor(currentTheme.accentColor.opacity(0.8))
                    Text("Give your eyes a rest")
                        .font(.callout)
                        .foregroundColor(currentTheme.secondaryTextColor.opacity(currentTheme.secondaryTextOpacity))
                    Image(systemName: "sparkles")
                        .font(.caption)
                        .foregroundColor(currentTheme.accentColor.opacity(0.8))
                }
            }
            .multilineTextAlignment(.center)
            .shadow(color: Color.black.opacity(0.3), radius: 5)
            
            // Enhanced timer display
            timerDisplay
        }
    }
    
    // MARK: - Eye Exercise Content
    
    private var eyeExerciseContent: some View {
        AnimatedEyeExerciseView(remainingSeconds: $remainingSeconds, totalDuration: duration)
    }
    
    // MARK: - Timer Display
    
    private var timerDisplay: some View {
        ZStack {
            // Outer decorative ring
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [
                            currentTheme.accentColor.opacity(0.3),
                            currentTheme.backgroundColor.opacity(0.3),
                            currentTheme.accentColor.opacity(0.3)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
                .frame(width: 140, height: 140)
            
            // Background circle with glow
            Circle()
                .fill(currentTheme.backgroundColor.opacity(0.1))
                .frame(width: 130, height: 130)
                .overlay(
                    Circle()
                        .stroke(currentTheme.textColor.opacity(0.2), lineWidth: 8)
                )
                .shadow(color: currentTheme.accentColor.opacity(0.3), radius: 20)
            
            // Progress circle with beautiful animated gradient
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        colors: [
                            currentTheme.accentColor,
                            currentTheme.backgroundColor,
                            currentTheme.accentColor.opacity(0.8),
                            currentTheme.backgroundColor.opacity(0.8),
                            currentTheme.accentColor
                        ],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: 130, height: 130)
                .rotationEffect(.degrees(-90))
                .shadow(color: currentTheme.accentColor.opacity(0.5), radius: 10)
                .animation(.linear(duration: 1), value: progress)
            
            // Countdown text with enhanced styling
            VStack(spacing: 4) {
                Text("\(remainingSeconds)")
                    .font(.system(size: 52, weight: .bold, design: .rounded))
                    .foregroundStyle(currentTheme.textGradient())
                    .shadow(color: currentTheme.accentColor.opacity(0.5), radius: 10)
                    .contentTransition(.numericText())
                
                Text("seconds")
                    .font(.caption)
                    .foregroundColor(currentTheme.secondaryTextColor.opacity(currentTheme.secondaryTextOpacity))
                    .textCase(.uppercase)
                    .tracking(2)
            }
            
            // Rotating accent dots
            ForEach(0..<8) { index in
                Circle()
                    .fill(currentTheme.accentColor.opacity(0.6))
                    .frame(width: 4, height: 4)
                    .offset(y: -70)
                    .rotationEffect(.degrees(Double(index) * 45))
                    .rotationEffect(.degrees(Double(remainingSeconds) * 6))
                    .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: remainingSeconds)
            }
        }
        .frame(width: 140, height: 140)
    }
    
    // MARK: - Skip Hint
    
    private var skipHint: some View {
        VStack(spacing: 12) {
            Text("Press ESC or click anywhere to skip")
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(currentTheme.secondaryTextColor.opacity(currentTheme.secondaryTextOpacity * 0.8))
            
            Text("(Not recommended—your eyes need this!)")
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(currentTheme.secondaryTextColor.opacity(currentTheme.secondaryTextOpacity * 0.6))
        }
    }
    
    // MARK: - Computed Properties
    
    private var progress: CGFloat {
        CGFloat(remainingSeconds) / CGFloat(duration)
    }
    
    // MARK: - Methods
    
    private func startAnimation() {
        withAnimation(.easeOut(duration: 0.3)) {
            opacity = 1
            scale = 1
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if remainingSeconds > 0 {
                remainingSeconds -= 1
            } else {
                stopTimer()
                onSkip()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - Animated Eye Exercise View

struct AnimatedEyeExerciseView: View {
    @Binding var remainingSeconds: Int
    let totalDuration: Int
    
    @State private var currentDirection: ExerciseDirection = .center
    @State private var exercisePhase: Int = 0
    @State private var dotOffset: CGFloat = 0
    @State private var exerciseTimer: Timer?
    @ObservedObject private var settings = AppSettings.shared
    
    private var currentTheme: ColorTheme {
        settings.breakOverlayTheme
    }
    
    enum ExerciseDirection: String {
        case center = "Look at Center"
        case left = "Look Left"
        case right = "Look Right"
        case up = "Look Up"
        case down = "Look Down"
        case topLeft = "Look Top-Left"
        case topRight = "Look Top-Right"
        case bottomLeft = "Look Bottom-Left"
        case bottomRight = "Look Bottom-Right"
        
        var offset: (x: CGFloat, y: CGFloat) {
            switch self {
            case .center: return (0, 0)
            case .left: return (-250, 0)
            case .right: return (250, 0)
            case .up: return (0, -200)
            case .down: return (0, 200)
            case .topLeft: return (-200, -150)
            case .topRight: return (200, -150)
            case .bottomLeft: return (-200, 150)
            case .bottomRight: return (200, 150)
            }
        }
        
        var color: Color {
            switch self {
            case .center: return .white
            case .left, .right: return .blue
            case .up, .down: return .green
            case .topLeft, .topRight, .bottomLeft, .bottomRight: return .purple
            }
        }
        
        var iconName: String {
            switch self {
            case .center: return "circle.fill"
            case .left: return "arrow.left.circle.fill"
            case .right: return "arrow.right.circle.fill"
            case .up: return "arrow.up.circle.fill"
            case .down: return "arrow.down.circle.fill"
            case .topLeft: return "arrow.up.left.circle.fill"
            case .topRight: return "arrow.up.right.circle.fill"
            case .bottomLeft: return "arrow.down.left.circle.fill"
            case .bottomRight: return "arrow.down.right.circle.fill"
            }
        }
    }
    
    let exercisePattern: [ExerciseDirection] = [
        .center, .left, .center, .right,
        .center, .up, .center, .down,
        .center, .topLeft, .center, .topRight,
        .center, .bottomLeft, .center, .bottomRight
    ]
    
    var body: some View {
        VStack(spacing: 40) {
            // Title
            Text("Eye Exercise")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(currentTheme.textGradient())
                .shadow(color: Color.black.opacity(0.3), radius: 10)
            
            // Optimized: Reduced exercise area size to reduce rendering load
            ZStack {
                // Background guide
                Circle()
                    .strokeBorder(currentTheme.textColor.opacity(0.2), lineWidth: 2)
                    .frame(width: 400, height: 400)
                
                // Horizontal guide line
                Rectangle()
                    .fill(currentTheme.textColor.opacity(0.1))
                    .frame(width: 400, height: 2)
                
                // Vertical guide line
                Rectangle()
                    .fill(currentTheme.textColor.opacity(0.1))
                    .frame(width: 2, height: 400)
                
                // Center reference point
                Circle()
                    .fill(currentTheme.textColor.opacity(0.3))
                    .frame(width: 20, height: 20)
                
                // Optimized: Simplified animated moving dot
                ZStack {
                    // Main dot (removed glow effect to improve performance)
                    Circle()
                        .fill(currentDirection.color)
                        .frame(width: 50, height: 50)
                        .shadow(color: currentDirection.color.opacity(0.5), radius: 10)
                    
                    // Icon indicator
                    Image(systemName: currentDirection.iconName)
                        .font(.system(size: 24))
                        .foregroundColor(currentTheme.textColor)
                }
                .offset(x: currentDirection.offset.x * 0.65, y: currentDirection.offset.y * 0.65)
                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: currentDirection)
            }
            .frame(height: 400)
            
            // Direction instruction
            VStack(spacing: 12) {
                Text(currentDirection.rawValue)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(currentDirection.color)
                    .shadow(color: Color.black.opacity(0.3), radius: 10)
                    .animation(.easeInOut(duration: 0.3), value: currentDirection)
                
                Text("Follow the moving dot with your eyes")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(currentTheme.textColor.opacity(currentTheme.textOpacity * 0.9))
            }
            .padding(20)
            .background(currentTheme.backgroundColor.opacity(0.2))
            .cornerRadius(16)
            
            // Timer countdown
            Text("Break ends in: \(remainingSeconds)s")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundColor(currentTheme.textColor.opacity(currentTheme.textOpacity))
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(currentTheme.backgroundColor.opacity(0.25))
                .cornerRadius(12)
        }
        .onAppear {
            startExerciseSequence()
        }
        .onDisappear {
            exerciseTimer?.invalidate()
        }
    }
    
    private func startExerciseSequence() {
        // Change direction based on user's configured interval
        let interval = TimeInterval(settings.exerciseIntervalSeconds)
        exerciseTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            exercisePhase = (exercisePhase + 1) % exercisePattern.count
            currentDirection = exercisePattern[exercisePhase]
        }
    }
}

// MARK: - Visual Effect View (for blur)

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}

// MARK: - Optimized: Removed AnimatedGradientBackground and FloatingParticlesView to reduce CPU usage
// These heavy animation effects were causing performance issues
