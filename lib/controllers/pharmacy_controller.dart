import 'package:get/get.dart';
import '../core/database/database_helper.dart';
import '../models/medicine_model.dart';

class PharmacyController extends GetxController {
  final db = DatabaseHelper.instance;
  RxList<Medicine> medicines = <Medicine>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMedicines();
  }

  Future<void> fetchMedicines() async {
    final database = await db.database;
    final data = await database.query('medicines');
    medicines.value = data.map((e) => Medicine.fromMap(e)).toList();
  }

  Future<void> addMedicine(
    int prescriptionId,
    String name,
    int quantity,
    double price,
  ) async {
    final database = await db.database;
    await database.insert('medicines', {
      'prescription_id': prescriptionId,
      'name': name,
      'quantity': quantity,
      'price': price,
    });
    await fetchMedicines();
  }

  Future<void> updateMedicine(
    int id,
    int prescriptionId,
    String name,
    int quantity,
    double price,
  ) async {
    final database = await db.database;
    await database.update(
      'medicines',
      {
        'prescription_id': prescriptionId,
        'name': name,
        'quantity': quantity,
        'price': price,
      },
      where: 'id=?',
      whereArgs: [id],
    );
    await fetchMedicines();
  }

  Future<void> deleteMedicine(int id) async {
    final database = await db.database;
    await database.delete('medicines', where: 'id=?', whereArgs: [id]);
    await fetchMedicines();
  }
}
