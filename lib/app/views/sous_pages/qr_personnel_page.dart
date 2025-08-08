import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;
import '../../models/personnel_model.dart';

class QrPersonnelPage extends StatelessWidget {
  final Personnel personnel;
  const QrPersonnelPage({Key? key, required this.personnel}) : super(key: key);

  Future<Uint8List> _generateQrPdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(personnel.nomComplet, style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 32),
              pw.Container(
                width: 240,
                height: 240,
                child: pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: personnel.uuid,
                  width: 240,
                  height: 240,
                ),
              ),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  void _downloadQrPdf(BuildContext context) async {
    final pdfData = await _generateQrPdf();
    await Printing.sharePdf(bytes: pdfData, filename: 'qr_${personnel.nomComplet}.pdf');
  }

  Future<void> _showDownloadOptions(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.picture_as_pdf, color: Colors.red),
              title: Text('Télécharger en PDF'),
              onTap: () {
                Navigator.pop(ctx);
                _downloadQrPdf(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.image, color: Colors.green),
              title: Text('Télécharger en JPEG'),
              onTap: () {
                Navigator.pop(ctx);
                _downloadQrJpeg(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadQrJpeg(BuildContext context) async {
    final qrValidationResult = QrValidator.validate(
      data: personnel.uuid,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );
    final qrCode = qrValidationResult.qrCode;
    if (qrCode == null) return;
    final painter = QrPainter.withQr(
      qr: qrCode,
      color: const Color(0xFF000000),
      emptyColor: const Color(0xFFFFFFFF),
      gapless: true,
    );
    final image = await painter.toImage(600);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();
    // Suppression de l'écriture sur le disque, partage direct
    await Printing.sharePdf(bytes: bytes, filename: 'qr_${personnel.nomComplet}.jpg');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              personnel.nomComplet,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            QrImageView(
              data: personnel.uuid,
              version: QrVersions.auto,
              size: 240.0,
            ),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showDownloadOptions(context),
                icon: Icon(Icons.download),
                label: Text('Télécharger le QR code'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
