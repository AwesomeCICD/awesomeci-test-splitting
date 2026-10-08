/// Formats balances for the account card, e.g. "$12,345.67" or "-$3.10".
public enum BalanceFormatter {
    public static func format(_ amount: Money) -> String {
        let abs = amount.cents.magnitude
        let dollars = groupThousands(abs / 100)
        let cents = abs % 100 < 10 ? "0\(abs % 100)" : "\(abs % 100)"
        return "\(amount.isNegative ? "-" : "")$\(dollars).\(cents)"
    }

    /// Masked form for the lock screen widget: shows only the dollar magnitude band.
    public static func masked(_ amount: Money) -> String {
        switch amount.cents {
        case ..<100_000: return "Under $1,000"
        case ..<10_000_000: return "$1,000+"
        default: return "$100,000+"
        }
    }

    private static func groupThousands(_ value: UInt64) -> String {
        let digits = Array(String(value))
        var out = ""
        for (index, digit) in digits.enumerated() {
            if index > 0 && (digits.count - index) % 3 == 0 { out.append(",") }
            out.append(digit)
        }
        return out
    }
}
