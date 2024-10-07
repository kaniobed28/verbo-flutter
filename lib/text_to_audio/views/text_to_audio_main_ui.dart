import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readit/challenge/questions_ui.dart';
import 'package:readit/reusable/custom_appbar.dart';
import 'package:readit/text_to_audio/controllers/text_to_audio_main_controller.dart';
import 'package:readit/voice/views/voice_to_text.dart';

class TextToAudioHomePage extends StatelessWidget {
  final TextToAudioController controller = Get.put(TextToAudioController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller.textController,
                decoration: InputDecoration(
                  labelText: 'Enter Text',
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // Number of Loops Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Number of Loops:'),
                      Obx(() => DropdownButton<int>(
                        value: controller.loops.value,
                        items: List.generate(10, (index) => index + 1)
                            .map((value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value.toString()),
                                )).toList(),
                        onChanged: (value) {
                          controller.loops.value = value!;
                        },
                      )),
                    ],
                  ),
                ),
              ),

              // Playback Speed Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Playback Speed:'),
                      Obx(() => Expanded( // Use Expanded to prevent overflow
                        child: Slider(
                          value: controller.speed.value,
                          min: 0.1,
                          max: 1.0,
                          divisions: 10,
                          activeColor: Theme.of(context).colorScheme.primary,
                          onChanged: (value) {
                            controller.speed.value = value;
                          },
                        ),
                      )),
                    ],
                  ),
                ),
              ),

              // Language Selection Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Select Language:'),
                      Obx(() => DropdownButton<String>(
                        value: controller.selectedLanguage.value,
                        items: controller.languages.map((language) {
                          return DropdownMenuItem<String>(
                            value: language['code'],
                            child: Text(language['name']!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          controller.selectedLanguage.value = value!;
                        },
                      )),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Play & Stop Buttons
              Wrap( // Use Wrap instead of Row
                spacing: 8.0, // Space between buttons
                runSpacing: 8.0, // Space between rows
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      controller.speak();
                    },
                    icon: Icon(Icons.play_arrow, color: Theme.of(context).colorScheme.onSurface),
                    label: Text(
                      'Play',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      controller.stop();
                    },
                    icon: Icon(Icons.stop, color: Theme.of(context).colorScheme.onSurface),
                    label: Text(
                      'Stop',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                 
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
