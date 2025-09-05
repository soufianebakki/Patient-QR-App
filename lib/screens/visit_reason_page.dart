import 'package:flutter/material.dart';
import 'current_symptoms_page.dart';

class VisitReasonPage extends StatefulWidget {
  final Map<String, dynamic> healthData;

  const VisitReasonPage({Key? key, required this.healthData}) : super(key: key);

  @override
  _VisitReasonPageState createState() => _VisitReasonPageState();
}

class _VisitReasonPageState extends State<VisitReasonPage> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _symptomDurationController =
      TextEditingController();
  String? _firstTimeExperience;

  final List<String> _experienceOptions = [
    'Oui',
    'Non',
    'Je ne suis pas sûr(e)',
  ];

  @override
  void dispose() {
    _reasonController.dispose();
    _symptomDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Raison de la Visite"),
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
                      "Informations sur la Consultation",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade800,
                      ),
                    ),
                    Text(
                      "Veuillez fournir des détails sur votre état actuel",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildQuestionCard(
              "Quelle est la raison de votre visite chez le médecin aujourd'hui?",
              _reasonController,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _buildQuestionCard(
              "Depuis combien de temps avez-vous ces symptômes?",
              _symptomDurationController,
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Est-ce la première fois que vous ressentez ces symptômes?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._experienceOptions.map(
                      (option) => RadioListTile<String>(
                        title: Text(option),
                        value: option,
                        groupValue: _firstTimeExperience,
                        onChanged: (value) {
                          setState(() {
                            _firstTimeExperience = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // In the ElevatedButton section of visit_reason_page.dart
            ElevatedButton(
              onPressed: () {
                // Collect visit reason data
                final visitData = {
                  'visitReason': _reasonController.text,
                  'symptomDuration': _symptomDurationController.text,
                  'firstTimeExperience': _firstTimeExperience,
                };

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => CurrentSymptomsPage(
                          healthData: {...widget.healthData, ...visitData},
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

  Widget _buildQuestionCard(
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
