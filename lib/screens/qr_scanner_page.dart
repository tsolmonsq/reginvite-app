import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../repositories/guest_repository.dart';

class QRScannerPage extends StatelessWidget {
  final int eventId;
  final VoidCallback onCheckInSuccess;

  QRScannerPage({
    super.key,
    required this.eventId,
    required this.onCheckInSuccess,
  });

  final MobileScannerController controller = MobileScannerController();

  void handleDetection(BuildContext context, Barcode barcode) async {
    controller.stop();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    await Future.delayed(const Duration(seconds: 1));

    final String? code = barcode.rawValue;
    if (code == null) {
      Navigator.pop(context);
      controller.start();
      return;
    }

    final token = code.split('/').last;
    final result = await GuestRepository().checkInGuest(token);

    Navigator.pop(context);

    if (result['success'] == true) {
      onCheckInSuccess();
      Navigator.pop(context);
    } else {
      controller.start();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'] ?? '')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR сканнер')),
      body: MobileScanner(
        controller: controller,
        onDetect: (capture) {
          final barcode = capture.barcodes.first;
          handleDetection(context, barcode);
        },
      ),
    );
  }
}
