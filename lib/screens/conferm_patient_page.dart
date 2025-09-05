// screens/emergency_info_page.dart
import 'package:flutter/material.dart';
import 'visit_reason_page.dart';

class ConfirmationPage extends StatelessWidget {
  final Map<String, dynamic> healthData;

  // ignore: use_super_parameters
  const ConfirmationPage({Key? key, required this.healthData})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fiche d'Urgence"),
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
                      "Votre Fiche d'Urgence",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade800,
                      ),
                    ),
                    Text(
                      "Ces informations seront visibles en cas d'urgence",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildEmergencyInfoCard("Informations Personnelles", [
              _buildInfoRow(
                "Nom Complet",
                healthData['fullName'] ?? 'Non renseigné',
              ),
              _buildInfoRow(
                "Date de Naissance",
                healthData['dateOfBirth'] ?? 'Non renseigné',
              ),
              _buildInfoRow("Genre", healthData['gender'] ?? 'Non renseigné'),
              _buildInfoRow(
                "Groupe Sanguin",
                healthData['bloodType'] ?? 'Non renseigné',
              ),
              _buildInfoRow(
                "Situation Matrimoniale",
                healthData['maritalStatus'] ?? 'Non renseigné',
              ),
              _buildInfoRow(
                "Enfants",
                healthData['hasChildren'] ?? 'Non renseigné',
              ),
              _buildInfoRow("Origine", healthData['origin'] ?? 'Non renseigné'),
            ]),
            const SizedBox(height: 16),
            _buildEmergencyInfoCard("Contacts d'Urgence", [
              _buildInfoRow(
                "Nom du Contact",
                healthData['emergencyContactName'] ?? 'Non renseigné',
              ),
              _buildInfoRow(
                "Téléphone",
                healthData['emergencyPhone'] ?? 'Non renseigné',
              ),
            ]),
            const SizedBox(height: 24),
            // In the ElevatedButton section of emergency_info_page.dart
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => VisitReasonPage(healthData: healthData),
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

  Widget _buildEmergencyInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade700,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: TextStyle(color: Colors.grey.shade800)),
          ),
        ],
      ),
    );
  }
}
