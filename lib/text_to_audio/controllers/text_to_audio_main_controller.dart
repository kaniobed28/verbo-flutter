import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class TextToAudioController extends GetxController {
  final FlutterTts _flutterTts = FlutterTts();
  final TextEditingController textController = TextEditingController();
  var speed = 0.5.obs;
  var loops = 1.obs;
  var isSpeaking = false.obs;
  var isPaused = false.obs; // Track if speech is paused
  var selectedLanguage = 'en-US'.obs;

  final List<Map<String, String>> languages = [
    {'code': 'en-US', 'name': 'English (US)'},
    {'code': 'fr-FR', 'name': 'French'},
    {'code': 'es-ES', 'name': 'Spanish'},
    {'code': 'de-DE', 'name': 'German'},
    {'code': 'it-IT', 'name': 'Italian'},
    {'code': 'pt-PT', 'name': 'Portuguese'},
  ];

  Future<void> speak() async {
    isSpeaking.value = true;
    isPaused.value = false;

    await _flutterTts.setLanguage(selectedLanguage.value);
    await _flutterTts.setSpeechRate(speed.value);

    for (int i = 0; i < loops.value; i++) {
      if (!isSpeaking.value) break;
      await _flutterTts.speak(textController.text);
      await _flutterTts.awaitSpeakCompletion(true);
    }

  }

  Future<void> stop() async {
    await _flutterTts.stop();
    isSpeaking.value = false;
    isPaused.value = false;
  }

  Future<void> pause() async {
    await _flutterTts.pause();
    isSpeaking.value = false;
    isPaused.value = true;
  }

  Future<void> resume() async {
    isPaused.value = false;
    isSpeaking.value = true;
    await _flutterTts.speak(textController.text); // Resumes from pause
  }
}
