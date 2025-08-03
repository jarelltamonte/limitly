class User {
  final String id;
  final String name;
  final String email;
  final double totalBalance;
  final double totalExpense;
  final double targetAmount;
  final double monthlySalary;
  final double totalIncome;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.totalBalance = 0.0,
    this.totalExpense = 0.0,
    this.targetAmount = 20000.0,
    this.monthlySalary = 0.0,
    this.totalIncome = 0.0,
  });

  double get progressPercentage {
    if (targetAmount == 0) return 0.0;
    return (totalExpense / targetAmount) * 100;
  }

  double get savingsRate {
    if (totalIncome == 0) return 0.0;
    return ((totalBalance + totalExpense) / totalIncome) * 100;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'totalBalance': totalBalance,
      'totalExpense': totalExpense,
      'targetAmount': targetAmount,
      'monthlySalary': monthlySalary,
      'totalIncome': totalIncome,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      totalBalance: json['totalBalance']?.toDouble() ?? 0.0,
      totalExpense: json['totalExpense']?.toDouble() ?? 0.0,
      targetAmount: json['targetAmount']?.toDouble() ?? 20000.0,
      monthlySalary: json['monthlySalary']?.toDouble() ?? 0.0,
      totalIncome: json['totalIncome']?.toDouble() ?? 0.0,
    );
  }
  User copyWith({
    String? id,
    String? name,
    String? email,
    double? totalBalance,
    double? totalExpense,
    double? targetAmount,
    double? monthlySalary,
    double? totalIncome,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      totalBalance: totalBalance ?? this.totalBalance,
      totalExpense: totalExpense ?? this.totalExpense,
      targetAmount: targetAmount ?? this.targetAmount,
      monthlySalary: monthlySalary ?? this.monthlySalary,
      totalIncome: totalIncome ?? this.totalIncome,
    );
  }
}
