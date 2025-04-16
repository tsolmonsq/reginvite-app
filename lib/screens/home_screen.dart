import 'package:flutter/material.dart';
import 'guests_tab_screen.dart';
import 'qr_scanner_page.dart';

class HomeScreen extends StatefulWidget {
  final String staffName;
  final int eventId;
  final String eventName;

  const HomeScreen({
    super.key,
    required this.staffName,
    required this.eventId,
    required this.eventName,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  final GlobalKey<GuestsTabScreenState> guestsTabKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final screens = [
      GuestsTabScreen(
        key: guestsTabKey,
        eventId: widget.eventId,
        eventName: widget.eventName,
      ),
      QRScannerPage(
        eventId: widget.eventId,
        onCheckInSuccess: () {
          guestsTabKey.currentState?.refreshGuestList();
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.eventName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Зочид',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'QR бүртгэл',
          ),
        ],
      ),
    );
  }
}
