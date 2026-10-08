package com.awesomeci.mobile

sealed interface TransferResult {
    data object Ok : TransferResult
    data class Rejected(val reason: String) : TransferResult
}

/** Client-side checks before a transfer request leaves the device. */
class TransferValidator(private val dailyLimit: Money = Money.dollars(10_000)) {
    fun validate(amount: Money, available: Money, sentToday: Money): TransferResult = when {
        amount.cents <= 0 -> TransferResult.Rejected("Enter an amount greater than zero")
        amount > available -> TransferResult.Rejected("Amount is more than the available balance")
        sentToday + amount > dailyLimit -> TransferResult.Rejected("Daily transfer limit reached")
        else -> TransferResult.Ok
    }
}
