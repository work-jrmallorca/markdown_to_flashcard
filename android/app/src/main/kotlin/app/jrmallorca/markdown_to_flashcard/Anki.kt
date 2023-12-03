package app.jrmallorca.markdown_to_flashcard

import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.util.SparseArray
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.ichi2.anki.FlashCardsContract.READ_WRITE_PERMISSION
import com.ichi2.anki.api.AddContentApi
import com.ichi2.anki.api.NoteInfo


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
            Model.NAME,
            Model.FIELDS,
            Model.CARD_NAMES,
            Model.getQuestionFormat(context),
            Model.getAnswerFormat(context),
            Model.getCSS(context),
            null,
            null
        )
    }

    fun shouldRequestPermission(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) return false

        return ContextCompat.checkSelfPermission(
            context, READ_WRITE_PERMISSION
        ) != PackageManager.PERMISSION_GRANTED
    }

    fun requestPermission(activity: Activity, requestCode: Int) {
        ActivityCompat.requestPermissions(
            activity,
            arrayOf(READ_WRITE_PERMISSION),
            requestCode,
        )
    }

    fun addAnkiFlashcard(
        deck: String,
        question: String,
        answer: String,
        source: String,
        tags: List<String>,
    ): Long? {
        val fields = arrayOf(
            question, answer, source
        )

        return api.addNote(getModelId()!!, getDeckId(deck)!!, fields, tags.toSet())
    }

    fun addAnkiFlashcards(
        deck: String,
        fields: List<List<String>>,
        tags: List<List<String>>,
    ): Int {
        val modelId = getModelId()!!
        removeDuplicates(modelId, fields, tags)

        val fieldsAsArray: List<Array<String>> = fields.map { it.toTypedArray() }
        val tagsAsSet: List<Set<String>> = tags.map { it.toSet() }

        return api.addNotes(modelId, getDeckId(deck)!!, fieldsAsArray, tagsAsSet)
    }

    fun updateAnkiFlashcard(
        flashcardId: Long,
        question: String,
        answer: String,
        source: String,
        tags: List<String>,
    ): Boolean {
        val fields = arrayOf(
            question, answer, source
        )

        val isTagsUpdated: Boolean = api.updateNoteTags(flashcardId, tags.toSet())
        val isFieldsUpdated: Boolean = api.updateNoteFields(flashcardId, fields)
        return isTagsUpdated && isFieldsUpdated
    }

    private fun removeDuplicates(
        modelId: Long, fields: List<List<String>>, tags: List<List<String>>
    ) {
        // Build a list of the duplicate keys (first fields) and find all notes that have a match with each key
        val keys: MutableList<String> = ArrayList(fields.size)
        for (f in fields) {
            keys.add(f[0])
        }

        val duplicateNotes: SparseArray<MutableList<NoteInfo?>>? = api.findDuplicateNotes(modelId, keys)

        // Do some sanity checks
        if (tags.size != fields.size) {
            throw IllegalStateException("List of tags must be the same length as the list of fields")
        }
        if (duplicateNotes == null || duplicateNotes.size() == 0 || fields.isEmpty() || tags.isEmpty()) {
            return
        }
        if (duplicateNotes.keyAt(duplicateNotes.size() - 1) >= fields.size) {
            throw IllegalStateException("The array of duplicates goes outside the bounds of the original lists")
        }

        val fieldIterator: MutableListIterator<List<String>> = fields.toMutableList().listIterator()
        val tagsIterator: MutableListIterator<List<String>> = tags.toMutableList().listIterator()
        var listIndex: Int = -1
        for (i in 0 until duplicateNotes.size()) {
            val duplicateIndex: Int = duplicateNotes.keyAt(i)
            while (listIndex < duplicateIndex) {
                fieldIterator.next()
                tagsIterator.next()
                listIndex++
            }
            fieldIterator.remove()
            tagsIterator.remove()
        }
    }
}