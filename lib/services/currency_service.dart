import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  final String _apiKey = '971873f9d1e9b2d6303fc7e4'; 
  final String _baseUrl = 'https://v6.exchangerate-api.com/v6/';

  Future<Map<String, double>> fetchConversionRates() async {
    final url = '${_baseUrl}$_apiKey/latest/ETB'; 
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['result'] == 'success') {
          final conversionRates = data['conversion_rates'] as Map<String, dynamic>;
          return conversionRates.map((key, value) => MapEntry(key, value.toDouble()));
        } else {
          throw Exception('Error from API: ${data['error-type']}');
        }
      } else {
        throw Exception('Failed to load currency conversion rates. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to fetch conversion rates: $e');
    }
  }

  double convertAmount(double amount, double rate) {
    return amount * rate;
  }
}
