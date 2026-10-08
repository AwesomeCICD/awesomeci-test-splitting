package com.awesomeci.mobile

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class MoneyTest {
    @Test fun addsAndSubtractsInCents() {
        assertEquals(Money(1_050), Money(1_000) + Money(50))
        assertEquals(Money(-25), Money(25) - Money(50))
    }

    @Test fun dollarsConvertToCents() = assertEquals(Money(12_300), Money.dollars(123))

    @Test fun percentOfRoundsHalfUp() {
        assertEquals(Money(6), Money(100).percentOf(550))
        assertEquals(Money(5), Money(100).percentOf(549))
    }

    @Test fun comparesByCents() {
        assertTrue(Money(2) > Money(1))
        assertFalse(Money(1).isNegative)
        assertTrue(Money(-1).isNegative)
    }
}
