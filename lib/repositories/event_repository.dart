import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reginvite_app/services/auth_service.dart';
import '../models/event.dart';

class EventRepository {
  final String baseUrl = 'https://reginvite-new-backend.onrender.com/';

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
      Uri.parse('$baseUrl/events/private'),
      headers: headers,
    );

    print("📡 [TOKEN] $token");
    print("📡 [STATUS] ${response.statusCode}");
    print("📡 [BODY] ${response.body}");

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> result = json.decode(response.body);
        final List<dynamic> eventList = result['data'];

        // Ensure the event list is not empty or null
        if (eventList.isEmpty) {
          throw Exception('Эвентүүд олдсонгүй.');
        }

        return eventList.map((e) => Event.fromJson(e)).toList();
      } catch (e) {
        print("📡 [ERROR] Error parsing event data: $e");
        throw Exception('Өгөгдлийг засахад алдаа гарлаа.');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Нэвтрэх эрхгүй, дахин нэвтэрнэ үү.');
    } else if (response.statusCode == 404) {
      throw Exception('Эвентүүдийг олоход алдаа гарлаа, сервертэй холбогдож чадсангүй.');
    } else {
      throw Exception('Эвентүүдийг авч чадсангүй, статус код: ${response.statusCode}');
    }
  }
}
