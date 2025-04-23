import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reginvite_app/models/guest.dart';
import 'package:reginvite_app/services/auth_service.dart';

class GuestRepository {
  final String baseUrl = 'https://reginvite-backend.onrender.com';

  Future<List<Guest>> fetchSentGuests(int eventId) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Токен олдсонгүй. Нэвтэрсэн эсэхээ шалгана уу.');
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final uri = Uri.parse('$baseUrl/guests').replace(queryParameters: {
      'eventId': '$eventId',
      'status': 'Sent',
    });

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List;
      return data.map((e) => Guest.fromJson(e)).toList();
    } else {
      throw Exception('Sent зочдыг татахад алдаа гарлаа');
    }
  }

  Future<Map<String, dynamic>> checkInGuest(String qrToken) async {
    final token = await AuthService.getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final url = Uri.parse('$baseUrl/guests/checkin/$qrToken');
    final response = await http.post(url, headers: headers);

    print('[CHECK-IN] Status: ${response.statusCode}');
    print('[CHECK-IN] Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = json.decode(response.body);
      return {
        'success': true,
        'message': body['message'],
        'guest': body['guest'],
      };
    } else {
      return {
        'success': false,
        'message': 'Бүртгэхэд алдаа гарлаа',
      };
    }
  }
}
