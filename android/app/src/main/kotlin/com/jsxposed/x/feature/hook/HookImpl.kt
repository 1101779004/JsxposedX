package com.jsxposed.x.feature.hook

import android.content.Context

interface HookImpl {


    fun onAttach(context: Context)

    fun create()
}