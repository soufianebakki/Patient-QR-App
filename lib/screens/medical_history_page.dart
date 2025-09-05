import 'package:flutter/material.dart';
import 'medication_info_page.dart';

class MedicalHistoryPage extends StatefulWidget {
  final Map<String, dynamic> healthData;

  const MedicalHistoryPage({Key? key, required this.healthData})
    : super(key: key);

  @override
  _MedicalHistoryPageState createState() => _MedicalHistoryPageState();
}

class _MedicalHistoryPageState extends State<MedicalHistoryPage> {
  final TextEditingController _chronicDiseasesController =
      TextEditingController();
  final TextEditingController _surgeriesController = TextEditingController();
  final TextEditingController _seriousIllnessesController =
      TextEditingController();

  @override
  void dispose() {
    _chronicDiseasesController.dispose();
    _surgeriesController.dispose();
    _seriousIllnessesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historique Médical"),
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
                      Icons.medical_information,
                      size: 48,
                      color: Colors.teal.shade700,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Historique Médical",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade800,
                      ),
                    ),
                    Text(
                      "Veuillez partager vos antécédents médicaux importants",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildMedicalHistoryCard(
              "🧾 Souffrez-vous de maladies chroniques? (diabète, hypertension...)",
              _chronicDiseasesController,
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            _buildMedicalHistoryCard(
              "Avez-vous subi des interventions chirurgicales?",
              _surgeriesController,
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            _buildMedicalHistoryCard(
              "Avez-vous eu des maladies graves ou infectieuses?",
              _seriousIllnessesController,
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => MedicationInfoPage(
                          healthData: {
                            'chronic_diseases': _chronicDiseasesController.text,
                            'surgeries': _surgeriesController.text,
                            'serious_illnesses':
                                _seriousIllnessesController.text,
                          },
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
                'TERMINER',
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

  Widget _buildMedicalHistoryCard(
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
