import UIKit
import Foundation

@available(iOS 13.0, *)
public final class AccessibilityHapticEngine {

    // MARK: - Public Init

    public init() {}

    // MARK: - Public Methods

    public func start(duration: TimeInterval = TimeInterval(120)) {
        Task { @MainActor [weak self] in
            guard let self else {
                return
            }
            guard !isStarted else { return }
            isStarted = true
            try? await Task.sleep(nanoseconds: UInt64(0.5 * 1_000_000_000))
            guard let pattern = feedbackEngine.start(duration: duration) else { return }
            feedbackPlayer?.play(pattern: pattern)
        }
    }

    public func stop() {
        feedbackPlayer?.stop { [weak self] in
            self?.isStarted = false
            guard let pattern = self?.feedbackEngine.stop() else { return }
            self?.feedbackPlayer?.play(pattern: pattern)
        }
    }

    // MARK: - Private Properties

    private var isStarted = false
    private lazy var feedbackEngine = AccessibilityFeedbackEngine()
    private lazy var feedbackPlayer = AccessibilityFeedbackPlayer()

}
