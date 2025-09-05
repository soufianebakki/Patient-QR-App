import 'HealthTracker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DoctorEmergencyInterface extends StatefulWidget {
  final Map<String, dynamic> healthData;
  final List<Map<String, dynamic>>? doctorsData;

  const DoctorEmergencyInterface({
    Key? key,
    required this.healthData,
    this.doctorsData,
  }) : super(key: key);

  @override
  _DoctorEmergencyInterfaceState createState() =>
      _DoctorEmergencyInterfaceState();
}

class _DoctorEmergencyInterfaceState extends State<DoctorEmergencyInterface> {
  List<Map<String, dynamic>> doctors = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.doctorsData != null && widget.doctorsData!.isNotEmpty) {
      doctors = List.from(widget.doctorsData!);
    } else {
      _askDoctorCount();
    }
  }

  void _askDoctorCount() {
    int doctorCount = 1;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => AlertDialog(
              title: const Text("Number of Doctors"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("How many doctors do you have?"),
                  const SizedBox(height: 20),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Doctor count",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      doctorCount = int.tryParse(value) ?? 1;
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _initializeDoctors(doctorCount);
                  },
                  child: const Text("Continue"),
                ),
              ],
            ),
      );
    });
  }

  void _initializeDoctors(int count) {
    setState(() {
      doctors = List.generate(
        count,
        (index) => {
          'doctorName': '',
          'doctorSpecialty': '',
          'doctorPhone': '',
          'clinicLocation': '',
          'doctorImage': null,
        },
      );
    });
  }

  void _addNewDoctor() {
    setState(() {
      doctors.add({
        'doctorName': 'New Doctor',
        'doctorSpecialty': '',
        'doctorPhone': '',
        'clinicLocation': '',
        'doctorImage': null,
      });
    });
  }

  Future<void> _editDoctor(int index) async {
    final doctor = doctors[index];
    final controllers = {
      'name': TextEditingController(text: doctor['doctorName']),
      'specialty': TextEditingController(text: doctor['doctorSpecialty']),
      'phone': TextEditingController(text: doctor['doctorPhone']),
      'location': TextEditingController(text: doctor['clinicLocation']),
    };

    File? imageFile =
        doctor['doctorImage'] != null ? File(doctor['doctorImage']) : null;

    final updatedDoctor = await showDialog<Map<String, dynamic>>(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text("Edit Doctor"),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final pickedFile = await _picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (pickedFile != null) {
                            setState(() => imageFile = File(pickedFile.path));
                          }
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              imageFile != null
                                  ? FileImage(imageFile!)
                                  : (doctor['doctorImage'] != null
                                      ? FileImage(File(doctor['doctorImage']))
                                      // ✅ FIXED: This closing parenthesis was missing and caused the syntax error
                                      : const AssetImage(
                                            'assets/images/doctor.jpg',
                                          )
                                          as ImageProvider),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextField(
                        controller: controllers['name'],
                        decoration: const InputDecoration(labelText: "Name"),
                      ),
                      TextField(
                        controller: controllers['specialty'],
                        decoration: const InputDecoration(
                          labelText: "Specialty",
                        ),
                      ),
                      TextField(
                        controller: controllers['phone'],
                        decoration: const InputDecoration(labelText: "Phone"),
                        keyboardType: TextInputType.phone,
                      ),
                      TextField(
                        controller: controllers['location'],
                        decoration: const InputDecoration(
                          labelText: "Clinic Location",
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red[50],
                    ),
                  ),
                  TextButton(
                    onPressed:
                        () => Navigator.pop(context, {
                          'doctorName': controllers['name']!.text,
                          'doctorSpecialty': controllers['specialty']!.text,
                          'doctorPhone': controllers['phone']!.text,
                          'clinicLocation': controllers['location']!.text,
                          'doctorImage':
                              imageFile?.path ?? doctor['doctorImage'],
                        }),
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 48, 169, 0),
                    ),
                  ),
                ],
              );
            },
          ),
    );

    if (updatedDoctor != null) {
      setState(() => doctors[index] = updatedDoctor);
    }
  }

  Widget _buildDoctorCard(Map<String, dynamic> doctor, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.red[50],
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showDoctorDetails(doctor, index),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage:
                    doctor['doctorImage'] != null
                        ? FileImage(File(doctor['doctorImage']))
                        : const AssetImage('assets/images/doctor.jpg')
                            as ImageProvider,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor['doctorName']?.isNotEmpty ?? false
                          ? doctor['doctorName']
                          : 'Unnamed Doctor',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctor['doctorSpecialty']?.isNotEmpty ?? false
                          ? doctor['doctorSpecialty']
                          : 'No specialty specified',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Color.fromARGB(255, 9, 205, 6),
                ),
                onPressed: () => _editDoctor(index),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDoctorDetails(Map<String, dynamic> doctor, int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              doctor['doctorName']?.isNotEmpty ?? false
                  ? doctor['doctorName']
                  : 'Doctor Details',
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        doctor['doctorImage'] != null
                            ? FileImage(File(doctor['doctorImage']))
                            : const AssetImage('assets/images/doctor.jpg')
                                as ImageProvider,
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow("Name", doctor['doctorName']),
                  _buildDetailRow("Specialty", doctor['doctorSpecialty']),
                  _buildDetailRow("Phone", doctor['doctorPhone']),
                  _buildDetailRow("Location", doctor['clinicLocation']),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close", style: TextStyle(color: Colors.red)),
                style: TextButton.styleFrom(backgroundColor: Colors.red[50]),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _editDoctor(index);
                },
                child: const Text(
                  "Edit",
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 14, 140, 157),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() => doctors.removeAt(index));
                  Navigator.pop(context);
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(backgroundColor: Colors.red[900]),
              ),
            ],
          ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value?.isNotEmpty ?? false ? value! : 'Not specified'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Doctors"),
        backgroundColor: Colors.red[700],
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _addNewDoctor),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child:
                doctors.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("No doctors added yet"),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _askDoctorCount,
                            child: const Text("Add Doctors"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[700],
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      itemCount: doctors.length,
                      itemBuilder:
                          (context, index) =>
                              _buildDoctorCard(doctors[index], index),
                    ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                // TODO: Implement Health Tracker navigation
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HealthTrackerScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Go to Health Tracker',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
