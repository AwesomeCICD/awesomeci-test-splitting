/// Caps how many push notifications of one category are shown in a rolling window.
public struct NotificationThrottle {
    let maxPerWindow: Int
    let window: Double
    private var shown: [Double] = []

    public init(maxPerWindow: Int, window: Double) {
        self.maxPerWindow = maxPerWindow
        self.window = window
    }

    public mutating func shouldShow(now: Double) -> Bool {
        shown.removeAll { now - $0 >= window }
        guard shown.count < maxPerWindow else { return false }
        shown.append(now)
        return true
    }
}
