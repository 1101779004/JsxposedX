package com.jsxposed.x.feature.jsxposed.bridge

import com.whl.quickjs.wrapper.QuickJSContext
import de.robv.android.xposed.XposedBridge

/**
 * Xposed 官方日志能力桥接
 */
class JxLogBridge(private val qjs: QuickJSContext) {

    fun log(message: String): Any? {
        XposedBridge.log(message)
        return null
    }

    fun logException(message: String): Any? {
        XposedBridge.log(Throwable("JxLogException: $message"))
        return null
    }
}
