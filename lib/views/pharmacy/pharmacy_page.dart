import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hospital/controllers/pharmacy_controller.dart';
import 'package:hospital/controllers/prescription_controller.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class PharmacyPage extends StatelessWidget {
  PharmacyPage({super.key});

  final pharmacyCtrl = Get.put(PharmacyController());
  final prescriptionCtrl = Get.find<PrescriptionController>();

  final nameCtrl = TextEditingController();
  final quantityCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  RxInt selectedPrescriptionId = 0.obs;

void _generateAndOpenPDF(medicine, prescription) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Medicine Details', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 16),
          pw.Text('Medicine Name: ${medicine.name}'),
          pw.Text('Quantity: ${medicine.quantity}'),
          pw.Text('Price: ${medicine.price}'),
          pw.Text('Prescription Patient ID: ${prescription?.patientId ?? 'N/A'}'),
        ],
      ),
    ),
  );

  // Save to temporary directory
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/medicine_${medicine.id}.pdf');
  await file.writeAsBytes(await pdf.save());

  // Open PDF in Preview or default PDF viewer
  await OpenFile.open(file.path);
}
  void _showMedicineDialog({
    int? id,
    int? prescriptionId,
    String? name,
    int? quantity,
    double? price,
  }) {
    selectedPrescriptionId.value = prescriptionId ?? 0;
    nameCtrl.text = name ?? '';
    quantityCtrl.text = quantity?.toString() ?? '';
    priceCtrl.text = price?.toString() ?? '';

    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SizedBox(
          width: 450,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Medicine Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Prescription Dropdown
                Obx(
                  () => DropdownButtonFormField<int>(
                    dropdownColor: Colors.white,
                    initialValue: selectedPrescriptionId.value == 0
                        ? null
                        : selectedPrescriptionId.value,
                    hint: const Text('Select Prescription'),
                    items: prescriptionCtrl.prescriptions
                        .map(
                          (p) => DropdownMenuItem(
                            value: p.id,
                            child: Text('Patient ID: ${p.patientId}'),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => selectedPrescriptionId.value = v!,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Medicine Name
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: "Medicine Name",
                    prefixIcon: const Icon(Icons.medical_services),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Quantity
                TextField(
                  controller: quantityCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Quantity",
                    prefixIcon: const Icon(Icons.format_list_numbered),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Price
                TextField(
                  controller: priceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Price",
                    prefixIcon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
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
                          if (selectedPrescriptionId.value == 0 ||
                              nameCtrl.text.isEmpty ||
                              quantityCtrl.text.isEmpty ||
                              priceCtrl.text.isEmpty) {
                            Get.snackbar(
                              "Validation Error",
                              "Please fill all fields",
                              backgroundColor: Colors.red.shade400,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          if (id == null) {
                            pharmacyCtrl.addMedicine(
                              selectedPrescriptionId.value,
                              nameCtrl.text,
                              int.parse(quantityCtrl.text),
                              double.parse(priceCtrl.text),
                            );
                          } else {
                            pharmacyCtrl.updateMedicine(
                              id,
                              selectedPrescriptionId.value,
                              nameCtrl.text,
                              int.parse(quantityCtrl.text),
                              double.parse(priceCtrl.text),
                            );
                          }

                          nameCtrl.clear();
                          quantityCtrl.clear();
                          priceCtrl.clear();
                          selectedPrescriptionId.value = 0;
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
                          id == null ? "Add Medicine" : "Update Medicine",
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
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Pharmacy"),
      ),
      body: Obx(() {
        if (pharmacyCtrl.medicines.isEmpty) {
          return const Center(child: Text("No medicines added yet."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: pharmacyCtrl.medicines.length,
          itemBuilder: (_, i) {
            final m = pharmacyCtrl.medicines[i];
            final prescription = prescriptionCtrl.prescriptions
                .firstWhereOrNull((p) => p.id == m.prescriptionId);

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
                    m.name[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  m.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Qty: ${m.quantity} | Price: ${m.price}\nPatient ID: ${prescription?.patientId ?? 'N/A'}",
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showMedicineDialog(
                        id: m.id,
                        prescriptionId: m.prescriptionId,
                        name: m.name,
                        quantity: m.quantity,
                        price: m.price,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                        size: 26,
                      ),
                      onPressed: () {
                        Get.dialog(
                          Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                              ),
                              width: 200,
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.warning_amber_rounded,
                                      color: Colors.red,
                                      size: 48,
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      "Delete Medicine",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      "Are you sure you want to delete this medicine? This action cannot be undone.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () => Get.back(),
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                color: Colors.grey,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 14,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: const Text("Cancel"),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              pharmacyCtrl.deleteMedicine(
                                                m.id!,
                                              );
                                              Get.back();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 14,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: const Text(
                                              "Delete",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
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
                        );
                      },
                    ),
                   IconButton(
                      icon: const Icon(Icons.print, color: Colors.green),
                      onPressed: () {
                        _generateAndOpenPDF(m, prescription);
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
            onPressed: () => _showMedicineDialog(),
          ),
        ),
      ),
    );
  }
}
