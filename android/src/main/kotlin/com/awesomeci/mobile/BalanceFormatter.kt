package com.awesomeci.mobile

/** Formats balances for the account card, e.g. "$12,345.67" or "-$3.10". */
object BalanceFormatter {
    fun format(amount: Money): String {
        val abs = kotlin.math.abs(amount.cents)
        val dollars = groupThousands(abs / 100)
        val cents = (abs % 100).toString().padStart(2, '0')
        val sign = if (amount.isNegative) "-" else ""
        return "$sign$$dollars.$cents"
    }

    /** Masked form for the lock screen widget: shows only the dollar magnitude band. */
    fun masked(amount: Money): String = when {
        amount.cents < 100_000 -> "Under $1,000"
        amount.cents < 10_000_000 -> "$1,000+"
        else -> "$100,000+"
    }

    private fun groupThousands(value: Long): String =
        value.toString().reversed().chunked(3).joinToString(",").reversed()
}
