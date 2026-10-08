package com.awesomeci.mobile

/** Caps how many push notifications of one category are shown in a rolling window. */
class NotificationThrottle(private val maxPerWindow: Int, private val windowMillis: Long) {
    private val shown = ArrayDeque<Long>()

    fun shouldShow(now: Long): Boolean {
        while (shown.isNotEmpty() && now - shown.first() >= windowMillis) shown.removeFirst()
        if (shown.size >= maxPerWindow) return false
        shown.addLast(now)
        return true
    }
}
