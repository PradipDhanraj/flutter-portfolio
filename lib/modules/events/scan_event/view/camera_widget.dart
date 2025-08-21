import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQRWidget extends StatefulWidget {
  static String path = '/scan-qr';
  const ScanQRWidget({super.key});

  @override
  State<ScanQRWidget> createState() => _ScanQRWidgetState();
}

class _ScanQRWidgetState extends State<ScanQRWidget>
    with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController(
    cameraResolution: Size.square(300),
    formats: [BarcodeFormat.qrCode],
    autoZoom: true,
    autoStart: false,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(controller.start());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the controller is not ready, do not try to start or stop it.
    // Permission dialogs can trigger lifecycle changes before the controller is ready.
    if (!controller.value.hasCameraPermission) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        unawaited(controller.start());
      case AppLifecycleState.inactive:
        unawaited(controller.stop());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) async {
              // Handle QR code detection
              debugPrint('QR Code detected: ${capture.barcodes}');
              if (GoRouter.of(context).state.path == ScanQRWidget.path) {
                GoRouter.of(context).pop(capture.barcodes.first.rawValue);
              }
            },
          ),
          Positioned(
            top: 80,
            left: 10,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                GoRouter.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
