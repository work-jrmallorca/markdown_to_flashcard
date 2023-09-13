package com.example.markdown_to_flashcard

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "app.jrmallorca.markdown_to_flashcard/ankidroid"

    private lateinit var anki: Anki

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        anki = Anki(this)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->

            when (call.method) {
                "requestPermissions" -> {
                    if (anki.shouldRequestPermission()) {
                        anki.requestPermission(this, 0)
                    }
                    result.success(true)
                }
                "addAnkiNote" -> {
                    val noteId: Long? = anki.addAnkiNote(
                        call.argument<String>("deck")!!,
                        call.argument<String>("question")!!,
                        call.argument<String>("answer")!!,
                        call.argument<String>("source")!!,
                        call.argument<List<String>>("tags")!!.toSet()
                    )

                    if (noteId != null) {
                        result.success(noteId)
                    } else {
                        result.error("FAILURE", "Failed to add Anki note", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}