package com.jsxposed.x.core.bridge.so_analysis_native

import android.content.Context
import java.util.zip.ZipFile

data class SoElfHeaderJni(
    val magic: String,
    val classType: String,
    val dataEncoding: String,
    val osAbi: String,
    val fileType: String,
    val machine: String,
    val entryPoint: Long,
    val programHeaderOffset: Long,
    val sectionHeaderOffset: Long,
    val flags: Long,
    val programHeaderCount: Long,
    val sectionHeaderCount: Long,
)

data class SoSectionJni(
    val name: String,
    val type: String,
    val offset: Long,
    val size: Long,
    val flags: Long,
    val alignment: Long,
)

data class SoSymbolJni(
    val name: String,
    val type: String,
    val binding: String,
    val visibility: String,
    val address: Long,
    val size: Long,
    val shndx: String?,
)

data class SoDependencyJni(val name: String)

data class SoJniFunctionJni(
    val symbolName: String,
    val javaClass: String,
    val javaMethod: String,
    val signature: String?,
    val address: Long,
    val isDynamic: Boolean,
)

data class SoStringJni(
    val offset: Long,
    val value: String,
    val section: String,
)

object SoAnalysisJni {
    init {
        System.loadLibrary("so_analysis")
    }

    external fun parseSoHeader(data: ByteArray): SoElfHeaderJni?
    external fun getSoSections(data: ByteArray): Array<SoSectionJni>
    external fun getExportedSymbols(data: ByteArray): Array<SoSymbolJni>
    external fun getImportedSymbols(data: ByteArray): Array<SoSymbolJni>
    external fun getDependencies(data: ByteArray): Array<SoDependencyJni>
    external fun getSoStrings(data: ByteArray): Array<SoStringJni>
    external fun getJniFunctions(data: ByteArray): Array<SoJniFunctionJni>
    external fun generateFridaHook(soName: String, symbolName: String, address: Long, isJni: Boolean): String
}

class SoAnalysis(private val context: Context) {
    private val apkSessions = mutableMapOf<String, String>()
    
    // 缓存 SO 文件字节数据，避免重复读取 APK
    private val soBytesCache = mutableMapOf<String, ByteArray>()
    
    // 缓存解析结果，避免重复解析
    private val headerCache = mutableMapOf<String, SoElfHeader>()
    private val sectionsCache = mutableMapOf<String, List<SoSection>>()
    private val exportedSymbolsCache = mutableMapOf<String, List<SoSymbol>>()
    private val importedSymbolsCache = mutableMapOf<String, List<SoSymbol>>()
    private val dependenciesCache = mutableMapOf<String, List<SoDependency>>()
    private val stringsCache = mutableMapOf<String, List<SoString>>()
    private val jniFunctionsCache = mutableMapOf<String, List<SoJniFunction>>()

    fun registerSession(sessionId: String, apkPath: String) {
        apkSessions[sessionId] = apkPath
    }
    
    fun clearSession(sessionId: String) {
        apkSessions.remove(sessionId)
        // 清理该 session 相关的所有缓存
        val keysToRemove = soBytesCache.keys.filter { it.startsWith("$sessionId::") }
        keysToRemove.forEach { key ->
            soBytesCache.remove(key)
            headerCache.remove(key)
            sectionsCache.remove(key)
            exportedSymbolsCache.remove(key)
            importedSymbolsCache.remove(key)
            dependenciesCache.remove(key)
            stringsCache.remove(key)
            jniFunctionsCache.remove(key)
        }
    }

    private fun getCacheKey(sessionId: String, soPath: String): String = "$sessionId::$soPath"

    private fun readSoBytes(sessionId: String, soPath: String): ByteArray {
        val cacheKey = getCacheKey(sessionId, soPath)
        return soBytesCache.getOrPut(cacheKey) {
            val apkPath = apkSessions[sessionId]
                ?: throw IllegalStateException("SO session not found: $sessionId")
            ZipFile(apkPath).use { zip ->
                val entry = zip.getEntry(soPath)
                    ?: throw IllegalArgumentException("Entry not found: $soPath")
                zip.getInputStream(entry).readBytes()
            }
        }
    }

