import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRWidget extends StatelessWidget {
  final String data;
  final double size;
  final Color qrColor;
  const QRWidget(
    this.data, {
    this.size = 200.0,
    this.qrColor = Colors.white,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: 200.0,
      //embeddedImage: const AssetImage('assets/icon/icon.png'),
      embeddedImageStyle: QrEmbeddedImageStyle(size: const Size(80, 80)),
      foregroundColor: qrColor,
      backgroundColor: Colors.transparent,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
      padding: const EdgeInsets.all(0),
    );
  }
}
