import 'package:flutter/material.dart';

class Guest {
  final String fullName;
  final String email;
  final bool checkedIn;

  Guest({
    required this.fullName,
    required this.email,
    this.checkedIn = false,
  });
}

class GuestsTabScreen extends StatefulWidget {
  final int eventId;
  final String eventName;

  const GuestsTabScreen({
    super.key,
    required this.eventId,
    required this.eventName,
  });

  @override
  State<GuestsTabScreen> createState() => GuestsTabScreenState();
}

class GuestsTabScreenState extends State<GuestsTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Guest> _allGuests = [];
  List<Guest> _checkedInGuests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    refreshGuestList(); // энэ нэрийг home_screen.dart дээрээс дуудаж болно
  }

  /// ⏬ Энэ method-г гаднаас дуудаж болдог!
  void refreshGuestList() {
    setState(() {
      _allGuests = [
        Guest(
          fullName: 'Наранболд Зул',
          email: 'jenniesum10@gmail.com',
          checkedIn: false,
        ),
        Guest(
          fullName: 'Цолмон Батболд',
          email: 'tsolmonbatbold88@gmail.com',
          checkedIn: false, // "Бүх зочид" дээр ирээгүй
        ),
      ];

      _checkedInGuests = [
        Guest(
          fullName: 'Цолмон Батболд',
          email: 'tsolmonbatbold88@gmail.com',
          checkedIn: true, // "Ирсэн зочид" дээр ирсэн
        ),
      ];

      _isLoading = false;
    });
  }

  Widget buildGuestList(List<Guest> guests) {
    if (guests.isEmpty) {
      return const Center(child: Text('Зочин олдсонгүй'));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: guests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final guest = guests[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: guest.checkedIn ? Colors.green : Colors.grey[300]!,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05), 
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            title: Text(guest.fullName),
            subtitle: Text(guest.email),
            trailing: Icon(
              guest.checkedIn
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: guest.checkedIn ? Colors.green : Colors.grey,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              Tab(text: 'Бүх зочид'),
              Tab(text: 'Ирсэн зочид'),
            ],
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      buildGuestList(_allGuests),
                      buildGuestList(_checkedInGuests),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
