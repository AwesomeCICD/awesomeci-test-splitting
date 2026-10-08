import MobileCore
import XCTest

final class ContributionScheduleTests: XCTestCase {
    private let schedule = ContributionSchedule(annualLimit: .dollars(23_000))

    func testTakesTheRateOfGrossPay() throws {
        XCTAssertEqual(try schedule.nextContribution(grossPay: .dollars(5_000), rateBasisPoints: 600, contributedThisYear: .zero), .dollars(300))
    }

    func testCapsAtTheRemainingRoom() throws {
        XCTAssertEqual(try schedule.nextContribution(grossPay: .dollars(5_000), rateBasisPoints: 600, contributedThisYear: .dollars(22_900)), .dollars(100))
    }

    func testContributesNothingOnceTheLimitIsMet() throws {
        XCTAssertEqual(try schedule.nextContribution(grossPay: .dollars(5_000), rateBasisPoints: 600, contributedThisYear: .dollars(23_000)), .zero)
    }

    func testRejectsRatesOverOneHundredPercent() {
        XCTAssertThrowsError(try schedule.nextContribution(grossPay: .dollars(5_000), rateBasisPoints: 10_001, contributedThisYear: .zero))
    }
}
