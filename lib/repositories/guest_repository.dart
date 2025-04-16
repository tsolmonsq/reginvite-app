import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/guest.dart';
import '../services/auth_service.dart';

class GuestRepository {
  final String baseUrl = 'https://reginvite-backend.onrender.com';

  Future<List<Guest>> fetchGuests(int eventId) async {
    final token = await AuthService.getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final url = Uri.parse('$baseUrl/guests?eventId=$eventId&page=1&limit=100');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List guests = jsonData['data'];
      return guests.map((e) => Guest.fromJson(e)).toList();
    } else {
      throw Exception('Зочдын жагсаалтыг авч чадсангүй');
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
