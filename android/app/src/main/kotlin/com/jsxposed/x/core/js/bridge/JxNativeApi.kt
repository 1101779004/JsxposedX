package com.jsxposed.x.core.js.bridge

/**
 * 宿主原生接口定义
 */
interface JxNativeApi {
    fun log(level: String, tag: String, msg: String)
}
