import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readit/Pronunciation/controllers/pronunciation_controller.dart';
import 'package:readit/reusable/custom_appbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
      ),
      home: PronunciationPracticePage(),
    );
  }
}

class PronunciationPracticePage extends StatelessWidget {
  final PronunciationController controller = Get.put(PronunciationController());

  // List of supported languages (French will be default)
  final List<Map<String, String>> languages = [
    {'name': 'English', 'code': 'en_US'},
    {'name': 'Français', 'code': 'fr_FR'},
  ];

  // List of difficulty levels
  final List<String> levels = ['Beginner/Débutant', 'Intermediate/Intermédiaire', 'Advanced/Avancé'];

  String? _selectedLanguage; // Track selected language
  String? _selectedLevel; // Track selected level

  PronunciationPracticePage() {
    // _selectedLanguage = languages[1]['code']; // Default to French
    _selectedLevel = levels[0]; // Default to Beginner
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        any: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // // Language Dropdown
            // DropdownButton<String>(
            //   value: _selectedLanguage,
            //   icon: Icon(
            //     Icons.language,
            //     color: _selectedLanguage == 'fr_FR' ? Colors.blue : Colors.white,
            //   ),
            //   underline: const SizedBox(),
            //   onChanged: (String? value) {
            //     if (value != null) {
            //       _selectedLanguage = value;
            //       var locale = value == 'fr_FR' ? Locale('fr', 'FR') : Locale('en', 'US');
            //       Get.updateLocale(locale);
            //     }
            //   },
            //   items: languages.map((Map<String, String> lang) {
            //     return DropdownMenuItem<String>(
            //       value: lang['code'],
            //       child: Text(
            //         lang['name']!,
            //         style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            //       ),
            //     );
            //   }).toList(),
            // ),
            // Level Dropdown
            DropdownButton<String>(
              value: _selectedLevel,
              underline: const SizedBox(),
              onChanged: (String? value) {
                if (value != null) {
                  _selectedLevel = value;
                  controller.updateLevel(_selectedLevel!);
                }
              },
              items: levels.map((String level) {
                return DropdownMenuItem<String>(
                  value: level,
                  child: Text(
                    level,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Display the current statement (French and English)
          Obx(() => Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              controller.currentStatement.value.french,
                              style: TextStyle(
                                fontSize: 24,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              controller.currentStatement.value.english,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.volume_up),
                        onPressed: () {
                          controller.speak(controller.currentStatement.value.french);
                        },
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 20),
          // Button to listen for pronunciation
          ElevatedButton.icon(
            onPressed: () {
              controller.listenForPronunciation();
            },
            icon: Obx(() => Icon(controller.isListening.value ? Icons.mic : Icons.mic_none)),
            label: Obx(() => Text(controller.isListening.value ? 'Listening...' : 'Pronounce Now')),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          // const SizedBox(height: 20),
          // // Button to see correct pronunciation
          // ElevatedButton.icon(
          //   onPressed: () {
          //     controller.listenForPronunciation();
          //   },
          //   icon: const Icon(Icons.visibility),
          //   label: const Text('See Correct Pronunciation'),
          //   style: ElevatedButton.styleFrom(
          //     minimumSize: const Size(double.infinity, 50),
          //   ),
          // ),
          const SizedBox(height: 20),
          // Display the correct pronunciation
          Obx(() => Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'My Pronunciation: ${controller.correctPronunciation.value}',
                          style: const TextStyle(fontSize: 18, color: Colors.green),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.volume_up),
                        onPressed: () {
                          controller.speak(controller.correctPronunciation.value);
                        },
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 20),
          // Button to move to the next statement
          ElevatedButton.icon(
            onPressed: () {
              controller.nextStatement();
            },
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Next Statement'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          const SizedBox(height: 20),
          // Speech rate slider
          Obx(() => Column(
                children: [
                  const Text('Speech Rate'),
                  Slider(
                    value: controller.speechRate.value,
                    min: 0.1,
                    max: 2.0,
                    divisions: 19,
                    label: controller.speechRate.value.toStringAsFixed(1),
                    onChanged: (value) {
                      controller.setSpeechRate(value);
                    },
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
