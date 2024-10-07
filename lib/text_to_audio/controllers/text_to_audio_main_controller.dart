import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class TextToAudioController extends GetxController {
  final FlutterTts _flutterTts = FlutterTts();
  final TextEditingController textController = TextEditingController();
  var speed = 0.5.obs;
  var loops = 1.obs;
  var isSpeaking = false.obs; // Track if speech is currently playing
  var selectedLanguage = 'en-US'.obs; // Default language

  // Available languages
  final List<Map<String, String>> languages = [
    {'code': 'en-US', 'name': 'English (US)'},
    {'code': 'fr-FR', 'name': 'French'},
    {'code': 'es-ES', 'name': 'Spanish'},
    {'code': 'de-DE', 'name': 'German'},
    {'code': 'it-IT', 'name': 'Italian'},
    {'code': 'pt-PT', 'name': 'Portuguese'},
    // Add more languages as needed
  ];

  Future<void> speak() async {
    isSpeaking.value = true; // Set speaking state to true

    await _flutterTts.setLanguage(selectedLanguage.value); // Set the selected language
    await _flutterTts.setSpeechRate(speed.value);

    for (int i = 0; i < loops.value; i++) {
      // Check if speech should be stopped
      if (!isSpeaking.value) {
        break;
      }

      // Await the completion of the speak method
      await _flutterTts.speak(textController.text);

      // Wait until the speech is finished before looping again
      await _flutterTts.awaitSpeakCompletion(true);
    }

    isSpeaking.value = false; // Reset speaking state
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    isSpeaking.value = false; // Reset speaking state
  }
}
