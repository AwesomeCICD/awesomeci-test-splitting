package com.awesomeci.mobile

import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class NotificationThrottleTest {
    @Test fun showsUpToTheLimitInAWindow() {
        val throttle = NotificationThrottle(maxPerWindow = 2, windowMillis = 1_000)
        assertTrue(throttle.shouldShow(0))
        assertTrue(throttle.shouldShow(100))
        assertFalse(throttle.shouldShow(200))
    }

    @Test fun windowRollsForward() {
        val throttle = NotificationThrottle(maxPerWindow = 1, windowMillis = 1_000)
        assertTrue(throttle.shouldShow(0))
        assertFalse(throttle.shouldShow(999))
        assertTrue(throttle.shouldShow(1_000))
    }
}
