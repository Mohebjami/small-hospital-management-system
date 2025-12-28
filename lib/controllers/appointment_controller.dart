import 'package:get/get.dart';
import '../core/database/database_helper.dart';
import '../models/appointment_model.dart';

class AppointmentController extends GetxController {
  final db = DatabaseHelper.instance;
  RxList<Appointment> appointments = <Appointment>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    final database = await db.database;
    final data = await database.query('appointments');
    appointments.value = data.map((e) => Appointment.fromMap(e)).toList();
  }

  Future<void> addAppointment(int patientId, int doctorId, String date, String time) async {
    final database = await db.database;
    await database.insert('appointments', {
      'patient_id': patientId,
      'doctor_id': doctorId,
      'date': date,
      'time': time,
      'status': 'Pending'
    });
    await fetchAppointments();
  }
  Future<void> updateAppointment(int id, int patientId, int doctorId, String date, String time) async {
  final database = await db.database;
  await database.update(
    'appointments',
    {
      'patient_id': patientId,
      'doctor_id': doctorId,
      'date': date,
      'time': time,
      'status': 'Pending',
    },
    where: 'id=?',
    whereArgs: [id],
  );
  await fetchAppointments();
}

Future<void> deleteAppointment(int id) async {
  final database = await db.database;
  await database.delete('appointments', where: 'id=?', whereArgs: [id]);
  await fetchAppointments();
}

  Future<void> updateStatus(int id, String status) async {
    final database = await db.database;
    await database.update('appointments', {'status': status}, where: 'id=?', whereArgs: [id]);
    await fetchAppointments();
  }
}
