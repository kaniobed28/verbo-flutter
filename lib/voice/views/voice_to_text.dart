import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readit/reusable/custom_appbar.dart';
import 'package:readit/voice/controllers/voice_controller.dart';

class VoiceToTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final VoiceController controller = Get.put(VoiceController());

    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language Selector
            Obx(() => Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: controller.selectedLanguage.value,
                  onChanged: (String? newValue) {
                    controller.selectedLanguage.value = newValue!;
                  },
                  items: controller.languageOptions.entries.map<DropdownMenuItem<String>>((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.value, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                    );
                  }).toList(),
                ),
              ),
            )),

            // Confidence Level
            Obx(() => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Confidence: ${(controller.confidence.value * 100.0).toStringAsFixed(1)}%',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            )),

            // Transcribed Text Display
            Expanded(
              child: Center(
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Obx(() => SingleChildScrollView(
                      child: Text(
                        controller.text.value,
                        style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.primary),
                        textAlign: TextAlign.center, // Center-align the text
                      ),
                    )),
                  ),
                ),
              ),
            ),

            // Buttons for various actions
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: OverflowBar(
                alignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.save),
                        onPressed: () {
                          if (controller.isListening.value) {
                            controller.listen();
                          }
                          controller.saveTranscription();
                        },
                      ),
                      Text('Save', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          if (controller.isListening.value) {
                            controller.listen();
                          }
                          controller.clearText();
                        },
                      ),
                      Text('Clear', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          if (controller.isListening.value) {
                            controller.listen();
                          }
                          controller.copyToClipboard();
                        },
                      ),
                      const Text('Copy', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: () {
                          if (controller.isListening.value) {
                            controller.listen();
                          }
                          controller.speak();
                        },
                      ),
                      const Text('Play', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            const Text("Transcription History:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            // Transcription History
            Expanded(
              child: Obx(() => ListView.builder(
                itemCount: controller.transcriptionHistory.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    child: ListTile(
                      title: Text(
                        controller.transcriptionHistory[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                      onTap: () {
                        controller.text.value = controller.transcriptionHistory[index];
                      },
                    ),
                  );
                },
              )),
            ),
          ],
        ),
      ),

      // Floating button for speech-to-text functionality
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: GestureDetector(
        onTap: controller.listen,
        child: Obx(() => CircleAvatar(
          radius: 30,
          backgroundColor: controller.isListening.value ? Colors.red : Colors.blue,
          child: Icon(
            controller.isListening.value ? Icons.stop : Icons.mic,
            color: Colors.white,
          ),
        )),
      ),
    );
  }
}
