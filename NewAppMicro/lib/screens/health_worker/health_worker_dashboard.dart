import 'package:flutter/material.dart';
import 'package:new_app_micro/models/user_model.dart';
import 'package:new_app_micro/services/auth_service.dart';
import 'package:new_app_micro/screens/health_worker/patient_registration_screen.dart';

class HealthWorkerDashboard extends StatelessWidget {
  final AppUserData userData;
  const HealthWorkerDashboard({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Worker Dashboard'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.person, color: Colors.white),
            label: const Text('Logout', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              await AuthService().signOut();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${userData.email}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your Registered Patients:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const Expanded(
              child: Center(
                // TODO: Implement a list view of patients registered by this user
                child: Text('Patient list will appear here.'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PatientRegistrationScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Register Patient'),
      ),
    );
  }
}
