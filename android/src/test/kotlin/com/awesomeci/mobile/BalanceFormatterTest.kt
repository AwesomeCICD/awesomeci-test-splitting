package com.awesomeci.mobile

import org.junit.Assert.assertEquals
import org.junit.Test

class BalanceFormatterTest {
    @Test fun formatsWholeAndFractionalDollars() {
        assertEquals("$0.00", BalanceFormatter.format(Money.ZERO))
        assertEquals("$12,345.67", BalanceFormatter.format(Money(1_234_567)))
    }

    @Test fun groupsMillions() = assertEquals("$1,000,000.05", BalanceFormatter.format(Money(100_000_005)))

    @Test fun formatsNegativeBalances() = assertEquals("-$3.10", BalanceFormatter.format(Money(-310)))

    @Test fun masksIntoBands() {
        assertEquals("Under $1,000", BalanceFormatter.masked(Money.dollars(999)))
        assertEquals("$1,000+", BalanceFormatter.masked(Money.dollars(1_000)))
        assertEquals("$100,000+", BalanceFormatter.masked(Money.dollars(250_000)))
    }
}
