import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_app_micro/models/patient_model.dart';

class PatientDetailsScreen extends StatelessWidget {
  final Patient patient;

  const PatientDetailsScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(patient.fullName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailCard('Personal Information', [
              _buildDetailRow('Full Name:', patient.fullName),
              _buildDetailRow('Age:', patient.age.toString()),
              _buildDetailRow('Gender:', patient.gender),
              _buildDetailRow('Contact:', patient.contactInfo),
            ]),
            const SizedBox(height: 16),
            _buildDetailCard('Address', [
              _buildDetailRow('Village:', patient.village),
              _buildDetailRow('Block:', patient.block),
              _buildDetailRow('District:', patient.district),
            ]),
            const SizedBox(height: 16),
            _buildDetailCard('Medical Information', [
              _buildDetailRow(
                'Registration Date:',
                DateFormat.yMMMd().format(patient.registrationDate.toDate()),
              ),
              _buildDetailRow('Initial Symptoms:', patient.initialSymptoms,
                  isMultiline: true),
              _buildDetailRow('Diagnosis:', patient.diagnosis,
                  isMultiline: true),
              _buildDetailRow('Registered By (UID):', patient.registeredBy,
                  isMultiline: true),
            ]),
            const SizedBox(height: 24),
            // TODO: Add an 'Edit Diagnosis' button for Doctors/Admins
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20, thickness: 1),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value,
      {bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment:
            isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
