package app.jrmallorca.markdown_to_flashcard

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
                "addAnkiNotes" -> {
                    val notesAdded: Int = anki.addAnkiNotes(
                        call.argument<String>("deck")!!,
                        call.argument<List<List<String>>>("fields")!!,
                        call.argument<List<List<String>>>("tags")!!
                    )

                    if (notesAdded != 0) {
                        result.success(notesAdded)
                    } else {
                        result.error("FAILURE", "Failed to add Anki notes", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}