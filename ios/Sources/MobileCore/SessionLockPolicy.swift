/// Decides when the app asks for Face ID again after going to the background.
public struct SessionLockPolicy: Sendable {
    let backgroundGrace: Double
    let absoluteTimeout: Double

    public init(backgroundGrace: Double = 60, absoluteTimeout: Double = 15 * 60) {
        self.backgroundGrace = backgroundGrace
        self.absoluteTimeout = absoluteTimeout
    }

    public func requiresUnlock(sessionStartedAt: Double, backgroundedAt: Double?, now: Double) -> Bool {
        if now - sessionStartedAt >= absoluteTimeout { return true }
        guard let backgroundedAt else { return false }
        return now - backgroundedAt >= backgroundGrace
    }
}
