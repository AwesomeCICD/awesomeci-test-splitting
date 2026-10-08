import MobileCore
import XCTest

final class TransferValidatorTests: XCTestCase {
    private let validator = TransferValidator(dailyLimit: .dollars(500))

    func testAcceptsAnAmountWithinBalanceAndLimit() {
        XCTAssertEqual(validator.validate(amount: .dollars(100), available: .dollars(200), sentToday: .zero), .ok)
    }

    func testRejectsZero() {
        XCTAssertEqual(
            validator.validate(amount: .zero, available: .dollars(200), sentToday: .zero),
            .rejected("Enter an amount greater than zero"))
    }

    func testRejectsMoreThanAvailable() {
        XCTAssertEqual(
            validator.validate(amount: .dollars(300), available: .dollars(200), sentToday: .zero),
            .rejected("Amount is more than the available balance"))
    }

    func testRejectsOverTheDailyLimit() {
        XCTAssertEqual(
            validator.validate(amount: .dollars(150), available: .dollars(1_000), sentToday: .dollars(400)),
            .rejected("Daily transfer limit reached"))
    }
}
