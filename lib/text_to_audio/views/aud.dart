import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VoiceToTextWidget extends StatefulWidget {
  @override
  _VoiceToTextWidgetState createState() => _VoiceToTextWidgetState();
}

class _VoiceToTextWidgetState extends State<VoiceToTextWidget>
    with SingleTickerProviderStateMixin {
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  bool _isListening = false;
  String _text = "Press the button and start speaking";
  double _confidence = 1.0;
  late AnimationController _animationController;

  String _selectedLanguage = 'en-US';
  List<String> _languageOptions = ['en-US', 'es-ES', 'fr-FR'];
  List<String> _transcriptionHistory = [];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0.5,
      upperBound: 1.0,
    )..addListener(() {
        setState(() {});
      });
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          print('onStatus: $val');
          if (val == "notListening") {
            _restartListening();
          }
        },
        onError: (val) {
          print('onError: $val');
          _restartListening();
        },
      );
      if (available) {
        setState(() {
          _isListening = true;
        });
        _animationController.repeat(reverse: true);
        _startListening();
      }
    } else {
      setState(() {
        _isListening = false;
      });
      _speech.stop();
      _animationController.stop();
    }
  }

  void _startListening() {
    _speech.listen(
      localeId: _selectedLanguage, // Set the selected language
      onResult: (val) {
        setState(() {
          _text = val.recognizedWords;
          if (val.hasConfidenceRating && val.confidence > 0) {
            _confidence = val.confidence;
          }
        });
      },
    );
  }

  void _restartListening() {
    if (_isListening) {
      _speech.stop();
      _startListening();
    }
  }

  void _saveTranscription() {
    if (_text.isNotEmpty) {
      setState(() {
        _transcriptionHistory.add(_text);
      });
      _showSnackbar("Transcription saved!");
    }
  }

  void _clearText() {
    setState(() {
      _text = "Press the button and start speaking";
    });
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _text));
    _showSnackbar("Text copied to clipboard!");
  }

  void _speak() async {
    await _flutterTts.setLanguage(_selectedLanguage);
    await _flutterTts.speak(_text);
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voice to Text with Features')),
      body: Column(
        children: [
          DropdownButton<String>(
            value: _selectedLanguage,
            onChanged: (String? newValue) {
              setState(() {
                _selectedLanguage = newValue!;
              });
            },
            items: _languageOptions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Text(
            'Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%',
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Text(
                  _text,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: _saveTranscription,
              ),
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _clearText,
              ),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: _copyToClipboard,
              ),
              IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: _speak,
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text("Transcription History:"),
          Expanded(
            child: ListView.builder(
              itemCount: _transcriptionHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_transcriptionHistory[index]),
                  onTap: () {
                    setState(() {
                      _text = _transcriptionHistory[index];
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: _listen,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.2).animate(_animationController),
          child: FloatingActionButton(
            onPressed: _listen,
            child: Icon(_isListening ? Icons.mic : Icons.mic_none),
          ),
        ),
      ),
    );
  }
}
