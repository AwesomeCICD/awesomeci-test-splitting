import MobileCore
import XCTest

final class NotificationThrottleTests: XCTestCase {
    func testShowsUpToTheLimitInAWindow() {
        var throttle = NotificationThrottle(maxPerWindow: 2, window: 1)
        XCTAssertTrue(throttle.shouldShow(now: 0))
        XCTAssertTrue(throttle.shouldShow(now: 0.1))
        XCTAssertFalse(throttle.shouldShow(now: 0.2))
    }

    func testWindowRollsForward() {
        var throttle = NotificationThrottle(maxPerWindow: 1, window: 1)
        XCTAssertTrue(throttle.shouldShow(now: 0))
        XCTAssertFalse(throttle.shouldShow(now: 0.999))
        XCTAssertTrue(throttle.shouldShow(now: 1))
    }
}
