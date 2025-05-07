import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reginvite_app/services/auth_service.dart';
import '../models/event.dart';

class EventRepository {
  final String baseUrl = 'http://localhost:3002';

  Future<List<Event>> fetchEvents() async {
    final token = await AuthService.getToken();

    if (token == null) {
      throw Exception('Токен олдсонгүй, нэвтэрсэн эсэхээ шалгана уу.');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('$baseUrl/events'),
      headers: headers,
    );

    print("📡 [TOKEN] $token");
    print("📡 [STATUS] ${response.statusCode}");
    print("📡 [BODY] ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> result = json.decode(response.body);
      final List<dynamic> eventList = result['data']; // 👈 зөв зам

      return eventList.map((e) => Event.fromJson(e)).toList();
    } else {
      throw Exception('Эвентүүдийг авч чадсангүй');
    }
  }
}
