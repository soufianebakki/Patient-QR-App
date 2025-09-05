import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'qr_generator_screen.dart'; // Update path if needed

class ImagePickerScreen extends StatefulWidget {
  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  List<File> selectedImages = [];

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedImages.add(File(picked.path));
      });
    }
  }

  void generateQRCode() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRGeneratorScreen(
          tension: 12.3,
          glycemie: 5.4,
          freqCardiaque: 72,
          sommeil: 7,
          douleur: 2,
          hydration: 1.5,
          stress: 3,
          notes: "Rien à signaler",
          images: selectedImages,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter une image")),
      body: Column(
        children: [
          ElevatedButton.icon(
            onPressed: pickImage,
            icon: Icon(Icons.image),
            label: Text("Choisir une image"),
          ),
          SizedBox(height: 20),
          if (selectedImages.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: selectedImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(selectedImages[index], height: 150),
                  );
                },
              ),
            ),
          ElevatedButton(
            onPressed: generateQRCode,
            child: Text("Générer le QR Code"),
          ),
        ],
      ),
    );
  }
}
