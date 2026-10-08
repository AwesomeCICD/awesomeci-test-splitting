package com.awesomeci.mobile

import org.junit.Assert.assertEquals
import org.junit.Test

class TransferValidatorTest {
    private val validator = TransferValidator(dailyLimit = Money.dollars(500))

    @Test fun acceptsAnAmountWithinBalanceAndLimit() =
        assertEquals(TransferResult.Ok, validator.validate(Money.dollars(100), Money.dollars(200), Money.ZERO))

    @Test fun rejectsZero() =
        assertEquals(
            TransferResult.Rejected("Enter an amount greater than zero"),
            validator.validate(Money.ZERO, Money.dollars(200), Money.ZERO),
        )

    @Test fun rejectsMoreThanAvailable() =
        assertEquals(
            TransferResult.Rejected("Amount is more than the available balance"),
            validator.validate(Money.dollars(300), Money.dollars(200), Money.ZERO),
        )

    @Test fun rejectsOverTheDailyLimit() =
        assertEquals(
            TransferResult.Rejected("Daily transfer limit reached"),
            validator.validate(Money.dollars(150), Money.dollars(1_000), Money.dollars(400)),
        )
}
