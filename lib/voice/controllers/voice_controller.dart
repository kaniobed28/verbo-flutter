import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/services.dart';

class VoiceController extends GetxController with GetSingleTickerProviderStateMixin {
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;

  var isListening = false.obs; 
  var text = "Press the button and start speaking".obs;  
  var confidence = 0.0.obs;  
  var selectedLanguage = 'en-US'.obs;  

  var languageOptions = <String, String>{
    'en-US': 'English (US)',
    'es-ES': 'Spanish (ES)',
    'fr-FR': 'French (FR)',
    'de-DE': 'German (DE)',
    'it-IT': 'Italian (IT)',
    'zh-CN': 'Chinese (Simplified)',
    'ja-JP': 'Japanese (JP)',
    // I can add more languages as needed here
}.obs;


  var transcriptionHistory = <String>[].obs;

  late AnimationController animationController;

  @override
  void onInit() async {
    super.onInit();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();

    // Initialize speech recognition
    bool available = await _speech.initialize(
      onStatus: (val) {
        print('Speech Status: $val');
        if (val == "notListening" && isListening.value) {
          restartListening();
        }
      },
      onError: (val) {
        print('Speech Error: ${val.errorMsg}');
        restartListening();
      },
    );

    if (available) {
      // Print supported languages for debugging
      var locales = await _speech.locales();
      print('Supported languages: ${locales.map((locale) => locale.localeId).toList()}');
    } else {
      Get.snackbar('Error', 'Speech recognition is not available.');
    }

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0.5,
      upperBound: 1.0,
    )..addListener(() {
        update();
      });
  }

  void listen() async {
    if (!isListening.value) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          print('Speech Status: $val');
          if (val == "notListening" && isListening.value) {
            restartListening();
          }
        },
        onError: (val) {
          print('Speech Error: ${val.errorMsg}');
          restartListening();
        },
      );

      if (available) {
        isListening.value = true;
        animationController.repeat(reverse: true);
        startListening();
      } else {
        Get.snackbar('Error', 'Speech recognition is not available.');
      }
    } else {
      isListening.value = false;
      _speech.stop();
      animationController.stop();
    }
  }

  void startListening() {
    _speech.listen(
      localeId: selectedLanguage.value,
      onResult: (val) {
        text.value = val.recognizedWords;
        if (val.hasConfidenceRating && val.confidence > 0) {
          confidence.value = val.confidence; 
        } else {
          confidence.value = 0.0;
        }
      },
    );
  }

  void restartListening() {
    if (isListening.value) {
      _speech.stop();
      startListening();
    }
  }

  void speak() async {
    await _flutterTts.setLanguage(selectedLanguage.value);
    var result = await _flutterTts.speak(text.value);
    if (result == 1) {
      Get.snackbar('Error', 'Text-to-speech failed.');
    }
  }

  void saveTranscription() {
    if (text.isNotEmpty) {
      transcriptionHistory.add(text.value);
      showSnackbar("Transcription saved!");
    } else {
      showSnackbar("No text to save.");
    }
  }

  void clearText() {
    text.value = "Press the button and start speaking";
    confidence.value = 0.0;
  }

  void copyToClipboard() {
    Clipboard.setData(ClipboardData(text: text.value));
    showSnackbar("Text copied to clipboard!");
  }

  void showSnackbar(String message) {
    Get.snackbar('Message', message);
  }

  @override
  void onClose() {
    _speech.stop();
    animationController.dispose();
    super.onClose();
  }
}
