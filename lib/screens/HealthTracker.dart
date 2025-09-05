import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:image_picker/image_picker.dart';
import 'qr_generator_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HealthTrackerScreen(),
    );
  }
}

class HealthTrackerScreen extends StatefulWidget {
  @override
  _HealthTrackerScreenState createState() => _HealthTrackerScreenState();
}

class _HealthTrackerScreenState extends State<HealthTrackerScreen> {
  double _tension = 120;
  double _glycemie = 90;
  double _freqCardiaque = 72;
  double _sommeil = 7;
  double _douleur = 2;
  double _hydration = 8;
  double _stressLevel = 3;
  String _notes = '';
  List<File> _uploadedImages = [];

  Map<String, double> getHealthPercentages() {
    return {
      'Tension': (_tension >= 110 && _tension <= 130) ? 80 : 50,
      'Glycémie': (_glycemie >= 70 && _glycemie <= 100) ? 60 : 30,
      'Fréquence Cardiaque':
          (_freqCardiaque >= 60 && _freqCardiaque <= 80) ? 90 : 60,
      'Sommeil': (_sommeil >= 7) ? 70 : 40,
      'Douleur': (10 - _douleur) * 10,
      'Hydratation': _hydration * 10,
      'Stress': (10 - _stressLevel) * 10,
    };
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _uploadedImages.add(File(pickedFile.path));
      });
    }
  }

  Widget _buildImageUploadSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Documents Médicaux',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Vous pouvez ajouter des photos de vos médicaments, résultats de tests, ou ordonnances',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.upload_file),
              label: Text('Ajouter une photo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            if (_uploadedImages.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Photos ajoutées:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _uploadedImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Stack(
                            children: [
                              Image.file(
                                _uploadedImages[index],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(Icons.close, size: 20),
                                  color: Colors.red,
                                  onPressed: () {
                                    setState(() {
                                      _uploadedImages.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Color _getColorForValue(double value) {
    if (value >= 80) return Colors.green;
    if (value >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getHealthStatusMessage(double value) {
    if (value >= 80) return 'Votre santé est excellente.';
    if (value >= 60) return 'Votre santé est correcte, surveillez-la.';
    return 'Des améliorations sont nécessaires, consultez un médecin.';
  }

  Widget _buildNotesSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Ajoutez vos remarques ici...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _notes = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderInput(
    String label,
    double value,
    double min,
    double max,
    IconData icon,
    Function(double) onChanged,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.blue),
            SizedBox(width: 10),
            Text(label),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          label: value.toStringAsFixed(1),
          onChanged: (val) => setState(() => onChanged(val)),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildHealthInputForm() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Entrez vos données santé',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildSliderInput(
              'Tension (mmHg)',
              _tension,
              70,
              200,
              Icons.monitor_heart,
              (val) => _tension = val,
            ),
            _buildSliderInput(
              'Glycémie (mg/dL)',
              _glycemie,
              50,
              200,
              Icons.bloodtype,
              (val) => _glycemie = val,
            ),
            _buildSliderInput(
              'Fréquence Cardiaque (bpm)',
              _freqCardiaque,
              40,
              120,
              Icons.favorite,
              (val) => _freqCardiaque = val,
            ),
            _buildSliderInput(
              'Sommeil (heures)',
              _sommeil,
              0,
              12,
              Icons.nightlight_round,
              (val) => _sommeil = val,
            ),
            _buildSliderInput(
              'Douleur (0-10)',
              _douleur,
              0,
              10,
              Icons.sick,
              (val) => _douleur = val,
            ),
            _buildSliderInput(
              'Hydratation (0-10)',
              _hydration,
              0,
              10,
              Icons.water_drop,
              (val) => _hydration = val,
            ),
            _buildSliderInput(
              'Niveau de Stress (0-10)',
              _stressLevel,
              0,
              10,
              Icons.mood,
              (val) => _stressLevel = val,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualizations(Map<String, double> healthData) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Statistiques de Santé',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final key = healthData.keys.toList()[value.toInt()];
                          return Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              key.split(' ').first,
                              style: TextStyle(fontSize: 10),
                            ),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget:
                            (value, meta) => Text('${value.toInt()}%'),
                      ),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                  barGroups:
                      healthData.entries.map((entry) {
                        final index = healthData.keys.toList().indexOf(
                          entry.key,
                        );
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value,
                              width: 20,
                              color: _getColorForValue(entry.value),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final healthData = getHealthPercentages();
    final averageHealth =
        healthData.values.reduce((a, b) => a + b) / healthData.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Suivi Santé Complet',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Résumé de Santé',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    CircularProgressIndicator(
                      value: averageHealth / 100,
                      strokeWidth: 10,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getColorForValue(averageHealth),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${averageHealth.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _getHealthStatusMessage(averageHealth),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildHealthInputForm(),
            SizedBox(height: 20),
            _buildVisualizations(healthData),
            SizedBox(height: 20),
            _buildImageUploadSection(),
            SizedBox(height: 20),
            _buildNotesSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => QRGeneratorScreen(
                    tension: _tension,
                    glycemie: _glycemie,
                    freqCardiaque: _freqCardiaque,
                    sommeil: _sommeil,
                    douleur: _douleur,
                    hydration: _hydration,
                    stress: _stressLevel,
                    notes: _notes,
                    images: _uploadedImages,
                  ),
            ),
          );
        },
        icon: Icon(Icons.qr_code),
        label: Text('Générer QR Code'),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
