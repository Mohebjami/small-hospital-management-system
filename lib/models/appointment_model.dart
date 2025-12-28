class Appointment {
  final int? id;
  final int patientId;
  final int doctorId;
  final String date;
  final String time;
  final String status;

  Appointment({
    this.id,
    required this.patientId,
    required this.doctorId,
    required this.date,
    required this.time,
    required this.status
  });

  Map<String,dynamic> toMap()=>{
    'id':id,
    'patient_id':patientId,
    'doctor_id':doctorId,
    'date':date,
    'time':time,
    'status':status
  };

  factory Appointment.fromMap(Map<String,dynamic> m)=>Appointment(
    id:m['id'],
    patientId:m['patient_id'],
    doctorId:m['doctor_id'],
    date:m['date'],
    time:m['time'],
    status:m['status']
  );
}
