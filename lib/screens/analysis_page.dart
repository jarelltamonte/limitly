import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/expense_service.dart';
import '../services/savings_service.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  // Colors from the design
  static const Color darkGreen = Color(0xFF006231);
  static const Color fieldGreen = Color(0xFFDEF8E1);
  static const Color expenseColor = Color(0xFFFFD900);
  static const Color goalColor = Colors.white70;

  final ExpenseService _expenseService = ExpenseService();
  final SavingsService _savingsService = SavingsService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkGreen,
      appBar: AppBar(
        title: const Text(
          'Monthly Analysis',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: darkGreen,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
      ),
      body: Column(
        children: [
          // Upper Section
          _buildUpperSection(),
          // Lower Section
          _buildLowerSection(),
        ],
      ),
    );
  }

  Widget _buildUpperSection() {
    final double targetBudget = _authService.currentUser?.targetAmount ?? 30000.00;
    final double totalExpenses = _expenseService.getTotalExpenses();
    final double totalSavings = _savingsService.getTotalSavings();
    final bool isOverBudget = totalExpenses > targetBudget;
    final Color currentExpenseColor =
        isOverBudget ? Colors.redAccent : expenseColor;

    return Container(
      color: darkGreen,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Goal Budget
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Goal Budget',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '₱${targetBudget.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              // Total Expenses
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total Expenses',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '₱${totalExpenses.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: currentExpenseColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Additional Statistics
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Total Savings
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Savings',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '₱${totalSavings.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              // Progress Percentage
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Budget Used',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${((totalExpenses / targetBudget) * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: currentExpenseColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLowerSection() {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: fieldGreen,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Category Breakdown',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: darkGreen,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Expense Categories Chart
                      _buildExpenseCategoriesChart(),
                      const SizedBox(height: 30),
                      // Savings Progress Chart
                      _buildSavingsProgressChart(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpenseCategoriesChart() {
    final categories = _expenseService.categories;
    final categoryData = categories.map((category) {
      final total = _expenseService.getTotalExpenseByCategory(category);
      return {'category': category, 'amount': total};
    }).where((data) => (data['amount'] as double) > 0).toList();

    if (categoryData.isEmpty) {
      return Container(
        height: 200,
        child: Center(
          child: Text(
            'No expense data available',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Expense Categories',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: darkGreen,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: categoryData.map((data) {
                final category = data['category'] as String;
                final amount = data['amount'] as double;
                final total = _expenseService.getTotalExpenses();
                final percentage = total > 0 ? (amount / total) : 0.0;
                
                return PieChartSectionData(
                  color: _getCategoryColor(category),
                  value: amount,
                  title: '${percentage.toStringAsFixed(1)}%',
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
              centerSpaceRadius: 40,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Legend
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: categoryData.map((data) {
            final category = data['category'] as String;
            final amount = data['amount'] as double;
            
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getCategoryColor(category),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '$category: ₱${amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    color: darkGreen,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSavingsProgressChart() {
    final categories = _savingsService.categories;
    final categoryData = categories.map((category) {
      final saved = _savingsService.getTotalSavingsByCategory(category);
      final target = _savingsService.getTargetAmount(category);
      final progress = target > 0 ? (saved / target) * 100 : 0.0;
      
      return {
        'category': category,
        'saved': saved,
        'target': target,
        'progress': progress,
      };
    }).where((data) => (data['target'] as double) > 0).toList();

    if (categoryData.isEmpty) {
      return Container(
        height: 200,
        child: Center(
          child: Text(
            'No savings data available',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Savings Progress',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: darkGreen,
          ),
        ),
        const SizedBox(height: 16),
        ...categoryData.map((data) {
          final category = data['category'] as String;
          final saved = data['saved'] as double;
          final target = data['target'] as double;
          final progress = data['progress'] as double;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: darkGreen,
                      ),
                    ),
                    Text(
                      '${progress.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: darkGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress >= 100 ? Colors.green : darkGreen,
                  ),
                  minHeight: 8,
                ),
                const SizedBox(height: 4),
                Text(
                  '₱${saved.toStringAsFixed(2)} / ₱${target.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Colors.orange;
      case 'transport':
        return Colors.blue;
      case 'health':
        return Colors.red;
      case 'shopping':
        return Colors.purple;
      case 'rent':
        return Colors.brown;
      case 'gift':
        return Colors.pink;
      case 'savings':
        return Colors.green;
      case 'entertainment':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }
}
