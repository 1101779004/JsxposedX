package com.jsxposed.x.feature.provider

import android.content.ContentProvider
import android.content.ContentValues
import android.database.Cursor
import android.database.MatrixCursor
import android.net.Uri
import com.jsxposed.x.core.utils.log.LogX
import com.jsxposed.x.core.bridge.pinia_native.Pinia
import com.jsxposed.x.core.bridge.project_native.Project

/**
 * JS 引擎专属 ContentProvider
 * 负责跨越 Android 沙箱，将存在于宿主 /data/user/0 内部的 JS 代码，
 * 安全地投递给被挂载的目标 App 进程。
 */
class JsxposedProvider : ContentProvider() {

    companion object {
        const val AUTHORITY = "com.jsxposed.x.scripts"
        private const val TAG = "JsxposedProvider"
        
        // Cursor 的列定义
        const val COLUMN_SCRIPT_NAME = "script_name"
        const val COLUMN_SOURCE_CODE = "source_code"
    }

    private lateinit var project: Project
    private lateinit var pinia: Pinia

    override fun onCreate(): Boolean {
        // ContentProvider 在宿主 App 启动时被实例化，此时 Context 一定存在
        context?.let {
            project = Project(it)
            pinia = Pinia(it)
            return true
        }
        return false
    }

    /**
     * 目标 App 的 Hook 端会向 content://com.jsxposed.x.scripts/{packageName} 发起查询
     */
    override fun query(
        uri: Uri,
        projection: Array<out String>?,
        selection: String?,
        selectionArgs: Array<out String>?,
        sortOrder: String?
    ): Cursor? {
        val packageName = uri.lastPathSegment ?: return null
        
//        LogX.d(TAG, "收到来自进程对 $packageName 的拦截脚本查询请求")

        val cursor = MatrixCursor(arrayOf(COLUMN_SCRIPT_NAME, COLUMN_SOURCE_CODE))

        try {
            // 1. 读取该 App 下所有声明的 JS 脚本 (Shell 返回的可能是绝对路径)
            val scriptPaths = project.getJsScripts(packageName)
            if (scriptPaths.isEmpty()) {
                LogX.d(TAG, "目标应用 $packageName 下没有配置任何脚本")
                return cursor
            }

            // 2. 遍历并利用 Pinia 校验 Flutter UI 中的开关状态
            scriptPaths.forEach { path ->
                // 从绝对路径中提取文件名称，例如 `[traditional]来来来.js`
                val scriptName = java.io.File(path).name
                
                // 注意：Flutter 端在保存开关状态时，是以“绝对路径”作为后缀的！
                // 比如 key 是 xposed_check_status_com.xxx_/data/user/0/.../[traditional]来来来.js
                val isEnabled = pinia.getValue("pinia", "xposed_check_status_${packageName}_${path}", false)
                
                if (isEnabled) {
                    // readJsScript 需要的是相对路径(文件名)，否则会拼接导致重复路径报错
                    val sourceCode = project.readJsScript(packageName, scriptName)
                    
                    if (sourceCode.isNotEmpty() && !sourceCode.startsWith("cat: ")) {
                        // 3. 原文装载进 Cursor 列中返回
                        cursor.addRow(arrayOf(scriptName, sourceCode))
                        LogX.d(TAG, "脚本 [$scriptName] 已允许下发")
                    }
                }
            }
        } catch (e: Throwable) {
            LogX.e(TAG, "查询分发期间发生异常: ${e.message}", e)
        }

        return cursor
    }

    // --- 下面这些针对跨进程修改的都是拒绝方法，因为本通道仅供查询只读 ---
    override fun getType(uri: Uri): String? = null
    override fun insert(uri: Uri, values: ContentValues?): Uri? = null
    override fun delete(uri: Uri, selection: String?, selectionArgs: Array<out String>?): Int = 0
    override fun update(uri: Uri, values: ContentValues?, selection: String?, selectionArgs: Array<out String>?): Int = 0
}
