package app.jrmallorca.markdown_to_flashcard

import android.content.Context
import io.flutter.FlutterInjector
import java.io.IOException
import java.io.InputStream
import java.util.*

object Utils {
    fun getAsset(context: Context, assetPath:String): Array<String> {
        return try {
            val key: String = FlutterInjector.instance().flutterLoader().getLookupKeyForAsset(assetPath)
            return context.applicationContext.assets.open(key).use { inputStream -> arrayOf(inputStreamToString(inputStream)) }
        } catch (e: IOException) {
            arrayOf("An error occurred when trying to find an asset of path $assetPath")
        }
    }

    @Throws(IOException::class)
    private fun inputStreamToString(input: InputStream): String {
        val scanner = Scanner(input).useDelimiter("\\A")
        val str = if (scanner.hasNext()) scanner.next() else ""

        input.close()

        return str
    }
}