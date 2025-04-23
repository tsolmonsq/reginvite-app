import 'package:flutter/material.dart';
import '../models/guest.dart';
import '../repositories/guest_repository.dart';
import 'qr_scanner_page.dart';

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
  List<Guest> _guests = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    refreshGuestList();
  }

  Future<void> refreshGuestList() async {
    setState(() => _isLoading = true);
    try {
      final guests = await GuestRepository().fetchSentGuests(widget.eventId);
      setState(() {
        _guests = guests;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Widget buildGuestList(List<Guest> guests) {
    if (guests.isEmpty) return const Center(child: Text('Зочин олдсонгүй'));
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
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
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
    final checkedInGuests = _guests.where((g) => g.checkedIn).toList();

    return Column(
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
              : _error != null
                  ? Center(child: Text('Алдаа: $_error'))
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        buildGuestList(_guests),
                        buildGuestList(checkedInGuests),
                      ],
                    ),
        ),
      ],
    );
  }
}