    fun parseSoHeader(sessionId: String, soPath: String): SoElfHeader {
        val cacheKey = getCacheKey(sessionId, soPath)
        return headerCache.getOrPut(cacheKey) {
            val bytes = readSoBytes(sessionId, soPath)
            val jni = SoAnalysisJni.parseSoHeader(bytes)
                ?: throw IllegalStateException("Failed to parse ELF header")
            SoElfHeader(
                magic = jni.magic,
                classType = jni.classType,
                dataEncoding = jni.dataEncoding,
                osAbi = jni.osAbi,
                fileType = jni.fileType,
                machine = jni.machine,
                entryPoint = jni.entryPoint,
                programHeaderOffset = jni.programHeaderOffset,
                sectionHeaderOffset = jni.sectionHeaderOffset,
                flags = jni.flags,
                programHeaderCount = jni.programHeaderCount,
                sectionHeaderCount = jni.sectionHeaderCount,
            )
        }
    }

    fun getSoSections(sessionId: String, soPath: String): List<SoSection> {
        val cacheKey = getCacheKey(sessionId, soPath)
        return sectionsCache.getOrPut(cacheKey) {
            val bytes = readSoBytes(sessionId, soPath)
            SoAnalysisJni.getSoSections(bytes).map {
                SoSection(name = it.name, type = it.type, offset = it.offset, size = it.size, flags = it.flags, alignment = it.alignment)
            }
        }
    }

    fun getExportedSymbols(sessionId: String, soPath: String): List<SoSymbol> {
        val cacheKey = getCacheKey(sessionId, soPath)
        return exportedSymbolsCache.getOrPut(cacheKey) {
            val bytes = readSoBytes(sessionId, soPath)
            SoAnalysisJni.getExportedSymbols(bytes).map {
                SoSymbol(name = it.name, type = it.type, binding = it.binding, visibility = it.visibility, address = it.address, size = it.size, shndx = it.shndx)
            }
        }
    }

    fun getImportedSymbols(sessionId: String, soPath: String): List<SoSymbol> {
        val cacheKey = getCacheKey(sessionId, soPath)
        return importedSymbolsCache.getOrPut(cacheKey) {
            val bytes = readSoBytes(sessionId, soPath)
            SoAnalysisJni.getImportedSymbols(bytes).map {
                SoSymbol(name = it.name, type = it.type, binding = it.binding, visibility = it.visibility, address = it.address, size = it.size, shndx = it.shndx)
            }
        }
    }

    fun getDependencies(sessionId: String, soPath: String): List<SoDependency> {
        val cacheKey = getCacheKey(sessionId, soPath)
        return dependenciesCache.getOrPut(cacheKey) {
            val bytes = readSoBytes(sessionId, soPath)
            SoAnalysisJni.getDependencies(bytes).map { SoDependency(name = it.name) }
        }
    }

    fun getSoStrings(sessionId: String, soPath: String): List<SoString> {
        val cacheKey = getCacheKey(sessionId, soPath)
        return stringsCache.getOrPut(cacheKey) {
            val bytes = readSoBytes(sessionId, soPath)
            SoAnalysisJni.getSoStrings(bytes).map {
                SoString(offset = it.offset, value = it.value, section = it.section)
            }
        }
    }

    fun getJniFunctions(sessionId: String, soPath: String): List<SoJniFunction> {
        val cacheKey = getCacheKey(sessionId, soPath)
        return jniFunctionsCache.getOrPut(cacheKey) {
            val bytes = readSoBytes(sessionId, soPath)
            SoAnalysisJni.getJniFunctions(bytes).map {
                SoJniFunction(
                    symbolName = it.symbolName,
                    javaClass = it.javaClass,
                    javaMethod = it.javaMethod,
                    signature = it.signature,
                    address = it.address,
                    isDynamic = it.isDynamic,
                )
            }
        }
    }

    fun generateFridaHook(sessionId: String, soPath: String, symbolName: String, address: Long): String {
        val soName = soPath.substringAfterLast('/')
        val isJni = symbolName.startsWith("Java_")
        return SoAnalysisJni.generateFridaHook(soName, symbolName, address, isJni)
    }
}
