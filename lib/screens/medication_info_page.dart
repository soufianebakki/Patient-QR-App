import 'package:flutter/material.dart';
import 'doctor_emergency_interface.dart';

class MedicationInfoPage extends StatefulWidget {
  final Map<String, dynamic> healthData;

  const MedicationInfoPage({super.key, required this.healthData});

  @override
  State<MedicationInfoPage> createState() => _MedicationInfoPageState();
}

class _MedicationInfoPageState extends State<MedicationInfoPage> {
  bool? _isUsingMedication;
  bool? _hasAllergies;
  bool? _receivedTreatmentBefore;
  String? _treatmentEffectiveness;
  final _medicationController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _previousTreatmentController = TextEditingController();

  @override
  void dispose() {
    _medicationController.dispose();
    _allergiesController.dispose();
    _previousTreatmentController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    if (_isUsingMedication == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Veuillez répondre à la question sur les médicaments actuels',
          ),
        ),
      );
      return false;
    }

    if (_hasAllergies == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez répondre à la question sur les allergies'),
        ),
      );
      return false;
    }

    if (_receivedTreatmentBefore == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Veuillez répondre à la question sur les traitements antérieurs',
          ),
        ),
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💊 Médicaments'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/medical_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Current medication question
                    const Text(
                      'Utilisez-vous actuellement des médicaments?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ChoiceChip(
                          label: const Text('Oui'),
                          selected: _isUsingMedication == true,
                          onSelected: (selected) {
                            setState(() {
                              _isUsingMedication = selected ? true : null;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('Non'),
                          selected: _isUsingMedication == false,
                          onSelected: (selected) {
                            setState(() {
                              _isUsingMedication = selected ? false : null;
                              if (!selected) _medicationController.clear();
                            });
                          },
                        ),
                      ],
                    ),
                    if (_isUsingMedication == true) ...[
                      const SizedBox(height: 8),
                      TextField(
                        controller: _medicationController,
                        decoration: const InputDecoration(
                          hintText:
                              'Veuillez indiquer les médicaments que vous prenez',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                    ],
                    const SizedBox(height: 24),

                    // Allergies question
                    const Text(
                      'Avez-vous des allergies médicamenteuses?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ChoiceChip(
                          label: const Text('Oui'),
                          selected: _hasAllergies == true,
                          onSelected: (selected) {
                            setState(() {
                              _hasAllergies = selected ? true : null;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('Non'),
                          selected: _hasAllergies == false,
                          onSelected: (selected) {
                            setState(() {
                              _hasAllergies = selected ? false : null;
                              if (!selected) _allergiesController.clear();
                            });
                          },
                        ),
                      ],
                    ),
                    if (_hasAllergies == true) ...[
                      const SizedBox(height: 8),
                      TextField(
                        controller: _allergiesController,
                        decoration: const InputDecoration(
                          hintText:
                              'Veuillez préciser les médicaments auxquels vous êtes allergique',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                    ],
                    const SizedBox(height: 24),

                    // Previous treatment question
                    const Text(
                      'Avez-vous déjà reçu un traitement pour cette condition?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ChoiceChip(
                          label: const Text('Oui'),
                          selected: _receivedTreatmentBefore == true,
                          onSelected: (selected) {
                            setState(() {
                              _receivedTreatmentBefore = selected ? true : null;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('Non'),
                          selected: _receivedTreatmentBefore == false,
                          onSelected: (selected) {
                            setState(() {
                              _receivedTreatmentBefore =
                                  selected ? false : null;
                              if (!selected) {
                                _previousTreatmentController.clear();
                                _treatmentEffectiveness = null;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    if (_receivedTreatmentBefore == true) ...[
                      const SizedBox(height: 8),
                      TextField(
                        controller: _previousTreatmentController,
                        decoration: const InputDecoration(
                          hintText: 'Veuillez décrire le traitement précédent',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Était-il efficace?',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _treatmentEffectiveness,
                        items: const [
                          DropdownMenuItem(
                            value: 'very_effective',
                            child: Text('Oui, très efficace'),
                          ),
                          DropdownMenuItem(
                            value: 'somewhat_effective',
                            child: Text('Partiellement efficace'),
                          ),
                          DropdownMenuItem(
                            value: 'not_effective',
                            child: Text('Non, pas efficace'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _treatmentEffectiveness = value;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Sélectionnez le niveau d\'efficacité',
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),

                    // Your customized ElevatedButton
                    ElevatedButton(
                      onPressed: () {
                        if (!_validateForm()) return;

                        final medicationData = {
                          'using_medication': _isUsingMedication,
                          'medication_details':
                              _isUsingMedication == true
                                  ? _medicationController.text
                                  : null,
                          'has_allergies': _hasAllergies,
                          'allergies_details':
                              _hasAllergies == true
                                  ? _allergiesController.text
                                  : null,
                          'received_treatment': _receivedTreatmentBefore,
                          'previous_treatment':
                              _receivedTreatmentBefore == true
                                  ? _previousTreatmentController.text
                                  : null,
                          'treatment_effectiveness': _treatmentEffectiveness,
                        };

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => DoctorEmergencyInterface(
                                  healthData: {
                                    ...widget.healthData,
                                    ...medicationData,
                                  },
                                  doctorsData: const [
                                    {
                                      'name': 'Dr. Default Name',
                                      'specialty': 'General Practitioner',
                                      'phone': '',
                                    },
                                  ],
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
                        'INTERFACE URGENCE MÉDICALE',
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
            ],
          ),
        ),
      ),
    );
  }
}
