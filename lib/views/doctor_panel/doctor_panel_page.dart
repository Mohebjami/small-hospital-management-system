import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/patient_controller.dart';
import '../../controllers/prescription_controller.dart';

class DoctorPanelPage extends StatelessWidget {
  DoctorPanelPage({super.key});

  final patientCtrl = Get.find<PatientController>();
  final prescriptionCtrl = Get.put(PrescriptionController());
  final diagnosisCtrl = TextEditingController();
  RxInt selectedPatientId = 0.obs;

  void _showPrescriptionDialog({int? id, int? patientId, String? diagnosis}) {
    selectedPatientId.value = patientId ?? 0;
    diagnosisCtrl.text = diagnosis ?? '';

    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SizedBox(
          width: 400,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Prescription Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Patient Dropdown
                Obx(() => DropdownButtonFormField<int>(
                  dropdownColor: Colors.white,
                      initialValue: selectedPatientId.value == 0 ? null : selectedPatientId.value,
                      hint: const Text('Select Patient'),
                      items: patientCtrl.patients
                          .map((p) => DropdownMenuItem(value: p.id, child: Text(p.name)))
                          .toList(),
                      onChanged: (v) => selectedPatientId.value = v!,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    )),

                const SizedBox(height: 16),

                // Diagnosis Input
                TextField(
                  controller: diagnosisCtrl,
                  decoration: InputDecoration(
                    labelText: "Diagnosis",
                    prefixIcon: const Icon(Icons.medical_services),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),

                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey[700],
                          side: const BorderSide(color: Colors.grey),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (selectedPatientId.value == 0 || diagnosisCtrl.text.isEmpty) {
                            Get.snackbar(
                              "Validation Error",
                              "Please select patient and enter diagnosis",
                              backgroundColor: Colors.red.shade400,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          if (id == null) {
                            prescriptionCtrl.addPrescription(
                              selectedPatientId.value,
                              1, // Doctor ID (can be dynamic)
                              diagnosisCtrl.text,
                            );
                          } else {
                            prescriptionCtrl.updatePrescription(
                              id,
                              selectedPatientId.value,
                              1,
                              diagnosisCtrl.text,
                            );
                          }

                          diagnosisCtrl.clear();
                          selectedPatientId.value = 0;
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(id == null ? "Add Prescription" : "Update Prescription", style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Doctor Panel"),
      ),
      body: Obx(() {
        if (prescriptionCtrl.prescriptions.isEmpty) {
          return const Center(child: Text("No prescriptions added yet."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: prescriptionCtrl.prescriptions.length,
          itemBuilder: (_, i) {
            final pre = prescriptionCtrl.prescriptions[i];
            final patient = patientCtrl.patients.firstWhereOrNull((p) => p.id == pre.patientId);

            return Card(
              color: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Text(patient?.name[0].toUpperCase() ?? "P",
                      style: const TextStyle(color: Colors.white)),
                ),
                title: Text(patient?.name ?? "Unknown Patient",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Diagnosis: ${pre.diagnosis}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showPrescriptionDialog(
                        id: pre.id,
                        patientId: pre.patientId,
                        diagnosis: pre.diagnosis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        Get.defaultDialog(
                          title: "Delete Prescription",
                          middleText: "Are you sure you want to delete this prescription?",
                          textConfirm: "Delete",
                          confirmTextColor: Colors.white,
                          textCancel: "Cancel",
                          onConfirm: () {
                            prescriptionCtrl.deletePrescription(pre.id!);
                            Get.back();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
   floatingActionButton: Padding(
        padding: EdgeInsetsGeometry.all(20),
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.teal,
          child: IconButton(
                icon: const Icon(Icons.add, size: 30,color: Colors.white,),
                onPressed: () => _showPrescriptionDialog(),
              ),
        ),
      ),
   
    );
  }
}