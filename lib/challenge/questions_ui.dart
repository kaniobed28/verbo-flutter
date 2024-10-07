import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readit/reusable/custom_appbar.dart';
import 'questions_controller.dart';

class DailyChallengesPage extends StatelessWidget {
  final DailyChallengesController controller = Get.put(DailyChallengesController());

  // List of supported languages
  final List<Map<String, String>> languages = [
    {'name': 'English', 'code': 'en_US'},
    {'name': 'Français', 'code': 'fr_FR'},
  ];

  String? _selectedLanguage; // State variable to track selected language

  DailyChallengesPage() {
    // Set default language (optional)
    _selectedLanguage = languages[0]['code']; // Set default to English
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        any: DropdownButton<String>(
          icon: Icon(
            Icons.language,
            color: _selectedLanguage == 'fr_FR' ? Colors.blue : Colors.white, // Change color based on selected language
          ),
          underline: const SizedBox(),
          onChanged: (String? value) {
            if (value != null) {
              _selectedLanguage = value; // Update selected language
              var locale = value == 'fr_FR' ? Locale('fr', 'FR') : Locale('en', 'US');
              Get.updateLocale(locale); // Update locale
            }
          },
          items: languages.map((Map<String, String> lang) {
            return DropdownMenuItem<String>(
              value: lang['code'],
              child: Text(
                lang['name']!,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
            );
          }).toList(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Obx(() => Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          controller.currentQuestion.value,
                          style: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.primary),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.volume_up),
                        onPressed: () {
                          controller.speak(controller.currentQuestion.value);
                        },
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 20),
          Obx(() => Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '${'your_answer'.tr} ${controller.text.value}',
                    style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              )),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              controller.listen();
            },
            icon: Obx(() => Icon(controller.isListening.value ? Icons.mic : Icons.mic_none)),
            label: Obx(() => Text(controller.isListening.value ? 'listening'.tr : 'respond_now'.tr)),
            style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              controller.showCorrectAnswer();
            },
            icon: const Icon(Icons.visibility),
            label: Text('see_correct_answer'.tr, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
          ),
          const SizedBox(height: 20),
          Obx(() => Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '${'correct_answer'.tr} ${controller.correctAnswer.value}',
                          style: const TextStyle(fontSize: 18, color: Colors.green),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.volume_up),
                        onPressed: () {
                          controller.speak(controller.correctAnswer.value);
                        },
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              controller.nextRandomQuestion();
            },
            icon: const Icon(Icons.arrow_forward),
            label: Text('next_question'.tr, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
          ),
          const SizedBox(height: 20),
          Obx(() => Column(
                children: [
                  Text('speech_rate'.tr),
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
