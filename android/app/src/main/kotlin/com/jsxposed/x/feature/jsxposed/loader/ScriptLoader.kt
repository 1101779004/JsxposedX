package com.jsxposed.x.feature.jsxposed.loader

import android.content.Context
import android.net.Uri
import com.jsxposed.x.core.utils.log.LogX
import com.whl.quickjs.wrapper.QuickJSContext

/**
 * JS 脚本加载器 (客户端)
 * 负责跨 Android 沙箱，通过 content:// 协议向主应用拉取被选中的脚本代码并投递进 JS 引擎
 */
class ScriptLoader(
    private val context: Context,
    private val qjs: QuickJSContext,
    private val packageName: String
) {
    private val TAG = "FINDBUGS"
    
    // 查询主应用的 Provider Authority 定位
    private val PROVIDER_URI = "content://com.jsxposed.x.scripts"

    fun loadAndExecute() {
        try {
            val loadStart = System.currentTimeMillis()
            val uri = Uri.parse("$PROVIDER_URI/$packageName")
            
            LogX.d(TAG, "正在向宿主请求跨沙箱读取 ($packageName) 的脚本...")
            
            // 发起查询，宿主侧 JsxposedProvider 只会返回已开启的脚本的 [文件名, 源码]
            LogX.d(TAG, "ScriptLoader.query-start package=$packageName thread=${Thread.currentThread().name} uri=$uri")
            val queryStart = System.currentTimeMillis()
            context.contentResolver.query(
                uri,
                null, 
                null, 
                null, 
                null
            )?.use { cursor ->
                LogX.d(TAG, "ScriptLoader.query-finish package=$packageName cost=${System.currentTimeMillis() - queryStart}ms count=${cursor.count}")
                if (cursor.count == 0) {
                    LogX.d(TAG, "宿主未返回任何需要执行的 JS 脚本")
                    return
                }

                while (cursor.moveToNext()) {
                    val scriptNameIndex = cursor.getColumnIndex("script_name")
                    val sourceCodeIndex = cursor.getColumnIndex("source_code")
                    
                    if (scriptNameIndex != -1 && sourceCodeIndex != -1) {
                        val scriptName = cursor.getString(scriptNameIndex)
                        val sourceCode = cursor.getString(sourceCodeIndex)
                        
                        LogX.d(TAG, "ScriptLoader.execute-start package=$packageName script=$scriptName size=${sourceCode.length}")
                        val executeStart = System.currentTimeMillis()
                        executeScript(scriptName, sourceCode)
                        LogX.d(TAG, "ScriptLoader.execute-finish package=$packageName script=$scriptName cost=${System.currentTimeMillis() - executeStart}ms")
                    }
                }
                LogX.d(TAG, "ScriptLoader.loadAndExecute finish package=$packageName cost=${System.currentTimeMillis() - loadStart}ms")
            } ?: run {
                LogX.e(TAG, "跨沙箱查询 Provider 失败: cursor 为 null")
            }
            
        } catch (e: Exception) {
            LogX.e(TAG, "执行跨进程脚本拉取期间异常崩盘: ${e.message}")
        }
    }

    private fun executeScript(scriptName: String, sourceCode: String) {
        try {
            if (sourceCode.isEmpty()) {
                LogX.e(TAG, "拦截到的脚本内容为空: $scriptName")
                return
            }

            // 提交到 QuickJS 引擎执行
            qjs.evaluate(sourceCode, scriptName)
            LogX.d(TAG, "[$packageName] 脚本执行成功: $scriptName")
            
        } catch (e: Exception) {
            LogX.e(TAG, "[$packageName] 脚本语法错误或者执行崩溃 ($scriptName): ${e.message}")
        }
    }
}
