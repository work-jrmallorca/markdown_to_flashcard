package app.jrmallorca.markdown_to_flashcard

import android.content.Context

internal object Model {
    const val NAME = "app.jrmallorca.markdown_to_flashcard.model"

    val FIELDS = arrayOf("Front", "Back", "Source")
    val CARD_NAMES = arrayOf("Card 1")

    fun getQuestionFormat(context: Context): Array<String> =
        Utils.getAsset(context, "assets/model_formats/question.html")

    fun getAnswerFormat(context: Context): Array<String> =
        Utils.getAsset(context, "assets/model_formats/answer.html")
}