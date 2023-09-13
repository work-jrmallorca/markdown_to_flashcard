package app.jrmallorca.markdown_to_flashcard

import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.ichi2.anki.api.AddContentApi
import com.ichi2.anki.api.AddContentApi.READ_WRITE_PERMISSION

class Anki(private val context: Context) {
    private var api: AddContentApi = AddContentApi(context)

    private fun getDeckId(name: String): Long? {
        val deckList = api.deckList
        if (deckList != null) {
            for (entry in deckList.entries) {
                if (entry.value == name) {
                    return entry.key
                }
            }
        }

        return api.addNewDeck(name)
    }

    private fun getModelId(): Long? {
        val modelList = api.modelList
        if (modelList != null) {
            for (entry in modelList.entries) {
                if (entry.value == Model.NAME) {
                    return entry.key
                }
            }
        }

        return api.addNewCustomModel(
            Model.NAME, Model.FIELDS, Model.CARD_NAMES,
            Model.getQuestionFormat(context),
            Model.getAnswerFormat(context),
            Model.getCSS(context),
            null, null
        )
    }

    fun shouldRequestPermission(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) return false

        return ContextCompat.checkSelfPermission(context, READ_WRITE_PERMISSION) != PackageManager.PERMISSION_GRANTED
    }

    fun requestPermission(activity: Activity, requestCode: Int) {
        ActivityCompat.requestPermissions(
            activity,
            arrayOf(READ_WRITE_PERMISSION),
            requestCode,
        )
    }

    fun addAnkiNote(
        deck: String,
        question: String,
        answer: String,
        source: String,
        tags: Set<String>,
    ): Long? {
        val fields = arrayOf(
            question,
            answer,
            source
        )

        return api.addNote(getModelId()!!, getDeckId(deck)!!, fields, tags)
    }
}