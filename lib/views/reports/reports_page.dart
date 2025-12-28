import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital/controllers/report_controller.dart';
import 'package:hospital/controllers/patient_controller.dart';
import 'package:hospital/controllers/doctor_controller.dart';
import 'package:hospital/controllers/appointment_controller.dart';
import 'package:hospital/controllers/prescription_controller.dart';
import 'package:hospital/controllers/pharmacy_controller.dart';

class ReportsPage extends StatelessWidget {
  ReportsPage({super.key});

  final reportCtrl = Get.put(ReportController());
  final patientCtrl = Get.put(PatientController());
  final doctorCtrl = Get.put(DoctorController());
  final appointmentCtrl = Get.put(AppointmentController());
  final prescriptionCtrl = Get.put(PrescriptionController());
  final pharmacyCtrl = Get.put(PharmacyController());

  @override
  Widget build(BuildContext context) {
    // Generate reports after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      reportCtrl.generateReports(
        patients: patientCtrl.patients,
        doctors: doctorCtrl.doctors,
        appointments: appointmentCtrl.appointments,
        prescriptions: prescriptionCtrl.prescriptions,
        medicines: pharmacyCtrl.medicines,
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Hospital Reports',
          style: TextStyle(color: Colors.teal),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            Obx(() => Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildSummaryCard(
                        'Total Patients', reportCtrl.totalPatients.value, Icons.people),
                    _buildSummaryCard(
                        'Total Doctors', reportCtrl.totalDoctors.value, Icons.person),
                    _buildSummaryCard('Appointments', reportCtrl.totalAppointments.value,
                        Icons.event_available),
                    _buildSummaryCard('Prescriptions', reportCtrl.totalPrescriptions.value,
                        Icons.description),
                    _buildSummaryCard('Medicines', reportCtrl.totalMedicines.value,
                        Icons.medical_services),
                  ],
                )),

            const SizedBox(height: 24),

            // Diseases Overview
            const Text(
              "Diseases Overview",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200, 
              child: Obx(() {
                if (reportCtrl.diseaseCount.isEmpty) {
                  return patientCtrl.patients.isEmpty
                      ? const Center(child: Text("No report data available."))
                      : const SizedBox.shrink();
                }

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: reportCtrl.diseaseCount.entries.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (_, index) {
                    final entry = reportCtrl.diseaseCount.entries.elementAt(index);
                    return _buildDiseaseCard(entry.key, entry.value);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Summary Cards
  Widget _buildSummaryCard(String title, int count, IconData icon) {
    return SizedBox(
      width: 160,
      height: 170,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 28, color: Colors.teal),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const Spacer(),
              Text('$count',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal)),
            ],
          ),
        ),
      ),
    );
  }

  // Disease Cards
  Widget _buildDiseaseCard(String disease, int count) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sick, color: Colors.redAccent, size: 28),
            const SizedBox(height: 10),
            Text(
              disease,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              '$count patients',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}