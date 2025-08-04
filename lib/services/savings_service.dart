import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/savings.dart';

class SavingsService {
  static final SavingsService _instance = SavingsService._internal();
  factory SavingsService() => _instance;
  SavingsService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<Savings> _savings = [];
  final List<String> _categories = [];
  final Map<String, double> _targetAmounts = {};

  List<Savings> get savings => List.unmodifiable(_savings);
  List<String> get categories => List.unmodifiable(_categories);

  List<Savings> getSavingsByCategory(String category) {
    return _savings.where((saving) => saving.category == category).toList();
  }

  double getTotalSavingsByCategory(String category) {
    return _savings
        .where((saving) => saving.category == category)
        .fold(0.0, (sum, saving) => sum + saving.amount);
  }

  double getTotalSavings() {
    return _savings.fold(0.0, (sum, saving) => sum + saving.amount);
  }

  double getTargetAmount(String category) {
    return _targetAmounts[category] ?? 0.0;
  }

  double getProgressPercentage(String category) {
    final total = getTotalSavingsByCategory(category);
    final target = getTargetAmount(category);
    if (target == 0) return 0.0;
    return (total / target) * 100;
  }

  Future<void> loadSavings() async {
    // Skip if already loaded
    if (_savings.isNotEmpty) {
      print('Savings already loaded, skipping Firebase call');
      return;
    }
    
    try {
      print('Loading savings from Firebase...');
      final snapshot = await _firestore.collection('savings').get();
      _savings.clear();
      print('Found ${snapshot.docs.length} savings documents');
      
      for (var doc in snapshot.docs) {
        try {
          print('Processing savings document: ${doc.id}');
          final data = doc.data();
          print('Document data: $data');
          _savings.add(Savings.fromJson(data));
        } catch (e) {
          print('Error parsing savings document ${doc.id}: $e');
        }
      }
      print('Successfully loaded ${_savings.length} savings from Firebase');
    } catch (e) {
      print('Error loading savings from Firebase: $e');
      print('Falling back to demo data...');
      // Load demo data if Firebase fails
      _loadDemoSavings();
    }
  }

  Future<void> loadCategories() async {
    // Skip if already loaded
    if (_categories.isNotEmpty) {
      print('Savings categories already loaded, skipping Firebase call');
      return;
    }
    
    try {
      print('Loading savings categories from Firebase...');
      final snapshot = await _firestore.collection('savings_categories').get();
      _categories.clear();
      _targetAmounts.clear();
      print('Found ${snapshot.docs.length} savings category documents');
      
      for (var doc in snapshot.docs) {
        final data = doc.data();
        print('Savings category document data: $data');
        _categories.add(doc['name']);
        _targetAmounts[doc['name']] = doc['targetAmount']?.toDouble() ?? 0.0;
      }
      print('Successfully loaded ${_categories.length} savings categories from Firebase');
    } catch (e) {
      print('Error loading savings categories from Firebase: $e');
      print('Falling back to demo categories...');
      // Load demo categories if Firebase fails
      _loadDemoCategories();
    }
  }

  void _loadDemoSavings() {
    _savings.clear();
    _savings.addAll([
      // Travel savings
      Savings(
        id: "1",
        title: "Travel Deposit",
        amount: 231.17,
        category: "Travel",
        date: DateTime(2024, 4, 30, 16, 0),
        targetAmount: 20000.0,
      ),
      Savings(
        id: "2",
        title: "Travel Deposit",
        amount: 231.17,
        category: "Travel",
        date: DateTime(2024, 4, 14, 17, 0),
        targetAmount: 20000.0,
      ),
      Savings(
        id: "3",
        title: "Travel Deposit",
        amount: 191.17,
        category: "Travel",
        date: DateTime(2024, 4, 2, 13, 20),
        targetAmount: 20000.0,
      ),

      // House savings
      Savings(
        id: "4",
        title: "House Deposit",
        amount: 231.17,
        category: "House",
        date: DateTime(2024, 4, 1, 19, 55),
        targetAmount: 500250.0,
      ),
      Savings(
        id: "5",
        title: "House Deposit",
        amount: 231.17,
        category: "House",
        date: DateTime(2024, 1, 18, 20, 20),
        targetAmount: 500250.0,
      ),
      Savings(
        id: "6",
        title: "House Deposit",
        amount: 163.14,
        category: "House",
        date: DateTime(2024, 1, 10, 19, 0),
        targetAmount: 500250.0,
      ),

      // Car savings
      Savings(
        id: "7",
        title: "Car Deposit",
        amount: 231.17,
        category: "Car",
        date: DateTime(2024, 7, 1, 12, 0),
        targetAmount: 54190.0,
      ),
      Savings(
        id: "8",
        title: "Car Deposit",
        amount: 231.17,
        category: "Car",
        date: DateTime(2024, 5, 31, 15, 30),
        targetAmount: 54190.0,
      ),
      Savings(
        id: "9",
        title: "House Deposit",
        amount: 133.91,
        category: "Car",
        date: DateTime(2024, 5, 9, 10, 0),
        targetAmount: 54190.0,
      ),

      // Wedding savings
      Savings(
        id: "10",
        title: "Wedding Deposit",
        amount: 183.32,
        category: "Wedding",
        date: DateTime(2024, 11, 15, 18, 45),
        targetAmount: 14190.0,
      ),
      Savings(
        id: "11",
        title: "Wedding Deposit",
        amount: 183.32,
        category: "Wedding",
        date: DateTime(2024, 9, 20, 20, 0),
        targetAmount: 14190.0,
      ),
      Savings(
        id: "12",
        title: "Wedding Deposit",
        amount: 183.32,
        category: "Wedding",
        date: DateTime(2024, 9, 15, 19, 0),
        targetAmount: 14190.0,
      ),
    ]);
  }

  void _loadDemoCategories() {
    _categories.clear();
    _targetAmounts.clear();
    _categories.addAll(["Travel", "House", "Car", "Wedding"]);
    _targetAmounts.addAll({
      "Travel": 20000.0,
      "House": 500250.0,
      "Car": 54190.0,
      "Wedding": 14190.0,
    });
  }

  Future<void> addSavings(Savings saving) async {
    try {
      await _firestore.collection('savings').doc(saving.id).set(saving.toJson());
      _savings.add(saving);
      print('Added savings to Firebase: ${saving.title}');
    } catch (e) {
      print('Error adding savings: $e');
      _savings.add(saving);
    }
  }

  Future<void> deleteSavings(String id) async {
    try {
      await _firestore.collection('savings').doc(id).delete();
      _savings.removeWhere((saving) => saving.id == id);
      print('Deleted savings from Firebase: $id');
    } catch (e) {
      print('Error deleting savings: $e');
      _savings.removeWhere((saving) => saving.id == id);
    }
  }

  Future<void> addCategory(String category, double targetAmount) async {
    if (!_categories.contains(category)) {
      try {
        await _firestore.collection('savings_categories').add({
          'name': category,
          'targetAmount': targetAmount,
        });
        _categories.add(category);
        _targetAmounts[category] = targetAmount;
        print('Added savings category to Firebase: $category');
      } catch (e) {
        print('Error adding savings category: $e');
        _categories.add(category);
        _targetAmounts[category] = targetAmount;
      }
    }
  }

  // Call these on app start to load data
  Future<void> initialize() async {
    print('Initializing SavingsService...');
    await loadCategories();
    await loadSavings();
    print('SavingsService initialized with ${_savings.length} savings and ${_categories.length} categories');
  }
}
