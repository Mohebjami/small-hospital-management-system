import 'package:get/get.dart';
import '../core/database/database_helper.dart';
import '../models/doctor_model.dart';

class DoctorController extends GetxController {
  final db = DatabaseHelper.instance;
  RxList<Doctor> doctors = <Doctor>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    final database = await db.database;
    final data = await database.query('doctors');
    doctors.value = data.map((e) => Doctor.fromMap(e)).toList();
  }

  Future<void> addDoctor(String name, String specialty) async {
    final database = await db.database;
    await database.insert('doctors', {
      'name': name,
      'specialty': specialty,
    });
    await fetchDoctors();
  }

  Future<void> updateDoctor(int id, String name, String specialty) async {
    final database = await db.database;
    await database.update(
      'doctors',
      {'name': name, 'specialty': specialty},
      where: 'id = ?',
      whereArgs: [id],
    );
    await fetchDoctors();
  }

  Future<void> deleteDoctor(int id) async {
    final database = await db.database;
    await database.delete(
      'doctors',
      where: 'id = ?',
      whereArgs: [id],
    );
    await fetchDoctors();
  }
}