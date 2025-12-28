class User {
  final int? id;
  final String username;
  final String password;
  final String role;
  final int? refId;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.role,
    this.refId
  });

  Map<String,dynamic> toMap()=>{
    'id':id,
    'username':username,
    'password':password,
    'role':role,
    'ref_id':refId
  };

  factory User.fromMap(Map<String,dynamic> m)=>User(
    id:m['id'],
    username:m['username'],
    password:m['password'],
    role:m['role'],
    refId:m['ref_id']
  );
}
