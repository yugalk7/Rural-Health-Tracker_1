import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_app_micro/models/patient_model.dart';
import 'package:new_app_micro/models/user_model.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // Collection reference for users
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  // Collection reference for patients
  final CollectionReference patientCollection =
      FirebaseFirestore.instance.collection('patients');

  // Update user data (role, email) when they register
  Future<void> updateUserData(String role, String email) async {
    return await userCollection.doc(uid).set({
      'role': role,
      'email': email,
    });
  }

  // Get user data from a snapshot
  AppUserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
    return AppUserData(
      uid: uid!,
      email: data['email'] ?? '',
      role: data['role'] ?? '',
    );
  }

  // Get user doc stream
  Stream<AppUserData?> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // Add or update a patient record
  Future<void> addOrUpdatePatient(Patient patient) async {
    return await patientCollection.doc(patient.id).set(patient.toMap());
  }

  // Get patient list from a snapshot
  List<Patient> _patientListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Patient.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  // Get patients stream for the doctor/admin dashboard
  Stream<List<Patient>> get patients {
    return patientCollection.snapshots().map(_patientListFromSnapshot);
  }
}
