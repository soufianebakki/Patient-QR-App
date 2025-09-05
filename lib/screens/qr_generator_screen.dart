import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:io';

class QRGeneratorScreen extends StatelessWidget {
  final double tension;
  final double glycemie;
  final double freqCardiaque;
  final double sommeil;
  final double douleur;
  final double hydration;
  final double stress;
  final String notes;
  final List<File> images;

  QRGeneratorScreen({
    required this.tension,
    required this.glycemie,
    required this.freqCardiaque,
    required this.sommeil,
    required this.douleur,
    required this.hydration,
    required this.stress,
    required this.notes,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    final qrData = "http://localhost:8000/user.html?id=user123";

    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Santé'),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Votre QR Code de Santé',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              QrImageView(data: qrData, version: QrVersions.auto, size: 250),
              SizedBox(height: 20),
              Text(
                'Scannez pour voir les données de santé.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),

              // Display images safely
              if (images.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Images associées :',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    ...images.map((imageFile) {
                      return FutureBuilder<bool>(
                        future: imageFile.exists(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasData && snapshot.data == true) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Image.file(imageFile, height: 150),
                            );
                          } else {
                            return Text('Image non trouvée: ${imageFile.path}');
                          }
                        },
                      );
                    }).toList(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
