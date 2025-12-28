import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/appointment_controller.dart';
import '../../controllers/patient_controller.dart';
import '../../controllers/doctor_controller.dart';

class AppointmentsPage extends StatelessWidget {
  AppointmentsPage({super.key});

  final appointmentCtrl = Get.put(AppointmentController());
  final patientCtrl = Get.find<PatientController>();
  final doctorCtrl = Get.find<DoctorController>();

  RxInt selectedPatientId = 0.obs;
  RxInt selectedDoctorId = 0.obs;
  final dateCtrl = TextEditingController();
  final timeCtrl = TextEditingController();

  void _showAppointmentDialog({
    int? id,
    int? patientId,
    int? doctorId,
    String? date,
    String? time,
  }) {
    selectedPatientId.value = patientId ?? 0;
    selectedDoctorId.value = doctorId ?? 0;
    dateCtrl.text = date ?? '';
    timeCtrl.text = time ?? '';

    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SizedBox(
          width: 400,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    id == null ? "Add Appointment" : "Edit Appointment",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Patient Dropdown
                  Obx(
                    () => DropdownButtonFormField<int>(
                      dropdownColor: Colors.white,
                      initialValue: selectedPatientId.value == 0
                          ? null
                          : selectedPatientId.value,
                      hint: const Text('Select Patient'),
                      items: patientCtrl.patients
                          .map(
                            (p) => DropdownMenuItem(
                              value: p.id,
                              child: Text(p.name),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => selectedPatientId.value = v!,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Doctor Dropdown
                  Obx(
                    () => DropdownButtonFormField<int>(
                      dropdownColor: Colors.white,
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
                  const SizedBox(height: 12),

                  // Date Picker
                  TextField(
                    controller: dateCtrl,
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: Get.context!,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        dateCtrl.text =
                            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Date",
                      prefixIcon: const Icon(Icons.date_range),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Time Picker
                  TextField(
                    controller: timeCtrl,
                    readOnly: true,
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: Get.context!,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        timeCtrl.text =
                            "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Time",
                      prefixIcon: const Icon(Icons.access_time),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
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
                            if (selectedPatientId.value == 0 ||
                                selectedDoctorId.value == 0 ||
                                dateCtrl.text.isEmpty ||
                                timeCtrl.text.isEmpty) {
                              Get.snackbar(
                                "Validation Error",
                                "Please fill all fields",
                                backgroundColor: Colors.red.shade400,
                                colorText: Colors.white,
                              );
                              return;
                            }

                            if (id == null) {
                              appointmentCtrl.addAppointment(
                                selectedPatientId.value,
                                selectedDoctorId.value,
                                dateCtrl.text,
                                timeCtrl.text,
                              );
                            } else {
                              appointmentCtrl.updateAppointment(
                                id,
                                selectedPatientId.value,
                                selectedDoctorId.value,
                                dateCtrl.text,
                                timeCtrl.text,
                              );
                            }

                            dateCtrl.clear();
                            timeCtrl.clear();
                            selectedPatientId.value = 0;
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
                            id == null
                                ? "Add Appointment"
                                : "Update Appointment",
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
        title: const Text("Appointments"),
      ),
      body: Obx(() {
        if (appointmentCtrl.appointments.isEmpty) {
          return const Center(child: Text("No appointments scheduled."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: appointmentCtrl.appointments.length,
          itemBuilder: (_, i) {
            final a = appointmentCtrl.appointments[i];
            final patient = patientCtrl.patients.firstWhereOrNull(
              (p) => p.id == a.patientId,
            );
            final doctor = doctorCtrl.doctors.firstWhereOrNull(
              (d) => d.id == a.doctorId,
            );

            return Card(
              color: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(
                  "Patient: ${patient?.name ?? 'Unknown'} | Doctor: ${doctor?.name ?? 'Unknown'}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("${a.date} ${a.time} | Status: ${a.status}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      tooltip: "Confirm",
                      onPressed: () =>
                          appointmentCtrl.updateStatus(a.id!, 'Confirmed'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      tooltip: "Cancel",
                      onPressed: () =>
                          appointmentCtrl.updateStatus(a.id!, 'Cancelled'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      tooltip: "Edit",
                      onPressed: () => _showAppointmentDialog(
                        id: a.id,
                        patientId: a.patientId,
                        doctorId: a.doctorId,
                        date: a.date,
                        time: a.time,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                      tooltip: "Delete",
                      onPressed: () {
                        Get.defaultDialog(
                          title: "Delete Appointment",
                          middleText:
                              "Are you sure you want to delete this appointment?",
                          textConfirm: "Delete",
                          confirmTextColor: Colors.white,
                          textCancel: "Cancel",
                          onConfirm: () {
                            appointmentCtrl.deleteAppointment(a.id!);
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
            icon: const Icon(Icons.add, size: 30, color: Colors.white),
            onPressed: () => _showAppointmentDialog(),
          ),
        ),
      ),
    );
  }
}
