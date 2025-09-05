import 'package:flutter/material.dart';
import 'medical_history_page.dart';

class CurrentSymptomsPage extends StatefulWidget {
  final Map<String, dynamic> healthData;

  const CurrentSymptomsPage({Key? key, required this.healthData})
    : super(key: key);

  @override
  _CurrentSymptomsPageState createState() => _CurrentSymptomsPageState();
}

class _CurrentSymptomsPageState extends State<CurrentSymptomsPage> {
  final TextEditingController _currentSymptomsController =
      TextEditingController();
  final TextEditingController _symptomsChangeController =
      TextEditingController();
  final TextEditingController _symptomsTriggersController =
      TextEditingController();
  final TextEditingController _additionalSymptomsController =
      TextEditingController();

  @override
  void dispose() {
    _currentSymptomsController.dispose();
    _symptomsChangeController.dispose();
    _symptomsTriggersController.dispose();
    _additionalSymptomsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Symptômes Actuels"),
        backgroundColor: Colors.teal.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.medical_services,
                      size: 48,
                      color: Colors.teal.shade700,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Détails des Symptômes",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade800,
                      ),
                    ),
                    Text(
                      "Veuillez décrire vos symptômes actuels en détail",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSymptomCard(
              "⚠️ Quels symptômes ressentez-vous actuellement?",
              _currentSymptomsController,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _buildSymptomCard(
              "Est-ce que vos symptômes changent avec le temps? (augmentent/diminuent/restez stables)",
              _symptomsChangeController,
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            _buildSymptomCard(
              "Y a-t-il quelque chose qui aggrave ou soulage vos symptômes?",
              _symptomsTriggersController,
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            _buildSymptomCard(
              "Avez-vous d'autres symptômes? (fièvre, nausées, vertiges...)",
              _additionalSymptomsController,
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            // In the ElevatedButton section of current_symptoms_page.dart
            ElevatedButton(
              onPressed: () {
                // Collect symptoms data
                final symptomsData = {
                  'currentSymptoms': _currentSymptomsController.text,
                  'symptomsChange': _symptomsChangeController.text,
                  'symptomsTriggers': _symptomsTriggersController.text,
                  'additionalSymptoms': _additionalSymptomsController.text,
                };

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => MedicalHistoryPage(
                          healthData: {...widget.healthData, ...symptomsData},
                        ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'SUIVANT',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomCard(
    String question,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              maxLines: maxLines,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
