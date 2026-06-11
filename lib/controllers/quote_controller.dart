import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteController {
  // Citation locale de secours — affichée si l'API est inaccessible
  static const String _fallbackQuote =
      "La clé du succès est de concentrer votre conscience sur les choses désirées et non sur les choses non désirées.";
  static const String _fallbackAuthor = "Brian Tracy";

  // Utilise l'API publique ZenQuotes (gratuite, sans clé API)
  // Endpoint : https://zenquotes.io/api/today
  // Réponse  : [{"q": "...", "a": "Auteur"}]
  Future<Map<String, String>> fetchQuote() async {
    try {
      final response = await http
          .get(Uri.parse('https://zenquotes.io/api/today'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        if (data.isNotEmpty) {
          final quote = data[0]['q'] as String? ?? _fallbackQuote;
          final author = data[0]['a'] as String? ?? 'Anonyme';
          return {'quote': quote, 'author': author};
        }
      }
    } catch (_) {
      // Erreur réseau, timeout ou parsing — on retourne la citation locale
      // L'application continue de fonctionner normalement
    }

    return {'quote': _fallbackQuote, 'author': _fallbackAuthor};
  }
}
