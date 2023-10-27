package app.jrmallorca.markdown_to_flashcard

import android.app.Activity
import android.content.Intent
import android.net.Uri
import androidx.core.net.toUri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.BufferedReader
import java.io.FileNotFoundException
import java.io.FileOutputStream
import java.io.IOException
import java.io.InputStreamReader

class MainActivity : FlutterActivity() {
    private val CHANNEL = "app.jrmallorca.markdown_to_flashcard/ankidroid"
    private val GET_MARKDOWN_FILE = 2

    private var pendingResult: MethodChannel.Result? = null

    private lateinit var anki: Anki

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        anki = Anki(this)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, CHANNEL
        ).setMethodCallHandler { call, result ->
            pendingResult = result
            when (call.method) {
                "pickFile" -> pickFileFromFilePicker()
                "requestPermissions" -> requestPermissions()
                "addAnkiFlashcard" -> addAnkiFlashcard(call)
                "addAnkiFlashcards" -> addAnkiFlashcards(call)
                "updateAnkiFlashcard" -> updateAnkiFlashcard(call)
                "writeFile" -> writeFile(call)
                else -> result.notImplemented()
            }
        }
    }

    override fun onActivityResult(
        requestCode: Int, resultCode: Int, resultData: Intent?
    ) {
        if (resultCode == Activity.RESULT_OK && requestCode == GET_MARKDOWN_FILE) {
            readFile(resultData)
        } else {
            pendingResult!!.success(null)
        }
    }

    private fun pickFileFromFilePicker() {
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "text/markdown"
        }

        startActivityForResult(intent, GET_MARKDOWN_FILE)
    }

    private fun readFile(resultData: Intent?) {
        resultData?.data?.also { uri ->
            val stringBuilder = StringBuilder()

            contentResolver.openInputStream(uri)?.use { inputStream ->
                BufferedReader(InputStreamReader(inputStream)).use { reader ->
                    var line: String? = reader.readLine()
                    while (line != null) {
                        stringBuilder.append(line)
                        stringBuilder.append('\n')
                        line = reader.readLine()
                    }
                }
            }

            return pendingResult!!.success(
                mapOf(
                    "uri" to uri.toString(), "fileContents" to stringBuilder.toString()
                )
            )
        }
    }

    private fun requestPermissions() {
        if (anki.shouldRequestPermission()) {
            anki.requestPermission(this, 0)
        }
        pendingResult!!.success(true)
    }

    private fun addAnkiFlashcard(call: MethodCall) {
        val deck: String = call.argument<String>("deck")!!
        val question: String = call.argument<String>("question")!!
        val answer: String = call.argument<String>("answer")!!
        val source: String = call.argument<String>("source")!!
        val tags: List<String> = call.argument<List<String>>("tags")!!

        val noteId: Long? = anki.addAnkiFlashcard(
            deck, question, answer, source, tags
        )

        if (noteId != null) {
            pendingResult!!.success(noteId)
        } else {
            pendingResult!!.error(
                "FAILURE",
                "Failed to add Anki flashcard in source \"$source\" and question \"$question\"",
                null
            )
        }
    }

    private fun addAnkiFlashcards(call: MethodCall) {
        val notesAdded: Int = anki.addAnkiFlashcards(
            call.argument<String>("deck")!!,
            call.argument<List<List<String>>>("fields")!!,
            call.argument<List<List<String>>>("tags")!!
        )

        if (notesAdded != 0) {
            pendingResult!!.success(notesAdded)
        } else {
            pendingResult!!.error("FAILURE", "Failed to add Anki notes", null)
        }
    }

    private fun updateAnkiFlashcard(call: MethodCall) {
        val id: Long = call.argument<Long>("id")!!
        val question: String = call.argument<String>("question")!!
        val answer: String = call.argument<String>("answer")!!
        val source: String = call.argument<String>("source")!!
        val tags: List<String> = call.argument<List<String>>("tags")!!

        val isFlashcardUpdated: Boolean = anki.updateAnkiFlashcard(
            id, question, answer, source, tags
        )

        if (isFlashcardUpdated) {
            pendingResult!!.success(isFlashcardUpdated)
        } else {
            pendingResult!!.error(
                "FAILURE",
                "Failed to update Anki flashcard in source \"$source\" and question \"$question\"",
                null
            )
        }
    }

    private fun writeFile(call: MethodCall) {
        val uri: Uri = call.argument<String>("uri")!!.toUri()
        val fileContents: String = call.argument<String>("fileContents")!!

        try {
            contentResolver.openFileDescriptor(uri, "w")?.use {
                FileOutputStream(it.fileDescriptor).use { os ->
                    os.write(fileContents.toByteArray())
                }
            }
        } catch (e: FileNotFoundException) {
            e.printStackTrace()
        } catch (e: IOException) {
            e.printStackTrace()
        }
        return pendingResult!!.success(true)
    }
}