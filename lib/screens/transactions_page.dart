import 'package:flutter/material.dart';
import '../services/expense_service.dart';
import '../services/savings_service.dart';
import '../services/auth_service.dart';
import './_unified_transaction.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  static const Color darkGreen = Color(0xFF006231);
  static const Color fieldGreen = Color(0xFFDEF8E1);

  @override
  Widget build(BuildContext context) {
    return const _TransactionsPageBody();
  }
}

class _TransactionsPageBody extends StatefulWidget {
  const _TransactionsPageBody({Key? key}) : super(key: key);

  @override
  State<_TransactionsPageBody> createState() => _TransactionsPageBodyState();
}

class _TransactionsPageBodyState extends State<_TransactionsPageBody> {
  late ExpenseService expenseService;
  late SavingsService savingsService;
  late AuthService authService;

  @override
  void initState() {
    super.initState();
    expenseService = ExpenseService();
    savingsService = SavingsService();
    authService = AuthService();
  }

  void _refresh() {
    setState(() {});
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_bus;
      case 'health':
        return Icons.fitness_center;
      case 'shopping':
        return Icons.shopping_bag;
      case 'rent':
        return Icons.home;
      case 'gift':
        return Icons.card_giftcard;
      case 'savings':
        return Icons.savings;
      case 'entertainment':
        return Icons.movie;
      case 'utilities':
        return Icons.lightbulb;
      case 'income':
        return Icons.attach_money;
      case 'car':
        return Icons.directions_car;
      case 'house':
        return Icons.home;
      case 'wedding':
        return Icons.favorite;
      case 'travel':
        return Icons.flight;
      default:
        return Icons.category;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final expenses = expenseService.expenses;
    final savings = savingsService.savings;
    final List<UnifiedTransaction> allTransactions = [
      ...expenses.map(
        (e) => UnifiedTransaction(
          title: e.title,
          category: e.category,
          date: e.date,
          amount: -e.amount.abs(),
          icon: _getCategoryIcon(e.category),
          isSavings: false,
        ),
      ),
      ...savings.map(
        (s) => UnifiedTransaction(
          title: s.title,
          category: s.category,
          date: s.date,
          amount: s.amount.abs(),
          icon: _getCategoryIcon(s.category),
          isSavings: true,
        ),
      ),
    ];
    allTransactions.sort((a, b) => b.date.compareTo(a.date));

    final double totalBalance = authService.currentUser?.totalBalance ?? 0.0;
    final double totalExpenses = authService.currentUser?.totalExpense ?? 0.0;

    return Container(
      decoration: const BoxDecoration(
        color: TransactionsPage.fieldGreen,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly Breakdown',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: TransactionsPage.darkGreen,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: allTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = allTransactions[index];
                  final isExpense = !transaction.isSavings;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: TransactionsPage.darkGreen.withOpacity(
                          0.1,
                        ),
                        child: Icon(
                          transaction.icon,
                          color: TransactionsPage.darkGreen,
                        ),
                      ),
                      title: Text(
                        transaction.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      subtitle: Text(
                        '${transaction.category} • ${_formatDate(transaction.date)}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.grey,
                        ),
                      ),
                      trailing: Text(
                        '${isExpense ? '-' : '+'}₱${transaction.amount.abs().toStringAsFixed(2)}',
                        style: TextStyle(
                          color: isExpense ? Colors.redAccent : Colors.green,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
