import 'package:get/get.dart';
import '../core/database/database_helper.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final db = DatabaseHelper.instance;
  Rx<User?> currentUser = Rx(null);
  Future<bool> login(String u, String p) async {
    final d = await db.database;
    final r = await d.query(
      'users',
      where: 'username=? AND password=?',
      whereArgs: [u, p],
    );
    if (r.isNotEmpty) {
      currentUser.value = User.fromMap(r.first);
      return true;
    }
    return false;
  }

  bool get isAdmin => currentUser.value?.role == 'admin';
  bool get isDoctor => currentUser.value?.role == 'doctor';
  bool get isPharmacy => currentUser.value?.role == 'pharmacy';
}
