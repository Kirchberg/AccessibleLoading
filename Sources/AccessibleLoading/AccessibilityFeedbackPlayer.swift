import Foundation
import CoreHaptics

@available(iOS 13.0, *)
final class AccessibilityFeedbackPlayer {

    // MARK: - Internal Init

    init?() {
        guard supportsHapticFeedback else {
            return nil
        }

        engine = try? CHHapticEngine()
        try? engine?.start()

        engine?.stoppedHandler = { [weak self] _ in
            self?.needReset = true
        }

        engine?.resetHandler = { [weak self] in
            self?.needReset = true
        }
    }

    // MARK: - Internal Methods

    func play(pattern: CHHapticPattern?) {
        guard let pattern else {
            return
        }
        resetIfNeeded()
        player = try? engine?.makePlayer(with: pattern)
        try? player?.start(atTime: CHHapticTimeImmediate)
    }

    func stop(afterStop: (() -> Void)?) {
        try? player?.stop(atTime: CHHapticTimeImmediate)
        afterStop?()
        player = nil
    }

    // MARK: - Private Properties

    private var engine: CHHapticEngine?
    private var player: CHHapticPatternPlayer?
    private var needReset = false

    private var supportsHapticFeedback: Bool {
        return CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }

    // MARK: - Private Methods

    private func resetIfNeeded() {
        guard needReset else { return }
        defer { needReset = false }
        try? engine?.start()
    }

}
