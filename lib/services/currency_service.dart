import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  final String _apiKey = '71bc26c575725c605440e878'; // Replace with your actual API key
  final String _baseUrl = 'https://v6.exchangerate-api.com/v6/';

  Future<Map<String, double>> fetchConversionRates() async {
    final url = '${_baseUrl}$_apiKey/latest/ETB'; // Endpoint to get rates based on ETB

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['result'] == 'success') {
          final conversionRates = data['conversion_rates'] as Map<String, dynamic>;
          return conversionRates.map((key, value) => MapEntry(key, value.toDouble()));
        } else {
          throw Exception('Failed to get conversion rates');
        }
      } else {
        throw Exception('Failed to load currency conversion rates');
      }
    } catch (e) {
      print('Failed to fetch conversion rates: $e');
      throw Exception('Failed to fetch conversion rates');
    }
  }

  double convertAmount(double amount, double rate) {
    return amount * rate;
  }
}
