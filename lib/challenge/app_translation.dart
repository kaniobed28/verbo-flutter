import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'daily_challenges': 'Daily Challenges',
          'your_answer': 'Your answer:',
          'respond_now': 'Respond now',
          'listening': 'Listening...',
          'see_correct_answer': 'See correct answer',
          'correct_answer': 'Correct answer:',
          'next_question': 'Next question',
          'speech_rate': 'Speech rate:',
        },
        'fr_FR': {
          'daily_challenges': 'Défis Quotidiens',
          'your_answer': 'Votre réponse :',
          'respond_now': 'Répondre maintenant',
          'listening': 'Écoute en cours...',
          'see_correct_answer': 'Voir la réponse correcte',
          'correct_answer': 'Réponse correcte :',
          'next_question': 'Question suivante',
          'speech_rate': 'Vitesse de lecture :',
        },
      };
}
