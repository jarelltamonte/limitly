import '../models/savings.dart';

class SavingsService {
  static final SavingsService _instance = SavingsService._internal();
  factory SavingsService() => _instance;
  SavingsService._internal();

  final List<Savings> _savings = [
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
  ];

  final List<String> _categories = [
    "Travel",
    "House",
    "Car",
    "Wedding",
  ];

  final Map<String, double> _targetAmounts = {
    "Travel": 20000.0,
    "House": 500250.0,
    "Car": 54190.0,
    "Wedding": 14190.0,
  };

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

  Future<void> addSavings(Savings saving) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));
    _savings.add(saving);
  }

  Future<void> deleteSavings(String id) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));
    _savings.removeWhere((saving) => saving.id == id);
  }

  Future<void> addCategory(String category, double targetAmount) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));
    if (!_categories.contains(category)) {
      _categories.add(category);
      _targetAmounts[category] = targetAmount;
    }
  }
} 