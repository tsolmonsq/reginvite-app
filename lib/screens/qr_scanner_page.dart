// qr_scanner_page.dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../repositories/guest_repository.dart';

class QRScannerPage extends StatefulWidget {
  final int eventId;
  final VoidCallback onCheckInSuccess;

  const QRScannerPage({
    super.key,
    required this.eventId,
    required this.onCheckInSuccess,
  });

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final MobileScannerController controller = MobileScannerController();
  bool isProcessing = false;

  void handleDetection(BuildContext context, Barcode barcode) async {
    if (isProcessing) return;
    setState(() => isProcessing = true);

    controller.stop();

    final String? code = barcode.rawValue;
    if (code == null || !code.contains('/')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QR код буруу байна')),
      );
      controller.start();
      setState(() => isProcessing = false);
      return;
    }

    final token = code.split('/').last;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final repo = GuestRepository();
      final result = await repo.checkInGuest(token);

      Navigator.pop(context); // Close loader

      if (result['success']) {
        widget.onCheckInSuccess();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Амжилттай бүртгэгдлээ')),
        );
        Navigator.pop(context);
      } else {
        controller.start();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Амжилтгүй боллоо')),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      controller.start();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Алдаа: $e')),
      );
    }

    setState(() => isProcessing = false);
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
