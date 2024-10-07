import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readit/challenge/app_translation.dart';
import 'package:readit/challenge/questions_ui.dart';
import 'package:readit/text_to_audio/views/text_to_audio_main_ui.dart';
import 'package:readit/theme_constants.dart';
import 'package:readit/voice/views/voice_to_text.dart';
// Import your theme controller

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: AppTranslations(), // Your translations
        locale: Locale('fr', 'FR'),      // Default locale
        fallbackLocale: Locale('en', 'US'), // Fallback locale if translation not available
        title: 'Text to Audio Converter',
        theme: themeController.isDarkTheme.value ? ThemeData.dark() : ThemeData.light(),
        home: TextToAudioHomePage(),
        // Define routes here
        getPages: [
          GetPage(name: '/', page: () => TextToAudioHomePage()),
          // Add other pages here
          GetPage(name: '/challenge-page', page: () => DailyChallengesPage()),
          GetPage(name: '/speak-page', page: () => VoiceToTextWidget()),
        ],
      );
    });
  }
}

// Example Settings Page
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(child: Text('Settings Page')),
    );
  }
}

// Example Feedback Page
class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Feedback')),
      body: Center(child: Text('Feedback Page')),
    );
  }
}
