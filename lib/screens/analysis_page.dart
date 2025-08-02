import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

  // Colors from the design
  static const Color darkGreen = Color(0xFF006231);
  static const Color fieldGreen = Color(0xFFDEF8E1);
  static const Color expenseColor = Color(0xFFFFD900);
  static const Color goalColor = Colors.white70;

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
        iconTheme: const IconThemeData(color: Colors.white),
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
    // Placeholder data for demonstration
    const double goalBudget = 30000.00;
    const double totalExpenses = 32500.50; // Set higher than goal to show red color

    final bool isOverBudget = totalExpenses > goalBudget;
    final Color currentExpenseColor = isOverBudget ? Colors.redAccent : expenseColor;

    return Container(
      color: darkGreen,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
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
                '₱${goalBudget.toStringAsFixed(2)}',
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
                'Monthly Comparison',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: darkGreen,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BarChart(
                  _buildBarChartData(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartData _buildBarChartData() {
    // Placeholder data
    final List<double> monthlyExpenses = [8000, 9500, 8200.50, 6800];
    const double weeklyGoal = 7500; // 30000 / 4

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: 10000, // A bit higher than the max possible weekly value
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          // tooltipBgColor: Colors.blueGrey,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekLabel = _getWeekLabel(group.x.toInt());
            String type = rodIndex == 0 ? 'Goal' : 'Expense';
            return BarTooltipItem(
              '$weekLabel\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: '$type: ₱${rod.toY.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: rod.color,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, TitleMeta meta) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 8.0,
                child: Text(_getWeekLabel(value.toInt()),
                    style: const TextStyle(
                        color: darkGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              );
            },
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              if (value % 2500 == 0 && value > 0) {
                return Text('${(value / 1000).toStringAsFixed(0)}k',
                    style: const TextStyle(color: darkGreen, fontSize: 12));
              }
              return const Text('');
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(4, (i) {
        return BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: weeklyGoal,
              color: goalColor.withOpacity(0.5),
              width: 22,
              borderRadius: BorderRadius.circular(4),
            ),
            BarChartRodData(
              toY: monthlyExpenses[i],
              color: expenseColor,
              width: 22,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
          showingTooltipIndicators: [],
        );
      }),
      gridData: const FlGridData(show: false),
    );
  }

  String _getWeekLabel(int value) {
    switch (value) {
      case 0:
        return 'Week 1';
      case 1:
        return 'Week 2';
      case 2:
        return 'Week 3';
      case 3:
        return 'Week 4';
      default:
        return '';
    }
  }
}
