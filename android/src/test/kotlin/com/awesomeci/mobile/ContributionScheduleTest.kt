package com.awesomeci.mobile

import org.junit.Assert.assertEquals
import org.junit.Test

class ContributionScheduleTest {
    private val schedule = ContributionSchedule(annualLimit = Money.dollars(23_000))

    @Test fun takesTheRateOfGrossPay() =
        assertEquals(Money.dollars(300), schedule.nextContribution(Money.dollars(5_000), 600, Money.ZERO))

    @Test fun capsAtTheRemainingRoom() =
        assertEquals(Money.dollars(100), schedule.nextContribution(Money.dollars(5_000), 600, Money.dollars(22_900)))

    @Test fun contributesNothingOnceTheLimitIsMet() =
        assertEquals(Money.ZERO, schedule.nextContribution(Money.dollars(5_000), 600, Money.dollars(23_000)))

    @Test(expected = IllegalArgumentException::class)
    fun rejectsRatesOverOneHundredPercent() {
        schedule.nextContribution(Money.dollars(5_000), 10_001, Money.ZERO)
    }
}
