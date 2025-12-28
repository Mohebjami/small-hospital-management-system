import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/patient_controller.dart';
import '../../controllers/doctor_controller.dart';

class PatientsPage extends StatelessWidget {
  PatientsPage({super.key});

  final patientCtrl = Get.put(PatientController());
  final doctorCtrl = Get.find<DoctorController>();

  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final genderCtrl = TextEditingController();
  final diseaseCtrl = TextEditingController();
  RxInt selectedDoctorId = 0.obs;

  void _showPatientDialog({
    int? id,
    String? name,
    int? age,
    String? gender,
    String? disease,
    int? doctorId,
  }) {
    nameCtrl.text = name ?? '';
    ageCtrl.text = age?.toString() ?? '';
    genderCtrl.text = gender ?? '';
    diseaseCtrl.text = disease ?? '';
    selectedDoctorId.value = doctorId ?? 0;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SizedBox(
          width: 450, // Adjust width as needed (responsive)
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header Icon
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.teal.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_hospital,
                      color: Colors.teal,
                      size: 36,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Title
                  Text(
                    id == null ? "Add New Patient" : "Edit Patient",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Name
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      labelText: "Name",
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Age
                  TextField(
                    controller: ageCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Age",
                      prefixIcon: const Icon(Icons.cake),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Gender
                  TextField(
                    controller: genderCtrl,
                    decoration: InputDecoration(
                      labelText: "Gender",
                      prefixIcon: const Icon(Icons.wc),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Disease
                  TextField(
                    controller: diseaseCtrl,
                    decoration: InputDecoration(
                      labelText: "Disease",
                      prefixIcon: const Icon(Icons.local_hospital),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Doctor Dropdown
                  Obx(
                    () => DropdownButtonFormField<int>(
                      initialValue: selectedDoctorId.value == 0
                          ? null
                          : selectedDoctorId.value,
                      hint: const Text('Select Doctor'),
                      items: doctorCtrl.doctors
                          .map(
                            (d) => DropdownMenuItem(
                              value: d.id,
                              child: Text(d.name),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => selectedDoctorId.value = v!,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (nameCtrl.text.isEmpty ||
                                ageCtrl.text.isEmpty ||
                                genderCtrl.text.isEmpty ||
                                diseaseCtrl.text.isEmpty ||
                                selectedDoctorId.value == 0) {
                              Get.snackbar(
                                "Validation Error",
                                "Please fill all fields",
                                backgroundColor: Colors.red.shade400,
                                colorText: Colors.white,
                              );
                              return;
                            }

                            if (id == null) {
                              patientCtrl.addPatient(
                                nameCtrl.text,
                                int.parse(ageCtrl.text),
                                genderCtrl.text,
                                diseaseCtrl.text,
                                selectedDoctorId.value,
                              );
                            } else {
                              patientCtrl.updatePatient(
                                id,
                                nameCtrl.text,
                                int.parse(ageCtrl.text),
                                genderCtrl.text,
                                diseaseCtrl.text,
                                selectedDoctorId.value,
                              );
                            }

                            nameCtrl.clear();
                            ageCtrl.clear();
                            genderCtrl.clear();
                            diseaseCtrl.clear();
                            selectedDoctorId.value = 0;
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            id == null ? "Add Patient" : "Update Patient",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
        title: const Text("Patients"),
      ),
      body: Obx(() {
        if (patientCtrl.patients.isEmpty) {
          return const Center(child: Text("No patients added yet."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: patientCtrl.patients.length,
          itemBuilder: (_, i) {
            final p = patientCtrl.patients[i];
            final doctor = doctorCtrl.doctors.firstWhereOrNull(
              (d) => d.id == p.doctorId,
            );

            return Card(
              color: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Text(
                    p.name[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  p.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Age: ${p.age} | Gender: ${p.gender}\nDisease: ${p.disease}\nDoctor: ${doctor?.name ?? 'N/A'}",
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showPatientDialog(
                        id: p.id,
                        name: p.name,
                        age: p.age,
                        gender: p.gender,
                        disease: p.disease,
                        doctorId: p.doctorId,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        Get.defaultDialog(
                          title: "Delete Patient",
                          middleText:
                              "Are you sure you want to delete this patient?",
                          textConfirm: "Delete",
                          confirmTextColor: Colors.white,
                          textCancel: "Cancel",
                          onConfirm: () {
                            patientCtrl.deletePatient(p.id!);
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
                onPressed: () => _showPatientDialog(),
              ),
        ),
      ),
    );
  }
}
