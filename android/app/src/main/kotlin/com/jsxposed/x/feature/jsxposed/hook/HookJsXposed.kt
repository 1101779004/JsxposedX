package com.jsxposed.x.feature.jsxposed.hook

import com.jsxposed.x.core.utils.log.LogX
import com.jsxposed.x.feature.hook.AttachHooker
import com.jsxposed.x.feature.hook.LPParam
import com.jsxposed.x .feature.jsxposed.manager.JsXposedManager
import java.util.Collections

object HookJsXposed {

    private const val TAG = "FINDBUGS"
    private val initStarted = Collections.synchronizedSet(mutableSetOf<String>())
    private val setupStarted = Collections.synchronizedSet(mutableSetOf<String>())

    private fun trace(message: String) {
        LogX.d(TAG, message)
    }

    fun setup(lpparam: LPParam) {
        try {
            val processKey = "${lpparam.packageName}|${lpparam.processName}"
            trace("HookJsXposed.setup start package=${lpparam.packageName} process=${lpparam.processName} thread=${Thread.currentThread().name}")
            if (!setupStarted.add(processKey)) {
                trace("HookJsXposed.setup skip duplicate package=${lpparam.packageName} process=${lpparam.processName}")
                return
            }

            AttachHooker.registerAfterAttach("HookJsXposed:${lpparam.packageName}:${lpparam.processName}") { context ->
                trace("HookJsXposed.afterAttach callback enter package=${lpparam.packageName} process=${lpparam.processName} thread=${Thread.currentThread().name} context=${context.javaClass.name}")

                if (!initStarted.add(processKey)) {
                    trace("HookJsXposed.init already started package=${lpparam.packageName} process=${lpparam.processName}")
                    return@registerAfterAttach
                }

                Thread {
                    val start = System.currentTimeMillis()
                    try {
                        trace("HookJsXposed.async init start package=${lpparam.packageName} process=${lpparam.processName} worker=${Thread.currentThread().name}")
                        JsXposedManager.init(context, lpparam)
                        trace("HookJsXposed.async init finish package=${lpparam.packageName} process=${lpparam.processName} cost=${System.currentTimeMillis() - start}ms")
                    } catch (t: Throwable) {
                        initStarted.remove(processKey)
                        LogX.e(TAG, "HookJsXposed.async init failed: ${t.message}")
                    }
                }.apply {
                    name = "JsXposedInit-${lpparam.packageName}"
                    isDaemon = true
                    start()
                }

                trace("HookJsXposed.afterAttach callback return package=${lpparam.packageName} process=${lpparam.processName}")
            }

            trace("HookJsXposed.setup callback registered package=${lpparam.packageName} process=${lpparam.processName}")
        } catch (e: Throwable) {
            LogX.e(TAG, "HookJsXposed.setup failed: ${e.message}")
        }
    }
}
