class Savings {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String? message;
  final double targetAmount;

  Savings({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.message,
    required this.targetAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'message': message,
      'targetAmount': targetAmount,
    };
  }

  factory Savings.fromJson(Map<String, dynamic> json) {
    return Savings(
      id: json['id'],
      title: json['title'],
      amount: json['amount'].toDouble(),
      category: json['category'],
      date: DateTime.parse(json['date']),
      message: json['message'],
      targetAmount: json['targetAmount'].toDouble(),
    );
  }
} 