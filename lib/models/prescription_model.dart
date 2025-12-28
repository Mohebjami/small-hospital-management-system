class Prescription {
  final int? id;
  final int patientId;
  final int doctorId;
  final String diagnosis;
  final String createdAt;

  Prescription({
    this.id,
    required this.patientId,
    required this.doctorId,
    required this.diagnosis,
    required this.createdAt
  });

  Map<String,dynamic> toMap()=>{
    'id':id,
    'patient_id':patientId,
    'doctor_id':doctorId,
    'diagnosis':diagnosis,
    'created_at':createdAt
  };

  factory Prescription.fromMap(Map<String,dynamic> m)=>Prescription(
    id:m['id'],
    patientId:m['patient_id'],
    doctorId:m['doctor_id'],
    diagnosis:m['diagnosis'],
    createdAt:m['created_at']
  );
}
