import 'dart:convert';
//import 'dart:js_interop';
import 'package:http/http.dart' as http;

class QuoteService {
  static const String _baseUrl = 'https://zenquotes.io/api';

  Future<String> fetchRandomQuote() async {
    final response = await http.get(Uri.parse('$_baseUrl/random'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data[0]['q'];
    } else {
      throw Exception('Failed to load quote');
    }
  }

  Future<String> fetchTodayQuote() async {
    final response = await http.get(Uri.parse('$_baseUrl/today'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data[0]['q'];
    } else {
      throw Exception('Failed to load quote');
    }
  }
}
