import 'package:flutter/material.dart';
import 'package:reginvite_app/services/auth_service.dart';
import '../models/event.dart';
import '../repositories/event_repository.dart';

class EventListViewModel extends ChangeNotifier {
  final EventRepository _repository;

  EventListViewModel(this._repository);

  List<Event> _events = [];
  bool _isLoading = false;
  String? _error;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadEvents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await AuthService.getToken();
      if (token == null) {
        print('token >>>: $token');
      }
      _events = await _repository.fetchEvents();
    } catch (e) {
      print('🚨 Event fetch error: $e');
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
