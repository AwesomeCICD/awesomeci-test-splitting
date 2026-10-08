import MobileCore
import XCTest

final class SessionLockPolicyTests: XCTestCase {
    private let policy = SessionLockPolicy(backgroundGrace: 60, absoluteTimeout: 900)

    func testForegroundSessionStaysUnlocked() {
        XCTAssertFalse(policy.requiresUnlock(sessionStartedAt: 0, backgroundedAt: nil, now: 300))
    }

    func testShortTripToTheBackgroundIsFine() {
        XCTAssertFalse(policy.requiresUnlock(sessionStartedAt: 0, backgroundedAt: 100, now: 130))
    }

    func testLongBackgroundRequiresUnlock() {
        XCTAssertTrue(policy.requiresUnlock(sessionStartedAt: 0, backgroundedAt: 100, now: 160))
    }

    func testAbsoluteTimeoutAlwaysWins() {
        XCTAssertTrue(policy.requiresUnlock(sessionStartedAt: 0, backgroundedAt: nil, now: 900))
    }
}
