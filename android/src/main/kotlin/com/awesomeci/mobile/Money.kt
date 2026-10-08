package com.awesomeci.mobile

/** An amount in whole cents. Kept as a Long so balances never pick up float rounding. */
@JvmInline
value class Money(val cents: Long) : Comparable<Money> {
    operator fun plus(other: Money) = Money(cents + other.cents)
    operator fun minus(other: Money) = Money(cents - other.cents)
    override fun compareTo(other: Money) = cents.compareTo(other.cents)

    val isNegative: Boolean get() = cents < 0

    /** Basis points of this amount, rounded half up (100 bps = 1%). */
    fun percentOf(basisPoints: Int): Money = Money((cents * basisPoints + 5_000) / 10_000)

    companion object {
        val ZERO = Money(0)
        fun dollars(dollars: Long) = Money(dollars * 100)
    }
}
