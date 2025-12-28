class Doctor {
  final int? id;
  final String name;
  final String specialty;

  Doctor({this.id, required this.name, required this.specialty});

  Map<String,dynamic> toMap()=>{
    'id':id,
    'name':name,
    'specialty':specialty
  };

  factory Doctor.fromMap(Map<String,dynamic> m)=>Doctor(
    id:m['id'],
    name:m['name'],
    specialty:m['specialty']
  );
}
