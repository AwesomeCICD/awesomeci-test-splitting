public enum ContributionError: Error, Equatable {
    case rateOutOfRange
}

/// Per-paycheck savings contribution, capped at an annual limit.
public struct ContributionSchedule: Sendable {
    let annualLimit: Money

    public init(annualLimit: Money) { self.annualLimit = annualLimit }

    public func nextContribution(grossPay: Money, rateBasisPoints: Int64, contributedThisYear: Money) throws -> Money {
        guard (0...10_000).contains(rateBasisPoints) else { throw ContributionError.rateOutOfRange }
        let wanted = grossPay.percentOf(basisPoints: rateBasisPoints)
        let room = annualLimit - contributedThisYear
        if room.cents <= 0 { return .zero }
        return wanted > room ? room : wanted
    }
}
