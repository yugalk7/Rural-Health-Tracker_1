import 'package:cloud_firestore/cloud_firestore.dart';

class Patient {
  final String? id; // Document ID
  final String fullName;
  final int age;
  final String gender;
  final String contactInfo;
  final String village;
  final String block;
  final String district;
  final String initialSymptoms;
  final String diagnosis;
  final Timestamp registrationDate;
  final String registeredBy; // UID of health worker

  Patient({
    this.id,
    required this.fullName,
    required this.age,
    required this.gender,
    required this.contactInfo,
    required this.village,
    required this.block,
    required this.district,
    required this.initialSymptoms,
    required this.diagnosis,
    required this.registrationDate,
    required this.registeredBy,
  });

  // Converts the Patient object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'age': age,
      'gender': gender,
      'contactInfo': contactInfo,
      'village': village,
      'block': block,
      'district': district,
      'initialSymptoms': initialSymptoms,
      'diagnosis': diagnosis,
      'registrationDate': registrationDate,
      'registeredBy': registeredBy,
    };
  }

  // Creates a Patient object from a Firestore Map
  factory Patient.fromMap(Map<String, dynamic> map, String documentId) {
    return Patient(
      id: documentId,
      fullName: map['fullName'] ?? '',
      age: map['age'] ?? 0,
      gender: map['gender'] ?? '',
      contactInfo: map['contactInfo'] ?? '',
      village: map['village'] ?? '',
      block: map['block'] ?? '',
      district: map['district'] ?? '',
      initialSymptoms: map['initialSymptoms'] ?? '',
      diagnosis: map['diagnosis'] ?? '',
      registrationDate: map['registrationDate'] ?? Timestamp.now(),
      registeredBy: map['registeredBy'] ?? '',
    );
  }
}
