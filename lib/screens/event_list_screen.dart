import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../screens/home_screen.dart';

class EventListScreen extends StatelessWidget {
  final String staffName;

  const EventListScreen({super.key, required this.staffName});

  void showProfileSheet(BuildContext context, String staffName) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Icon(Icons.account_circle,
                      size: 60, color: theme.colorScheme.primary),
                  const SizedBox(height: 8),
                  const Text('Нэвтэрсэн хэрэглэгч'),
                  const SizedBox(height: 4),
                  Text(
                    staffName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Системээс гарах'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: logout logic
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final events = [
      {
        "id": 1,
        "title": "Tech Summit 2025",
        "location": "Шангри-Ла зочид буудал, Улаанбаатар",
        "startTime": DateTime.parse("2025-06-10T02:00:00.000Z")
      },
      {
        "id": 2,
        "title": "Залуусын урлагийн наадам",
        "location": "Соёлын төв өргөө",
        "startTime": DateTime.parse("2025-07-01T06:00:00.000Z")
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Эвентүүд'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => showProfileSheet(context, staffName),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomeScreen(
                      staffName: staffName,
                      eventId: event["id"] as int,
                      eventName: event["title"] as String,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month,
                        size: 36, color: Color(0xFF347786)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(event["title"] as String,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat.yMMMMd('mn')
                                .format(event["startTime"] as DateTime),
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 4),
                          Text(event["location"] as String,
                              style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
