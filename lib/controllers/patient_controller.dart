import 'package:get/get.dart';
import '../core/database/database_helper.dart';
import '../models/patient_model.dart';
import 'dart:math';

class PatientController extends GetxController {
  final db = DatabaseHelper.instance;
  RxList<Patient> patients = <Patient>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    final database = await db.database;
    final data = await database.query('patients');
    patients.value = data.map((e) => Patient.fromMap(e)).toList();
  }

  String generatePatientId() {
    final rnd = Random();
    return "P-${rnd.nextInt(99999).toString().padLeft(5, '0')}";
  }

  Future<void> addPatient(
    String name,
    int age,
    String gender,
    String disease,
    int doctorId,
  ) async {
    final database = await db.database;
    await database.insert('patients', {
      'patient_id': generatePatientId(),
      'name': name,
      'age': age,
      'gender': gender,
      'disease': disease,
      'doctor_id': doctorId,
      'created_at': DateTime.now().toIso8601String(),
    });
    await fetchPatients();
  }

  Future<void> updatePatient(
    int id,
    String name,
    int age,
    String gender,
    String disease,
    int doctorId,
  ) async {
    final database = await db.database;
    await database.update(
      'patients',
      {
        'name': name,
        'age': age,
        'gender': gender,
        'disease': disease,
        'doctor_id': doctorId,
      },
      where: 'id=?',
      whereArgs: [id],
    );
    await fetchPatients();
  }

  Future<void> deletePatient(int id) async {
    final database = await db.database;
    await database.delete('patients', where: 'id=?', whereArgs: [id]);
    await fetchPatients();
  }
}
