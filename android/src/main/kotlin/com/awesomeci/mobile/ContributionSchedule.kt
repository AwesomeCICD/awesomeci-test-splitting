package com.awesomeci.mobile

/** Per-paycheck savings contribution, capped at an annual limit. */
class ContributionSchedule(private val annualLimit: Money) {
    fun nextContribution(grossPay: Money, rateBasisPoints: Int, contributedThisYear: Money): Money {
        require(rateBasisPoints in 0..10_000) { "rate must be between 0% and 100%" }
        val wanted = grossPay.percentOf(rateBasisPoints)
        val room = annualLimit - contributedThisYear
        return when {
            room.cents <= 0 -> Money.ZERO
            wanted > room -> room
            else -> wanted
        }
    }
}
