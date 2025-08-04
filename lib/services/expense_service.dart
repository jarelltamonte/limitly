import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class ExpenseService {
  static final ExpenseService _instance = ExpenseService._internal();
  factory ExpenseService() => _instance;
  ExpenseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<Expense> _expenses = [];
  final List<String> _categories = [];

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
    // Skip if already loaded
    if (_expenses.isNotEmpty) {
      print('Expenses already loaded, skipping Firebase call');
      return;
    }
    
    try {
      print('Loading expenses from Firebase...');
      final snapshot = await _firestore.collection('expenses').get();
      _expenses.clear();
      print('Found ${snapshot.docs.length} expense documents');
      
      for (var doc in snapshot.docs) {
        try {
          print('Processing expense document: ${doc.id}');
          final data = doc.data();
          print('Document data: $data');
          _expenses.add(Expense.fromJson(data));
        } catch (e) {
          print('Error parsing expense document ${doc.id}: $e');
        }
      }
      print('Successfully loaded ${_expenses.length} expenses from Firebase');
    } catch (e) {
      print('Error loading expenses from Firebase: $e');
      print('Falling back to demo data...');
      // Load demo data if Firebase fails
      _loadDemoExpenses();
    }
  }

  Future<void> loadCategories() async {
    // Skip if already loaded
    if (_categories.isNotEmpty) {
      print('Categories already loaded, skipping Firebase call');
      return;
    }
    
    try {
      print('Loading expense categories from Firebase...');
      final snapshot = await _firestore.collection('expense_categories').get();
      _categories.clear();
      print('Found ${snapshot.docs.length} category documents');
      
      for (var doc in snapshot.docs) {
        final data = doc.data();
        print('Category document data: $data');
        _categories.add(doc['name']);
      }
      print('Successfully loaded ${_categories.length} expense categories from Firebase');
    } catch (e) {
      print('Error loading expense categories from Firebase: $e');
      print('Falling back to demo categories...');
      // Load demo categories if Firebase fails
      _loadDemoCategories();
    }
  }

  void _loadDemoExpenses() {
    _expenses.clear();
    _expenses.addAll([
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
    ]);
  }

  void _loadDemoCategories() {
    _categories.clear();
    _categories.addAll([
      "Food",
      "Transport",
      "Health",
      "Shopping",
      "Rent",
      "Gift",
      "Savings",
      "Entertainment",
    ]);
  }

  Future<void> addExpense(Expense expense) async {
    try {
      await _firestore
          .collection('expenses')
          .doc(expense.id)
          .set(expense.toJson());
      _expenses.add(expense);
      print('Added expense to Firebase: ${expense.title}');
    } catch (e) {
      print('Error adding expense: $e');
      _expenses.add(expense);
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      await _firestore.collection('expenses').doc(id).delete();
      _expenses.removeWhere((expense) => expense.id == id);
      print('Deleted expense from Firebase: $id');
    } catch (e) {
      print('Error deleting expense: $e');
      _expenses.removeWhere((expense) => expense.id == id);
    }
  }

  Future<void> addCategory(String category) async {
    if (!_categories.contains(category)) {
      try {
        await _firestore.collection('expense_categories').add({'name': category});
        _categories.add(category);
        print('Added category to Firebase: $category');
      } catch (e) {
        print('Error adding category: $e');
        _categories.add(category);
      }
    }
  }

  // Call these on app start to load data
  Future<void> initialize() async {
    print('Initializing ExpenseService...');
    await loadCategories();
    await loadExpenses();
    print('ExpenseService initialized with ${_expenses.length} expenses and ${_categories.length} categories');
  }
}
