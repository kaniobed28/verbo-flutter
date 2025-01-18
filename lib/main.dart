import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:readit/Pronunciation/views/pronunciation_practice_page.dart';
import 'package:readit/challenge/app_translation.dart';
import 'package:readit/challenge/questions_ui.dart';
import 'package:readit/text_to_audio/views/text_to_audio_main_ui.dart';
import 'package:readit/theme_constants.dart';
import 'package:readit/voice/views/voice_to_text.dart';

// Import your theme controller

void main() {
  // This line sets the path-based URL strategy instead of hash-based.
  // setUrlStrategy(PathUrlStrategy());
  // it is not working when I deploy it and click on the link again for refresh

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
        locale: const Locale('fr', 'FR'),      // Default locale
        fallbackLocale: const Locale('en', 'US'), // Fallback locale if translation not available
        title: 'Text to Audio Converter',
        theme: themeController.isDarkTheme.value ? ThemeData.dark() : ThemeData.light(),
        home:  TextToAudioHomePage(),
        getPages: [
          GetPage(name: '/', page: () =>  TextToAudioHomePage()),
          GetPage(name: '/challenge-page', page: () => DailyChallengesPage()),
          GetPage(name: '/listen-page', page: () => VoiceToTextWidget()),
          GetPage(name: '/level-practice-page', page: () => PronunciationPracticePage()),
        ],
      );
    });
  }
}
