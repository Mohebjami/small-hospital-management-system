import 'package:get/get.dart';
import 'package:hospital/models/patient_model.dart';
import '../core/database/database_helper.dart';


class ReportController extends GetxController {
  final db = DatabaseHelper.instance;

  RxInt totalPatients = 0.obs;
  RxInt totalDoctors = 0.obs;
  RxInt totalAppointments = 0.obs;
  RxInt totalPrescriptions = 0.obs;
  RxInt totalMedicines = 0.obs;
  RxMap<String, int> diseaseCount = <String, int>{}.obs;

  void generateReports({
    required List<Patient> patients,
    required List doctors,
    required List appointments,
    required List prescriptions,
    required List medicines,
  }) {
    totalPatients.value = patients.length;
    totalDoctors.value = doctors.length;
    totalAppointments.value = appointments.length;
    totalPrescriptions.value = prescriptions.length;
    totalMedicines.value = medicines.length;

    // Count diseases properly
    Map<String, int> diseaseMap = {};
    for (var patient in patients) {
      if (patient.disease.isNotEmpty) {
        diseaseMap[patient.disease] = (diseaseMap[patient.disease] ?? 0) + 1;
      }
    }
    diseaseCount.value = diseaseMap;
  }
}