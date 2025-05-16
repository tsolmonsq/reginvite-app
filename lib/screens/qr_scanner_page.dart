import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'guests_tab_screen.dart'; // импорт хийсэн эсэхээ шалгаарай

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

    controller.stop(); // QR scanner-г зогсооно

    final String? code = barcode.rawValue;

    if (code == null || !code.contains('/')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QR код буруу байна')),
      );
      controller.start();
      setState(() => isProcessing = false);
      return;
    }

  
    widget.onCheckInSuccess();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GuestsTabScreen(
          eventId: widget.eventId,
          eventName: "QR-р бүртгэгдсэн эвент",
        ),
      ),
    );

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
