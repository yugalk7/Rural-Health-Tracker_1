import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:new_app_micro/models/user_model.dart';
import 'package:new_app_micro/services/database_service.dart';
import 'package:new_app_micro/screens/doctor_admin/doctor_admin_dashboard.dart';
import 'package:new_app_micro/screens/health_worker/health_worker_dashboard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);

    if (user == null) {
      // This is a safeguard, should not be reached if Wrapper is working correctly.
      return const Scaffold(
        body: Center(child: Text("Error: User not logged in.")),
      );
    }

    // This StreamProvider listens for the specific user's data (like their role) from Firestore.
    return StreamProvider<AppUserData?>.value(
      value: DatabaseService(uid: user.uid).userData,
      initialData: null,
      child: const RoleBasedRedirect(),
    );
  }
}

class RoleBasedRedirect extends StatelessWidget {
  const RoleBasedRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<AppUserData?>(context);

    // If we are still waiting for the user's data from the database, show a loading circle.
    if (userData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Once we have the user's data, redirect them to the correct dashboard based on their role.
    switch (userData.role) {
      case 'Health Worker':
        return HealthWorkerDashboard(userData: userData);
      case 'Doctor':
      case 'Admin':
        return DoctorAdminDashboard(userData: userData);
      default:
        // This is a fallback for any unexpected role.
        return const Scaffold(
          body: Center(child: Text('Unknown role. Please contact support.')),
        );
    }
  }
}
