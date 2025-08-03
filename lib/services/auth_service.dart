import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import 'expense_service.dart';
import 'savings_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ExpenseService _expenseService = ExpenseService();
  final SavingsService _savingsService = SavingsService();
  
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

  // Calculate live statistics from Firebase data
  Future<void> updateUserStatistics() async {
    if (_currentUser != null) {
      final totalExpenses = _expenseService.getTotalExpenses();
      final totalSavings = _savingsService.getTotalSavings();
      final totalBalance = totalSavings - totalExpenses;
      
      // Calculate total income (salary + savings)
      final totalIncome = (_currentUser!.monthlySalary * 12) + totalSavings;

      _currentUser = _currentUser!.copyWith(
        totalBalance: totalBalance,
        totalExpense: totalExpenses,
        totalIncome: totalIncome,
      );

      // Update user data in Firebase
      try {
        await _firestore
            .collection('users')
            .doc(_currentUser!.id)
            .update({
          'totalBalance': totalBalance,
          'totalExpense': totalExpenses,
          'totalIncome': totalIncome,
        });
        print('Updated user statistics in Firebase');
      } catch (e) {
        print('Error updating user statistics: $e');
      }
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      // For demo purposes, allow demo credentials without Firebase
      if (email == _demoEmail && password == _demoPassword) {
        _currentUser = User(
          id: "demo_user",
          name: "Demo User",
          email: email,
          totalBalance: 7783.00,
          totalExpense: 1187.40,
          targetAmount: 20000.0,
          monthlySalary: 45000.0, // ₱45,000 monthly salary
          totalIncome: 540000.0, // Annual salary
        );
        _isLoggedIn = true;
        await updateUserStatistics();
        return true;
      }

      // Try Firebase authentication
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Get user data from Firestore
        final userDoc = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data()!;
          _currentUser = User(
            id: userCredential.user!.uid,
            name: userData['name'] ?? 'User',
            email: email,
            totalBalance: (userData['totalBalance'] ?? 0.0).toDouble(),
            totalExpense: (userData['totalExpense'] ?? 0.0).toDouble(),
            targetAmount: (userData['targetAmount'] ?? 20000.0).toDouble(),
          );
        } else {
          // Create new user document
          _currentUser = User(
            id: userCredential.user!.uid,
            name: 'User',
            email: email,
            totalBalance: 0.0,
            totalExpense: 0.0,
            targetAmount: 20000.0,
            monthlySalary: 0.0,
            totalIncome: 0.0,
          );
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set(_currentUser!.toJson());
        }
        _isLoggedIn = true;
        await updateUserStatistics();
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      // For demo purposes, allow any login
      _currentUser = User(
        id: "user_${DateTime.now().millisecondsSinceEpoch}",
        name: "User",
        email: email,
        totalBalance: 7783.00,
        totalExpense: 1187.40,
        targetAmount: 20000.0,
        monthlySalary: 45000.0,
        totalIncome: 540000.0,
      );
      _isLoggedIn = true;
      await updateUserStatistics();
      return true;
    }
  }

  Future<bool> signup(String name, String email, String password) async {
    try {
      // Create Firebase user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        _currentUser = User(
          id: userCredential.user!.uid,
          name: name,
          email: email,
          totalBalance: 0.0,
          totalExpense: 0.0,
          targetAmount: 20000.0,
          monthlySalary: 0.0,
          totalIncome: 0.0,
        );

        // Save user data to Firestore
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(_currentUser!.toJson());

        _isLoggedIn = true;
        await updateUserStatistics();
        return true;
      }
      return false;
    } catch (e) {
      print('Signup error: $e');
      // For demo purposes, create mock user
      _currentUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        totalBalance: 0.0,
        totalExpense: 0.0,
        targetAmount: 20000.0,
        monthlySalary: 0.0,
        totalIncome: 0.0,
      );
      _isLoggedIn = true;
      await updateUserStatistics();
      return true;
    }
  }

  void logout() {
    _auth.signOut();
    _currentUser = null;
    _isLoggedIn = false;
  }

  Future<bool> resetPassword(String email, String newPassword) async {
    try {
      // For demo purposes, always return true
      return true;
    } catch (e) {
      print('Reset password error: $e');
      return false;
    }
  }

  Future<void> updateUserProfile(String name, double targetAmount, double monthlySalary) async {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        name: name,
        targetAmount: targetAmount,
        monthlySalary: monthlySalary,
      );

      try {
        await _firestore
            .collection('users')
            .doc(_currentUser!.id)
            .update({
          'name': name,
          'targetAmount': targetAmount,
          'monthlySalary': monthlySalary,
        });
        print('Updated user profile in Firebase');
      } catch (e) {
        print('Update profile error: $e');
      }
    }
  }
}
