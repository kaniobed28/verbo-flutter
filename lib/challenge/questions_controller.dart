import 'dart:math'; // Import for random number generation
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'questions.dart'; // Import the questions from the separate file

class DailyChallengesController extends GetxController with GetSingleTickerProviderStateMixin {
  late stt.SpeechToText _speech;
  late FlutterTts flutterTts; // Declare the TTS instance
  var random = Random(); // Random number generator

  var isListening = false.obs; // Manages listening state
  var text = "Dites votre réponse...".obs; // Holds the transcribed text in French
  var correctAnswer = "".obs; // Holds the correct answer for display
  var askedQuestions = <int>[].obs; // List to keep track of asked questions
  var currentQuestion = "".obs; // Current question text
  var speechRate = 1.0.obs; // Observable for speech rate

  @override
  void onInit() {
    super.onInit();
    _speech = stt.SpeechToText();
    flutterTts = FlutterTts(); // Initialize TTS
    flutterTts.setLanguage("fr-FR"); // Set language to French
    flutterTts.setSpeechRate(speechRate.value); // Set initial speech rate
    nextRandomQuestion(); // Initialize first random question
  }

  // Function to start listening in French
  void listen() async {
    if (!isListening.value) {
      bool available = await _speech.initialize();
      if (available) {
        isListening.value = true;
        _speech.listen(
          onResult: (val) {
            text.value = val.recognizedWords; // Update text with recognized French words
          },
          localeId: "fr_FR", // Set the locale to French
        );
      }
    } else {
      isListening.value = false;
      _speech.stop();
    }
  }

  // Function to show the correct answer for the current question
  void showCorrectAnswer() {
    correctAnswer.value = questionList[currentQuestion.value] ?? "Aucune réponse disponible";
  }

  // Function to move to the next random question
  void nextRandomQuestion() {
    if (askedQuestions.length == questionList.length) {
      Get.snackbar('Fin du quiz', 'Vous avez terminé toutes les questions !', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    int nextQuestionKey;

    do {
      nextQuestionKey = random.nextInt(questionList.length); // Pick a random question index
    } while (askedQuestions.contains(nextQuestionKey));

    // Add the question to the list of asked questions
    askedQuestions.add(nextQuestionKey);

    // Update the current question and reset fields
    currentQuestion.value = questionList.keys.toList()[nextQuestionKey];
    text.value = "Dites votre réponse..."; // Reset user's transcribed text
    correctAnswer.value = ""; // Clear the previous correct answer
  }

  // Text-to-Speech function to read aloud text
  void speak(String text) async {
    await flutterTts.setSpeechRate(speechRate.value); // Set the speech rate before speaking
    await flutterTts.speak(text);
  }

  // Function to set speech rate
  void setSpeechRate(double rate) {
    speechRate.value = rate; // Update observable value
    flutterTts.setSpeechRate(rate); // Set the speech rate for TTS
  }
}
