class Event {
  final int id;
  final String title;
  final String description;
  final String location;
  final DateTime startTime;
  final DateTime endTime;
  final bool isPublic;
  final String category;
  final String imagePath;
  final DateTime createdAt;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.isPublic,
    required this.category,
    required this.imagePath,
    required this.createdAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['name'],
      description: json['description'],
      location: json['location'],
      startTime: DateTime.parse(json['start_date']),
      endTime: DateTime.parse(json['end_date']),
      isPublic: json['is_public'],
      category: json['category'],
      imagePath: json['image_path'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
