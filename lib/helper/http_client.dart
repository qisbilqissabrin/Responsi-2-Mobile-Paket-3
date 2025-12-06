import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpClient {
  static const int timeoutSeconds = 10;

  // Helper method untuk GET request
  static Future<dynamic> get(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: timeoutSeconds),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Helper method untuk POST request
  static Future<dynamic> post(String url, {Map<String, dynamic>? body}) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body != null ? jsonEncode(body) : null,
      ).timeout(
        const Duration(seconds: timeoutSeconds),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Helper method untuk PUT request
  static Future<dynamic> put(String url, {Map<String, dynamic>? body}) async {
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body != null ? jsonEncode(body) : null,
      ).timeout(
        const Duration(seconds: timeoutSeconds),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Helper method untuk DELETE request
  static Future<dynamic> delete(String url) async {
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: timeoutSeconds),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Handle response dengan error checking
  static dynamic _handleResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return data;
      } else {
        throw Exception('Server error: ${response.statusCode} - ${data['message'] ?? response.reasonPhrase}');
      }
    } catch (e) {
      if (response.statusCode >= 400) {
        throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
      rethrow;
    }
  }
}
