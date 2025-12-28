import 'package:get/get.dart';
import '../core/database/database_helper.dart';
import '../models/prescription_model.dart';

class PrescriptionController extends GetxController {
  final db = DatabaseHelper.instance;
  RxList<Prescription> prescriptions = <Prescription>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPrescriptions();
  }

  Future<void> fetchPrescriptions() async {
    final database = await db.database;
    final data = await database.query('prescriptions');
    prescriptions.value = data.map((e) => Prescription.fromMap(e)).toList();
  }

  Future<void> addPrescription(int patientId, int doctorId, String diagnosis) async {
    final database = await db.database;
    await database.insert('prescriptions', {
      'patient_id': patientId,
      'doctor_id': doctorId,
      'diagnosis': diagnosis,
      'created_at': DateTime.now().toIso8601String()
    });
    await fetchPrescriptions();
  }

  Future<void> updatePrescription(int id, int patientId, int doctorId, String diagnosis) async {
    final database = await db.database;
    await database.update(
      'prescriptions',
      {
        'patient_id': patientId,
        'doctor_id': doctorId,
        'diagnosis': diagnosis,
      },
      where: 'id=?',
      whereArgs: [id],
    );
    await fetchPrescriptions();
  }

  Future<void> deletePrescription(int id) async {
    final database = await db.database;
    await database.delete('prescriptions', where: 'id=?', whereArgs: [id]);
    await fetchPrescriptions();
  }

}
