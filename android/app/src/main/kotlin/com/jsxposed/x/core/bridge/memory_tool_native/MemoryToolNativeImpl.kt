package com.jsxposed.x.core.bridge.memory_tool_native

import android.content.Context
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class MemoryToolNativeImpl(val context: Context) : MemoryToolNative {
    private val memoryTool = MemoryTool(context)
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.IO)

    override fun getPid(packageName: String, callback: (Result<Long>) -> Unit) {
        scope.launch {
            try {
                val result = memoryTool.getPid(packageName)
                withContext(Dispatchers.Main) {
                    callback(Result.success(result))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }

    override fun getProcessInfo(offset: Long, limit: Long, callback: (Result<List<ProcessInfo>>) -> Unit) {
        scope.launch {
            try {
                val result = memoryTool.getProcessInfo(offset.toInt(), limit.toInt())
                withContext(Dispatchers.Main) {
                    callback(Result.success(result))
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    callback(Result.failure(e))
                }
            }
        }
    }
}
