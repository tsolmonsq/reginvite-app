import 'package:flutter/material.dart';
import '../repositories/event_repository.dart';
import '../models/event.dart';

class EventListViewModel extends ChangeNotifier {
  final EventRepository repository;
  List<Event> events = [];
  bool isLoading = false;
  String? error;

  EventListViewModel(this.repository);

  Future<void> loadEvents() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await repository.fetchEvents();
      events = (response['items'] as List)
          .map((eventJson) => Event.fromJson(eventJson))
          .toList();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }
}
