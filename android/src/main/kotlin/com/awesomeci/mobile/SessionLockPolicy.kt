package com.awesomeci.mobile

/** Decides when the app asks for biometrics again after going to the background. */
class SessionLockPolicy(
    private val backgroundGraceMillis: Long = 60_000,
    private val absoluteTimeoutMillis: Long = 15 * 60_000,
) {
    fun requiresUnlock(sessionStartedAt: Long, backgroundedAt: Long?, now: Long): Boolean {
        if (now - sessionStartedAt >= absoluteTimeoutMillis) return true
        if (backgroundedAt == null) return false
        return now - backgroundedAt >= backgroundGraceMillis
    }
}
