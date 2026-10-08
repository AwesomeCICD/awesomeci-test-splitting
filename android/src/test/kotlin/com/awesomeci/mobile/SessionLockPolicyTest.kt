package com.awesomeci.mobile

import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class SessionLockPolicyTest {
    private val policy = SessionLockPolicy(backgroundGraceMillis = 60_000, absoluteTimeoutMillis = 900_000)

    @Test fun foregroundSessionStaysUnlocked() =
        assertFalse(policy.requiresUnlock(sessionStartedAt = 0, backgroundedAt = null, now = 300_000))

    @Test fun shortTripToTheBackgroundIsFine() =
        assertFalse(policy.requiresUnlock(sessionStartedAt = 0, backgroundedAt = 100_000, now = 130_000))

    @Test fun longBackgroundRequiresUnlock() =
        assertTrue(policy.requiresUnlock(sessionStartedAt = 0, backgroundedAt = 100_000, now = 160_000))

    @Test fun absoluteTimeoutAlwaysWins() =
        assertTrue(policy.requiresUnlock(sessionStartedAt = 0, backgroundedAt = null, now = 900_000))
}
