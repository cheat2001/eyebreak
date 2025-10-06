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
    
    init(duration: Int, style: ScreenBlurManager.OverlayStyle, onSkip: @escaping () -> Void) {
        self.duration = duration
        self.style = style
        self.onSkip = onSkip
        _remainingSeconds = State(initialValue: duration)
    }
    
    var body: some View {
        ZStack {
            // Animated gradient background
            AnimatedGradientBackground()
                .ignoresSafeArea()
            
            // Background blur
            VisualEffectView(material: .hudWindow, blendingMode: .behindWindow)
                .ignoresSafeArea()
                .opacity(0.8)
            
            // Dimming overlay with subtle animation
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            // Floating particles effect
            FloatingParticlesView()
                .ignoresSafeArea()
            
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
            // Animated icon with glow effect
            ZStack {
                // Outer glow rings
                ForEach(0..<3) { index in
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.cyan.opacity(0.3), .blue.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                        .frame(width: CGFloat(120 + index * 30), height: CGFloat(120 + index * 30))
                        .scaleEffect(opacity > 0.5 ? 1.2 : 1.0)
                        .opacity(0.4 - Double(index) * 0.1)
                        .animation(
                            .easeInOut(duration: 2.0 + Double(index) * 0.5)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.2),
                            value: opacity
                        )
                }
                
                // Main icon with gradient
                Image(systemName: "eye.slash.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.cyan, .blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .cyan.opacity(0.5), radius: 20)
                    .shadow(color: .blue.opacity(0.3), radius: 40)
                    .scaleEffect(opacity > 0.5 ? 1.0 : 0.9)
                    .animation(
                        .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                        value: opacity
                    )
            }
            
            // Title with gradient
            Text("Time for a Break")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, .white.opacity(0.9), .cyan.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .cyan.opacity(0.3), radius: 10)
                .shadow(color: .black.opacity(0.3), radius: 10)
                .accessibilityFocused($isMessageFocused)
            
            // Instruction with subtle animation
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "arrow.left.and.right")
                        .font(.title2)
                        .foregroundColor(.cyan)
                    
                    Text("Look at something 20 feet away")
                        .font(.system(size: 24, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.95))
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.caption)
                        .foregroundColor(.yellow)
                    Text("Give your eyes a rest")
                        .font(.callout)
                        .foregroundColor(.white.opacity(0.7))
                    Image(systemName: "sparkles")
                        .font(.caption)
                        .foregroundColor(.yellow)
                }
            }
            .multilineTextAlignment(.center)
            .shadow(color: .black.opacity(0.3), radius: 5)
            
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
                        colors: [.cyan.opacity(0.3), .blue.opacity(0.3), .purple.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
                .frame(width: 140, height: 140)
            
            // Background circle with glow
            Circle()
                .fill(Color.white.opacity(0.05))
                .frame(width: 130, height: 130)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 8)
                )
                .shadow(color: .cyan.opacity(0.3), radius: 20)
            
            // Progress circle with gradient
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        colors: [.cyan, .blue, .purple, .pink, .cyan],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: 130, height: 130)
                .rotationEffect(.degrees(-90))
                .shadow(color: .cyan.opacity(0.5), radius: 10)
                .animation(.linear(duration: 1), value: progress)
            
            // Countdown text with enhanced styling
            VStack(spacing: 4) {
                Text("\(remainingSeconds)")
                    .font(.system(size: 52, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .cyan.opacity(0.9)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: .cyan.opacity(0.5), radius: 10)
                    .contentTransition(.numericText())
                
                Text("seconds")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
                    .textCase(.uppercase)
                    .tracking(2)
            }
            
            // Rotating accent dots
            ForEach(0..<8) { index in
                Circle()
                    .fill(Color.cyan.opacity(0.6))
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
                .foregroundColor(.white.opacity(0.6))
            
            Text("(Not recommended—your eyes need this!)")
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(.white.opacity(0.4))
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
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 10)
            
            // Exercise area with moving indicator
            ZStack {
                // Background guide
                Circle()
                    .strokeBorder(Color.white.opacity(0.2), lineWidth: 2)
                    .frame(width: 600, height: 600)
                
                // Horizontal guide line
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 600, height: 2)
                
                // Vertical guide line
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 2, height: 600)
                
                // Center reference point
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 20, height: 20)
                
                // Animated moving dot
                ZStack {
                    // Glow effect
                    Circle()
                        .fill(currentDirection.color.opacity(0.3))
                        .frame(width: 80, height: 80)
                        .blur(radius: 20)
                    
                    // Main dot
                    Circle()
                        .fill(currentDirection.color)
                        .frame(width: 50, height: 50)
                        .shadow(color: currentDirection.color.opacity(0.5), radius: 20)
                    
                    // Icon indicator
                    Image(systemName: currentDirection.iconName)
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                }
                .offset(x: currentDirection.offset.x, y: currentDirection.offset.y)
                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: currentDirection)
            }
            .frame(height: 600)
            
            // Direction instruction
            VStack(spacing: 12) {
                Text(currentDirection.rawValue)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(currentDirection.color)
                    .shadow(color: .black.opacity(0.3), radius: 10)
                    .animation(.easeInOut(duration: 0.3), value: currentDirection)
                
                Text("Follow the moving dot with your eyes")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(20)
            .background(Color.white.opacity(0.1))
            .cornerRadius(16)
            
            // Timer countdown
            Text("Break ends in: \(remainingSeconds)s")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.white.opacity(0.15))
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

// MARK: - Animated Gradient Background

struct AnimatedGradientBackground: View {
    @State private var animateGradient = false
    
    var body: some View {
        LinearGradient(
            colors: animateGradient ? 
                [.blue.opacity(0.3), .purple.opacity(0.3), .cyan.opacity(0.3)] :
                [.cyan.opacity(0.3), .blue.opacity(0.3), .purple.opacity(0.3)],
            startPoint: animateGradient ? .topLeading : .bottomLeading,
            endPoint: animateGradient ? .bottomTrailing : .topTrailing
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 5.0).repeatForever(autoreverses: true)) {
                animateGradient = true
            }
        }
    }
}

// MARK: - Floating Particles Effect

struct FloatingParticlesView: View {
    @State private var particles: [Particle] = []
    
    struct Particle: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var size: CGFloat
        var opacity: Double
        var delay: Double
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(Color.cyan.opacity(particle.opacity))
                        .frame(width: particle.size, height: particle.size)
                        .position(x: particle.x, y: particle.y)
                        .blur(radius: 2)
                        .animation(
                            .easeInOut(duration: 3.0)
                            .repeatForever(autoreverses: true)
                            .delay(particle.delay),
                            value: particle.y
                        )
                }
            }
            .onAppear {
                createParticles(in: geometry.size)
            }
        }
    }
    
    private func createParticles(in size: CGSize) {
        particles = (0..<15).map { index in
            Particle(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height),
                size: CGFloat.random(in: 4...12),
                opacity: Double.random(in: 0.1...0.3),
                delay: Double(index) * 0.2
            )
        }
    }
}
