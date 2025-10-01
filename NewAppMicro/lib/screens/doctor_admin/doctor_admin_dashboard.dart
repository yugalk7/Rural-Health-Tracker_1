import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:new_app_micro/models/patient_model.dart';
import 'package:new_app_micro/models/user_model.dart';
import 'package:new_app_micro/services/auth_service.dart';
import 'package:new_app_micro/services/database_service.dart';
import 'package:new_app_micro/screens/doctor_admin/patient_details_screen.dart';

class DoctorAdminDashboard extends StatelessWidget {
  final AppUserData userData;
  const DoctorAdminDashboard({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    // This provides a stream of all patients from the database
    return StreamProvider<List<Patient>>.value(
      value: DatabaseService().patients,
      initialData: const [],
      child: Scaffold(
        appBar: AppBar(
          title: Text('${userData.role} Dashboard'),
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.person, color: Colors.white),
              label: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await AuthService().signOut();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Welcome, ${userData.email}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search by Name or Village',
                  prefixIcon: Icon(Icons.search),
                ),
                // TODO: Implement search functionality
              ),
            ),
            // The PatientList widget will display the patients from the stream
            const Expanded(child: PatientList()),
          ],
        ),
      ),
    );
  }
}

class PatientList extends StatelessWidget {
  const PatientList({super.key});

  @override
  Widget build(BuildContext context) {
    final patients = Provider.of<List<Patient>>(context);

    if (patients.isEmpty) {
      return const Center(child: Text('No patients registered yet.'));
    }

    // Display patients in a scrollable list
    return ListView.builder(
      itemCount: patients.length,
      itemBuilder: (context, index) {
        final patient = patients[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            title: Text(patient.fullName),
            subtitle: Text('Village: ${patient.village} | Age: ${patient.age}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to the details screen when a patient is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PatientDetailsScreen(patient: patient),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
