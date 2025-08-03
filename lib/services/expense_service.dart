import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/expense.dart';

class ExpenseService {
  static final ExpenseService _instance = ExpenseService._internal();
  factory ExpenseService() => _instance;
  ExpenseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<Expense> _expenses = [
    Expense(
      id: "1",
      title: "Dinner",
      amount: 26.00,
      category: "Food",
      date: DateTime(2024, 4, 30, 18, 27),
    ),
    Expense(
      id: "2",
      title: "Delivery Pizza",
      amount: 18.35,
      category: "Food",
      date: DateTime(2024, 4, 24, 15, 0),
    ),
    Expense(
      id: "3",
      title: "Lunch",
      amount: 15.40,
      category: "Food",
      date: DateTime(2024, 4, 15, 12, 30),
    ),
    Expense(
      id: "4",
      title: "Brunch",
      amount: 12.13,
      category: "Food",
      date: DateTime(2024, 4, 8, 8, 30),
    ),
    Expense(
      id: "5",
      title: "Dinner",
      amount: 27.20,
      category: "Food",
      date: DateTime(2024, 3, 31, 20, 50),
    ),
  ];

  final List<String> _categories = [
    "Food",
    "Transport",
    "Health",
    "Shopping",
    "Rent",
    "Gift",
    "Savings",
    "Entertainment",
  ];

  List<Expense> get expenses => List.unmodifiable(_expenses);

  List<String> get categories => List.unmodifiable(_categories);

  List<Expense> getExpensesByCategory(String category) {
    return _expenses.where((expense) => expense.category == category).toList();
  }

  double getTotalExpenseByCategory(String category) {
    return _expenses
        .where((expense) => expense.category == category)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  double getTotalExpenses() {
    return _expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  Future<void> loadExpenses() async {
    final snapshot = await _firestore.collection('expenses').get();
    _expenses.clear();
    for (var doc in snapshot.docs) {
      _expenses.add(Expense.fromJson(doc.data()));
    }
  }

  Future<void> loadCategories() async {
    final snapshot = await _firestore.collection('expense_categories').get();
    _categories.clear();
    for (var doc in snapshot.docs) {
      _categories.add(doc['name']);
    }
  }

  Future<void> addExpense(Expense expense) async {
    await _firestore.collection('expenses').doc(expense.id).set(expense.toJson());
    _expenses.add(expense);
  }

  Future<void> deleteExpense(String id) async {
    await _firestore.collection('expenses').doc(id).delete();
    _expenses.removeWhere((expense) => expense.id == id);
  }

  Future<void> addCategory(String category) async {
    if (!_categories.contains(category)) {
      await _firestore.collection('expense_categories').add({'name': category});
      _categories.add(category);
    }
  }

  // Call these on app start to load data
  Future<void> initialize() async {
    await loadCategories();
    await loadExpenses();
  }
}