package com.jsxposed.x

import android.app.Application
import com.jsxposed.x.core.bridge.lsposed_native.LSPosed
import com.jsxposed.x.core.utils.log.LogX

class App : Application() {
    override fun onCreate() {
        super.onCreate()
        LogX.d("FixHookError", "App.onCreate")
        LSPosed.initService(this)
        LogX.d("FixHookError", "App.onCreate initService done")
    }
}
