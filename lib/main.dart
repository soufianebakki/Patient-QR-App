import 'package:flutter/material.dart';
import 'screens/conferm_patient_page.dart';
import 'services/api_service.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Guardian',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        colorScheme: ColorScheme.light(
          primary: Colors.teal.shade700,
          secondary: Colors.amber.shade600,
          surface: Colors.white,
          background: Colors.grey.shade50,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.teal.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.teal.shade700, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal.shade700,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
      home: const HealthInfoForm(),
    );
  }
}

class HealthInfoForm extends StatefulWidget {
  const HealthInfoForm({super.key});

  @override
  State<HealthInfoForm> createState() => _HealthInfoFormState();
}

class _HealthInfoFormState extends State<HealthInfoForm> {
  final _formKey = GlobalKey<FormState>();
  bool showOnLockScreen = false;
  String? selectedGender;
  String? selectedBloodType;
  String? selectedMaritalStatus;
  String? selectedChildrenStatus;
  DateTime? _dateOfBirth;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emergencyNameController =
      TextEditingController();
  final TextEditingController _emergencyPhoneController =
      TextEditingController();
  final TextEditingController _originController = TextEditingController();

  final List<String> genderOptions = ['Homme', 'Femme', 'Préfère ne pas dire'];

  final List<String> bloodTypeOptions = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
    'Inconnu',
  ];

  final List<String> maritalStatusOptions = [
    'Marié(e)',
    'Célibataire',
    'Divorcé(e)',
    'Veuf/Veuve',
    'Préfère ne pas dire',
  ];

  final List<String> childrenStatusOptions = [
    'Oui',
    'Non',
    'Préfère ne pas dire',
  ];

  @override
  void initState() {
    super.initState();
    _emergencyPhoneController.text = '+212';
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _originController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  // Add to your _HealthInfoFormState class
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final response = await ApiService.createPatient({
          'full_name': _fullNameController.text,
          'date_of_birth': _dateOfBirth?.toIso8601String(),
          'gender': selectedGender,
          'blood_type': selectedBloodType,
          'emergency_contact': {
            'name': _emergencyNameController.text,
            'phone': _emergencyPhoneController.text,
          },
          'marital_status': selectedMaritalStatus,
          'has_children': selectedChildrenStatus,
          'origin': _originController.text,
        });

        Navigator.of(context).pop(); // Close loading dialog

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmationPage(healthData: response),
          ),
        );
      } catch (e) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "Health Guardian",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade700, Colors.teal.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 150,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/patt.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),
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
                      "Votre Profil Médical",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Veuillez renseigner vos informations pour les situations d'urgence",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextFormField(
                    "Nom Complet",
                    Icons.person,
                    _fullNameController,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Date de Naissance",
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          controller: TextEditingController(
                            text:
                                _dateOfBirth != null
                                    ? "${_dateOfBirth!.day.toString().padLeft(2, '0')}/${_dateOfBirth!.month.toString().padLeft(2, '0')}/${_dateOfBirth!.year}"
                                    : '',
                          ),
                          onTap: () => _selectDate(context),
                          readOnly: true,
                          validator:
                              (_) =>
                                  _dateOfBirth == null
                                      ? 'Veuillez sélectionner une date'
                                      : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdownFormField(
                          "Genre",
                          Icons.transgender,
                          selectedGender,
                          genderOptions,
                          (value) {
                            setState(() {
                              selectedGender = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildDropdownFormField(
                    "Groupe Sanguin",
                    Icons.opacity,
                    selectedBloodType,
                    bloodTypeOptions,
                    (value) {
                      setState(() {
                        selectedBloodType = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTextFormField(
                    "Nom du Contact d'Urgence",
                    Icons.contact_emergency,
                    _emergencyNameController,
                  ),
                  const SizedBox(height: 12),
                  _buildTextFormField(
                    "Téléphone d'Urgence",
                    Icons.phone,
                    _emergencyPhoneController,
                    isPhone: true,
                  ),
                  const SizedBox(height: 12),
                  _buildDropdownFormField(
                    "Êtes-vous marié(e)?",
                    Icons.family_restroom,
                    selectedMaritalStatus,
                    maritalStatusOptions,
                    (value) {
                      setState(() {
                        selectedMaritalStatus = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildDropdownFormField(
                    "Avez-vous des enfants?",
                    Icons.child_care,
                    selectedChildrenStatus,
                    childrenStatusOptions,
                    (value) {
                      setState(() {
                        selectedChildrenStatus = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTextFormField(
                    "D'où venez-vous?",
                    Icons.location_city,
                    _originController,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text(
                      "SUIVANT",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField(
    String label,
    IconData icon,
    TextEditingController controller, {
    bool isPhone = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.teal.shade700),
      ),
      maxLines: maxLines,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Ce champ est requis';
        }
        if (isPhone && value.length < 10) {
          return 'Numéro de téléphone invalide';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownFormField(
    String label,
    IconData icon,
    String? value,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.teal.shade700),
      ),
      items:
          options
              .map(
                (option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ),
              )
              .toList(),
      onChanged: onChanged,
      validator:
          (value) => value == null ? 'Veuillez sélectionner une option' : null,
    );
  }
}
