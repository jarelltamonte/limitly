import '../models/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  User? _currentUser;
  bool _isLoggedIn = false;

  // Demo user credentials
  static const String _demoEmail = "demo@limitly.com";
  static const String _demoPassword = "password123";

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  void setCurrentUser(User user) {
    _currentUser = user;
  }

  Future<bool> login(String email, String password) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 1000));

    // Check demo credentials
    if (email == _demoEmail && password == _demoPassword) {
      _currentUser = User(
        id: "1",
        name: "Demo User",
        email: email,
        totalBalance: 7783.00,
        totalExpense: 1187.40,
        targetAmount: 20000.0,
      );
      _isLoggedIn = true;
      return true;
    }

    // For any other email/password combination, also allow login (for demo purposes)
    _currentUser = User(
      id: "2",
      name: "User",
      email: email,
      totalBalance: 7783.00,
      totalExpense: 1187.40,
      targetAmount: 20000.0,
    );
    _isLoggedIn = true;
    return true;
  }

  Future<bool> signup(String name, String email, String password) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 1000));

    _currentUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      totalBalance: 0.0,
      totalExpense: 0.0,
      targetAmount: 20000.0,
    );
    _isLoggedIn = true;
    return true;
  }

  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
  }

  Future<bool> resetPassword(String email, String newPassword) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 1000));
    return true; // Always return true for demo
  }
}
