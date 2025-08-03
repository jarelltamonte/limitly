import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/savings_service.dart';
import '../intro.dart';
import 'savings_category_detail.dart';
import 'dashboard.dart';
import 'profile_page.dart';

class SavingsDashboard extends StatefulWidget {
  const SavingsDashboard({super.key});

  @override
  State<SavingsDashboard> createState() => _SavingsDashboardState();
}

class _SavingsDashboardState extends State<SavingsDashboard> {
  final AuthService _authService = AuthService();
  final SavingsService _savingsService = SavingsService();
  int _currentIndex = 4; // Savings tab is selected

  @override
  Widget build(BuildContext context) {
    final darkGreen = const Color(0xFF006231);
    final lightGreen = const Color(0xFFEAF8EF);
    final lightBlue = const Color(0xFFE3F2FD);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header with balance and progress
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: darkGreen,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Balance',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₱${_authService.currentUser?.totalBalance.toStringAsFixed(2) ?? '0.00'}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Total Savings',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₱${_savingsService.getTotalSavings().toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Dynamic Progress Bar
                Builder(
                  builder: (context) {
                    double totalTarget = 0.0;
                    for (var category in _savingsService.categories) {
                      final target = _savingsService.getTargetAmount(category);
                      totalTarget += target;
                    }
                    if (totalTarget == 0.0) {
                      totalTarget =
                          _authService.currentUser?.targetAmount ?? 20000.0;
                    }
                    final totalSavings = _savingsService.getTotalSavings();
                    final progress =
                        (totalTarget == 0.0)
                            ? 0.0
                            : (totalSavings / totalTarget).clamp(0.0, 1.0);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${(progress * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              'Target: ₱${totalTarget.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          minHeight: 8,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          // Savings Categories Grid
          Expanded(
            child: Container(
              color: lightGreen,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    'Savings',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Color(0xFF006231),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.0,
                          ),
                      itemCount: _savingsService.categories.length,
                      itemBuilder: (context, index) {
                        final category = _savingsService.categories[index];
                        final totalAmount = _savingsService
                            .getTotalSavingsByCategory(category);

                        return _buildSavingsCard(
                          icon: _getCategoryIcon(category),
                          title: category,
                          amount: totalAmount,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => SavingsCategoryDetail(
                                      category: category,
                                    ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        _showAddCategoryDialog(context);
                      },
                      child: const Text(
                        'Add More',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Navigation
          Container(
            color: lightGreen,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home, 'Home', 0),
                _buildNavItem(Icons.bar_chart, 'Statistics', 1),
                _buildNavItem(Icons.swap_horiz, 'Transactions', 2),
                _buildNavItem(Icons.category, 'Categories', 3),
                _buildNavItem(Icons.savings, 'Savings', 4),
                _buildNavItem(Icons.person, 'Profile', 5),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsCard({
    required IconData icon,
    required String title,
    required double amount,
    required VoidCallback onTap,
  }) {
    final lightBlue = const Color(0xFFE3F2FD);
    final darkBlue = const Color(0xFF1976D2);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: lightBlue,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: darkBlue),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Color(0xFF1976D2),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '₱${amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                color: Color(0xFF1976D2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    final darkGreen = const Color(0xFF006231);

    return GestureDetector(
      onTap: () {
        if (index == 5) {
          _showProfileOptions(context);
        } else if (index == 3) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Dashboard()),
          );
        } else {
          setState(() {
            _currentIndex = index;
          });
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected ? darkGreen : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey,
              size: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontFamily: 'Poppins',
              color: isSelected ? darkGreen : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'travel':
        return Icons.flight;
      case 'house':
        return Icons.home;
      case 'car':
        return Icons.directions_car;
      case 'wedding':
        return Icons.favorite;
      default:
        return Icons.savings;
    }
  }

  void _showAddCategoryDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController targetController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New Savings Category'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: targetController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Target Amount',
                    prefixText: '₱',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isNotEmpty &&
                      targetController.text.isNotEmpty) {
                    final targetAmount = double.tryParse(targetController.text);
                    if (targetAmount != null && targetAmount > 0) {
                      await _savingsService.addCategory(
                        nameController.text,
                        targetAmount,
                      );
                      setState(() {});
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  void _showProfileOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    _authService.logout();
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const IntroPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
    );
  }
}
