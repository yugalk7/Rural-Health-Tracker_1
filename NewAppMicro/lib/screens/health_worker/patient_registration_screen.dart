import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:new_app_micro/models/patient_model.dart';
import 'package:new_app_micro/models/user_model.dart';
import 'package:new_app_micro/services/database_service.dart';

class PatientRegistrationScreen extends StatefulWidget {
  const PatientRegistrationScreen({super.key});

  @override
  _PatientRegistrationScreenState createState() =>
      _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _contactController = TextEditingController();
  final _villageController = TextEditingController();
  final _blockController = TextEditingController();
  final _districtController = TextEditingController();
  final _symptomsController = TextEditingController();

  String _selectedGender = 'Male';
  final List<String> _genders = ['Male', 'Female', 'Other'];

  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _ageController.dispose();
    _contactController.dispose();
    _villageController.dispose();
    _blockController.dispose();
    _districtController.dispose();
    _symptomsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Register Patient')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _fullNameController,
                      decoration: const InputDecoration(labelText: 'Full Name'),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter full name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(labelText: 'Age'),
                      keyboardType: TextInputType.number,
                      validator: (val) => val!.isEmpty ? 'Enter age' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField(
                      initialValue: _selectedGender,
                      items: _genders.map((gender) {
                        return DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => _selectedGender = val.toString()),
                      decoration: const InputDecoration(labelText: 'Gender'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _contactController,
                      decoration: const InputDecoration(
                        labelText: 'Contact Info',
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (val) =>
                          val!.isEmpty ? 'Enter contact info' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _villageController,
                      decoration: const InputDecoration(labelText: 'Village'),
                      validator: (val) => val!.isEmpty ? 'Enter village' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _blockController,
                      decoration: const InputDecoration(labelText: 'Block'),
                      validator: (val) => val!.isEmpty ? 'Enter block' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _districtController,
                      decoration: const InputDecoration(labelText: 'District'),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter district' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _symptomsController,
                      decoration: const InputDecoration(
                        labelText: 'Initial Symptoms',
                      ),
                      maxLines: 3,
                      validator: (val) =>
                          val!.isEmpty ? 'Enter symptoms' : null,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate() && user != null) {
                          setState(() => _isLoading = true);

                          var uuid = const Uuid();

                          Patient newPatient = Patient(
                            id: uuid.v4(),
                            fullName: _fullNameController.text,
                            age: int.parse(_ageController.text),
                            gender: _selectedGender,
                            contactInfo: _contactController.text,
                            village: _villageController.text,
                            block: _blockController.text,
                            district: _districtController.text,
                            initialSymptoms: _symptomsController.text,
                            diagnosis: 'Pending',
                            registrationDate: Timestamp.now(),
                            registeredBy: user.uid,
                          );

                          await DatabaseService().addOrUpdatePatient(
                            newPatient,
                          );

                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Patient Registered Successfully'),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
