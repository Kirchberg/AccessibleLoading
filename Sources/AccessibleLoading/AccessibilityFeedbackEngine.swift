import CoreHaptics
import Foundation
import UIKit

@available(iOS 13.0, *)
final class AccessibilityFeedbackEngine {

    // MARK: - Internal Methods

    func start(duration: TimeInterval) -> CHHapticPattern? {
        guard UIAccessibility.isVoiceOverRunning else {
            return nil
        }
        let events = makeEvents(duration: duration)
        return try? CHHapticPattern(events: events, parameterCurves: [])
    }

    func stop() -> CHHapticPattern? {
        guard UIAccessibility.isVoiceOverRunning else {
            return nil
        }
        let event = makeStopEvent()
        return try? CHHapticPattern(events: event, parameterCurves: [])
    }

    // MARK: - Private Types

    private struct Event {
        let intensity: Float
        let sharpness: Float
    }

    private enum Constants {
        static let eventsPerSecond = 1
        static let standardEvent = Event(intensity: 0.4, sharpness: 0.5)
        static let penultimateEvent = Event(intensity: 0.5, sharpness: 0.5)
        static let finalEvent = Event(intensity: 0.75, sharpness: 0)
        static let delayToFinalEvent: TimeInterval = 0.2
    }

    // MARK: - Private Methods

    private func makeEvents(duration: TimeInterval) -> [CHHapticEvent] {
        let interval = 1 / TimeInterval(Constants.eventsPerSecond)
        return (0..<Int(duration) * Constants.eventsPerSecond).map { index in
            let time = TimeInterval(index) * interval
            return makeLoadingEvent(time: time)
        }
    }

    private func makeLoadingEvent(time: TimeInterval) -> CHHapticEvent {
        return makeEvent(with: Constants.standardEvent, time: time)
    }

    private func makeStopEvent() -> [CHHapticEvent] {
        let beforeFinalEvent = makeEvent(with: Constants.penultimateEvent, time: 0)
        let finalEvent = makeEvent(with: Constants.finalEvent, time: Constants.delayToFinalEvent)
        return [beforeFinalEvent, finalEvent]
    }

    private func makeEvent(with event: Event, time: TimeInterval) -> CHHapticEvent {
        let intensityParameter = CHHapticEventParameter(parameterID: .hapticIntensity, value: event.intensity)
        let sharpnessParameter = CHHapticEventParameter(parameterID: .hapticSharpness, value: event.sharpness)
        return CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [intensityParameter, sharpnessParameter],
            relativeTime: time
        )
    }

}
