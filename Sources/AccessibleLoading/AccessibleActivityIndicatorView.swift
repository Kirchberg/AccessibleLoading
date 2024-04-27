import UIKit
import Foundation

@available(iOS 13.0, *)
public final class AccessibleActivityIndicatorView: UIActivityIndicatorView {

    // MARK: - Public Methods

    public override func startAnimating() {
        super.startAnimating()
        feedbackEngine.start()
    }
    
    public override func stopAnimating() {
        super.stopAnimating()
        feedbackEngine.stop()
    }

    // MARK: - Private Properties

    private let feedbackEngine = AccessibilityHapticEngine()

}
