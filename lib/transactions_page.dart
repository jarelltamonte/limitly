import 'package:flutter/material.dart';

// A simple data model for a transaction
class Transaction {
  final String title;
  final String category;
  final String date;
  final double amount;
  final IconData icon;

  const Transaction({
    required this.title,
    required this.category,
    required this.date,
    required this.amount,
    required this.icon,
  });
}

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  // Colors from the design
  static const Color darkGreen = Color(0xFF006231);
  static const Color fieldGreen = Color(0xFFDEF8E1);

  // Placeholder data
  final double totalBalance = 25000.00; // Adjusted to show expense warning
  final double totalExpenses = 32500.50; // This is now higher than the balance

  final List<Transaction> transactions = const [
    Transaction(title: 'Groceries', category: 'Food', date: '2024-05-20', amount: -150.75, icon: Icons.shopping_cart),
    Transaction(title: 'Salary', category: 'Income', date: '2024-05-19', amount: 2500.00, icon: Icons.attach_money),
    Transaction(title: 'Netflix Subscription', category: 'Entertainment', date: '2024-05-18', amount: -15.99, icon: Icons.movie),
    Transaction(title: 'Gasoline', category: 'Transport', date: '2024-05-17', amount: -45.50, icon: Icons.local_gas_station),
    Transaction(title: 'Restaurant', category: 'Food', date: '2024-05-16', amount: -75.20, icon: Icons.restaurant),
    Transaction(title: 'Freelance Project', category: 'Income', date: '2024-05-15', amount: 800.00, icon: Icons.work),
    Transaction(title: 'Electricity Bill', category: 'Utilities', date: '2024-05-14', amount: -95.00, icon: Icons.lightbulb),
    Transaction(title: 'Gym Membership', category: 'Health', date: '2024-05-13', amount: -50.00, icon: Icons.fitness_center),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkGreen,
      appBar: AppBar(
        title: const Text(
          'Transactions',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: darkGreen,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: 100,
      ),
      body: Column(
        children: [
          _buildUpperSection(),
          _buildLowerSection(),
        ],
      ),
    );
  }

  Widget _buildUpperSection() {
    // Logic to change text color if expenses exceed balance
    final bool expensesExceedBalance = totalExpenses > totalBalance;
    final Color expenseTextColor = expensesExceedBalance ? Colors.redAccent : const Color(0xFFFFD900);

    return Container(
      color: darkGreen,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Total Balance
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Balance',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '₱${totalBalance.toStringAsFixed(2)}',
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
              const Text(
                'Total Expenses',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '₱${totalExpenses.toStringAsFixed(2)}',
                style: TextStyle(
                  color: expenseTextColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
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
                  color: darkGreen,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    final isExpense = transaction.amount < 0;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: darkGreen.withOpacity(0.1),
                          child: Icon(transaction.icon, color: darkGreen),
                        ),
                        title: Text(
                          transaction.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        subtitle: Text(
                          '${transaction.category} • ${transaction.date}',
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
      ),
    );
  }
}
