class Patient {
  final int? id;
  final String patientId;
  final String name;
  final int age;
  final String gender;
  final String disease;
  final int doctorId;
  final String createdAt;

  Patient({
    this.id,
    required this.patientId,
    required this.name,
    required this.age,
    required this.gender,
    required this.disease,
    required this.doctorId,
    required this.createdAt
  });

  Map<String,dynamic> toMap()=>{
    'id':id,
    'patient_id':patientId,
    'name':name,
    'age':age,
    'gender':gender,
    'disease':disease,
    'doctor_id':doctorId,
    'created_at':createdAt
  };

  factory Patient.fromMap(Map<String,dynamic> m)=>Patient(
    id:m['id'],
    patientId:m['patient_id'],
    name:m['name'],
    age:m['age'],
    gender:m['gender'],
    disease:m['disease'],
    doctorId:m['doctor_id'],
    createdAt:m['created_at']
  );
}
