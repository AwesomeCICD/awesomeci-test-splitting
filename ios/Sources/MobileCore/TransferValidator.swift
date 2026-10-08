public enum TransferResult: Equatable, Sendable {
    case ok
    case rejected(String)
}

/// Client-side checks before a transfer request leaves the device.
public struct TransferValidator: Sendable {
    let dailyLimit: Money

    public init(dailyLimit: Money = .dollars(10_000)) { self.dailyLimit = dailyLimit }

    public func validate(amount: Money, available: Money, sentToday: Money) -> TransferResult {
        if amount.cents <= 0 { return .rejected("Enter an amount greater than zero") }
        if amount > available { return .rejected("Amount is more than the available balance") }
        if sentToday + amount > dailyLimit { return .rejected("Daily transfer limit reached") }
        return .ok
    }
}
