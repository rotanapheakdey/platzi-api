import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthLogic extends ChangeNotifier {
  final _service = AuthService();

  bool _loading = false;
  bool get loading => _loading;

  String? _token;
  Future<bool> login(String email, String password) async {
    _loading = true;
    notifyListeners();

    String? token = await _service.login(email, password);

    if (token != null) {
      _token = token;
      _loading = false;
      notifyListeners();
      return true;
    } else {
      _loading = false;
      notifyListeners();
      return false;
    }

    
  }
  void logout() {
      _token = null;
      notifyListeners();
    }
}
