/// An amount in whole cents. Kept as an integer so balances never pick up float rounding.
public struct Money: Equatable, Comparable, Sendable {
    public let cents: Int64

    public init(cents: Int64) { self.cents = cents }

    public static func dollars(_ dollars: Int64) -> Money { Money(cents: dollars * 100) }
    public static let zero = Money(cents: 0)

    public static func + (lhs: Money, rhs: Money) -> Money { Money(cents: lhs.cents + rhs.cents) }
    public static func - (lhs: Money, rhs: Money) -> Money { Money(cents: lhs.cents - rhs.cents) }
    public static func < (lhs: Money, rhs: Money) -> Bool { lhs.cents < rhs.cents }

    public var isNegative: Bool { cents < 0 }

    /// Basis points of this amount, rounded half up (100 bps = 1%).
    public func percentOf(basisPoints: Int64) -> Money {
        Money(cents: (cents * basisPoints + 5_000) / 10_000)
    }
}
