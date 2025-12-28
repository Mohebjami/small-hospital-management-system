class Medicine {
  final int? id;
  final int prescriptionId;
  final String name;
  final int quantity;
  final double price;

  Medicine({
    this.id,
    required this.prescriptionId,
    required this.name,
    required this.quantity,
    required this.price
  });

  Map<String,dynamic> toMap()=>{
    'id':id,
    'prescription_id':prescriptionId,
    'name':name,
    'quantity':quantity,
    'price':price
  };

  factory Medicine.fromMap(Map<String,dynamic> m)=>Medicine(
    id:m['id'],
    prescriptionId:m['prescription_id'],
    name:m['name'],
    quantity:m['quantity'],
    price:m['price']
  );
}
