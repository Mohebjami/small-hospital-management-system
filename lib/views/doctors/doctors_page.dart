import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/doctor_controller.dart';

class DoctorsPage extends StatelessWidget {
  DoctorsPage({super.key});

  final doctorCtrl = Get.put(DoctorController());
  final nameCtrl = TextEditingController();
  final specCtrl = TextEditingController();

void _showDoctorDialog({int? id, String? name, String? specialty}) {
  nameCtrl.text = name ?? '';
  specCtrl.text = specialty ?? '';

  Get.dialog(
    
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
    
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Header Icon
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.teal.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_hospital,
                  color: Colors.teal,
                  size: 32,
                ),
              ),
        
              const SizedBox(height: 12),
        
              /// Title
              Text(
                id == null ? "Add New Doctor" : "Edit Doctor",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        
              const SizedBox(height: 20),
        
              /// Doctor Name
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: "Doctor Name",
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
        
              const SizedBox(height: 14),
        
              /// Specialty
              TextField(
                controller: specCtrl,
                decoration: InputDecoration(
                  labelText: "Specialty",
                  prefixIcon: const Icon(Icons.medical_services),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
        
              const SizedBox(height: 24),
        
              /// Buttons
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (nameCtrl.text.isEmpty ||
                            specCtrl.text.isEmpty) {
                          Get.snackbar(
                            "Validation Error",
                            "Please fill all fields",
                            backgroundColor: Colors.red.shade400,
                            colorText: Colors.white,
                          );
                          return;
                        }
        
                        if (id == null) {
                          doctorCtrl.addDoctor(
                            nameCtrl.text,
                            specCtrl.text,
                          );
                        } else {
                          doctorCtrl.updateDoctor(
                            id,
                            nameCtrl.text,
                            specCtrl.text,
                          );
                        }
        
                        nameCtrl.clear();
                        specCtrl.clear();
                        Get.back();
                      },
                      child: Text(id == null ? "Add Doctor" : "Update Doctor", style: TextStyle(color: Colors.white),),
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
        title: const Text("Doctors"),
      ),
      body: Obx(() {
        if (doctorCtrl.doctors.isEmpty) {
          return const Center(
            child: Text("No doctors available"),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: doctorCtrl.doctors.length,
          itemBuilder: (context, i) {
            final d = doctorCtrl.doctors[i];

            return Card(
              elevation: 3,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(
                  d.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(d.specialty),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showDoctorDialog(
                        id: d.id,
                        name: d.name,
                        specialty: d.specialty,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        Get.defaultDialog(
                          title: "Delete Doctor",
                          middleText:
                              "Are you sure you want to delete this doctor?",
                          textConfirm: "Delete",
                          confirmTextColor: Colors.white,
                          textCancel: "Cancel",
                          onConfirm: () {
                            doctorCtrl.deleteDoctor(d.id!);
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
                onPressed: () => _showDoctorDialog(),
              ),
        ),
      ),
    );
  }
}