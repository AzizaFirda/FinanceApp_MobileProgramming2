import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import '../../../providers/transaction_provider.dart';
import '../../../providers/category_provider.dart';
import '../../../providers/setting_provider.dart';
import '../../../data/models/transaction_model.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with TickerProviderStateMixin {
  DateTime _selectedMonth = DateTime.now();
  late AnimationController _chartController;
  late AnimationController _shimmerController;
  late Animation<double> _chartAnimation;

  // Clean & Professional Color Palette
  static const Color background = Color(0xFFFAF9F7);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF2D3436);
  static const Color textMuted = Color(0xFF636E72);
  static const Color borderLight = Color(0xFFE8E6E3);
  
  // Colorful but Professional Accents
  static const Color tealAccent = Color(0xFF00B894);
  static const Color coralAccent = Color(0xFFFF7675);
  static const Color blueAccent = Color(0xFF0984E3);
  static const Color purpleAccent = Color(0xFF6C5CE7);
  static const Color orangeAccent = Color(0xFFFDAA00);

  // Chart colors
  final List<Color> chartColors = [
    const Color(0xFF0984E3),
    const Color(0xFF00B894),
    const Color(0xFFFF7675),
    const Color(0xFF6C5CE7),
    const Color(0xFFFDAA00),
    const Color(0xFFE84393),
    const Color(0xFF00CEC9),
    const Color(0xFFFD79A8),
  ];

  @override
  void initState() {
    super.initState();
    _chartController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();
    
    _chartAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _chartController, curve: Curves.easeOutCubic));
    _chartController.forward();
  }

  @override
  void dispose() {
    _chartController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          // Background decorations
          ..._buildBackgroundDecorations(),
          
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 20),
                  _buildMonthSelector(context),
                  const SizedBox(height: 24),
                  _buildSummarySection(context),
                  const SizedBox(height: 24),
                  _buildPieChartSection(context),
                  const SizedBox(height: 24),
                  _buildLineChartSection(context),
                  const SizedBox(height: 24),
                  _buildCategoryList(context),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBackgroundDecorations() {
    return [
      Positioned(
        top: -60,
        right: -40,
        child: AnimatedBuilder(
          animation: _shimmerController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _shimmerController.value * 2 * math.pi * 0.05,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      purpleAccent.withOpacity(0.08),
                      purpleAccent.withOpacity(0.02),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      Positioned(
        bottom: 400,
        left: -80,
        child: Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                tealAccent.withOpacity(0.06),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [purpleAccent, blueAccent],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Statistics',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSelector(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: cardWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavButton(
              icon: Icons.chevron_left_rounded,
              onTap: () {
                setState(() {
                  _selectedMonth = DateTime(
                    _selectedMonth.year,
                    _selectedMonth.month - 1,
                  );
                });
                _chartController.reset();
                _chartController.forward();
              },
            ),
            GestureDetector(
              onTap: () => _showMonthPicker(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [blueAccent, purpleAccent],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: blueAccent.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('MMMM yyyy').format(_selectedMonth),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildNavButton(
              icon: Icons.chevron_right_rounded,
              onTap: () {
                setState(() {
                  _selectedMonth = DateTime(
                    _selectedMonth.year,
                    _selectedMonth.month + 1,
                  );
                });
                _chartController.reset();
                _chartController.forward();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: borderLight.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: textDark, size: 24),
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context) {
    return Consumer2<TransactionProvider, SettingsProvider>(
      builder: (context, transactionProvider, settingsProvider, child) {
        final summary = transactionProvider.getMonthlySummary(
          _selectedMonth.year,
          _selectedMonth.month,
        );
        final currency = settingsProvider.userProfile.currency;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  icon: Icons.trending_up_rounded,
                  title: 'Income',
                  amount: summary['income'] ?? 0,
                  currency: currency,
                  color: tealAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  icon: Icons.trending_down_rounded,
                  title: 'Expense',
                  amount: summary['expense'] ?? 0,
                  currency: currency,
                  color: coralAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  icon: Icons.account_balance_wallet_rounded,
                  title: 'Balance',
                  amount: summary['balance'] ?? 0,
                  currency: currency,
                  color: blueAccent,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required double amount,
    required String currency,
    required Color color,
  }) {
    return FadeTransition(
      opacity: _chartAnimation,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                _formatCurrency(amount, currency),
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChartSection(BuildContext context) {
    return Consumer2<TransactionProvider, CategoryProvider>(
      builder: (context, transactionProvider, categoryProvider, child) {
        final expenses = transactionProvider.transactions.where((t) {
          return t.type == TransactionType.expense &&
              t.date.year == _selectedMonth.year &&
              t.date.month == _selectedMonth.month;
        }).toList();

        final categoryTotals = <String, double>{};
        for (final expense in expenses) {
          final category = categoryProvider.getCategoryById(expense.categoryId);
          final name = category?.name ?? 'Other';
          categoryTotals[name] = (categoryTotals[name] ?? 0) + expense.amount;
        }

        if (categoryTotals.isEmpty) {
          return _buildEmptyChart('No expenses this month');
        }

        final sortedCategories = categoryTotals.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final total = categoryTotals.values.fold(0.0, (a, b) => a + b);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FadeTransition(
            opacity: _chartAnimation,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: purpleAccent.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.pie_chart_rounded, color: purpleAccent, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Expense by Category',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 200,
                    child: AnimatedBuilder(
                      animation: _chartAnimation,
                      builder: (context, child) {
                        return PieChart(
                          PieChartData(
                            sectionsSpace: 3,
                            centerSpaceRadius: 50,
                            sections: sortedCategories.asMap().entries.map((entry) {
                              final index = entry.key;
                              final category = entry.value;
                              final percentage = (category.value / total) * 100;
                              return PieChartSectionData(
                                color: chartColors[index % chartColors.length],
                                value: category.value * _chartAnimation.value,
                                title: '${percentage.toStringAsFixed(0)}%',
                                radius: 45,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: sortedCategories.asMap().entries.map((entry) {
                      final index = entry.key;
                      final category = entry.value;
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: chartColors[index % chartColors.length],
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            category.key,
                            style: TextStyle(
                              fontSize: 12,
                              color: textMuted,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLineChartSection(BuildContext context) {
    return Consumer2<TransactionProvider, SettingsProvider>(
      builder: (context, transactionProvider, settingsProvider, child) {
        final expenses = transactionProvider.transactions.where((t) {
          return t.type == TransactionType.expense &&
              t.date.year == _selectedMonth.year &&
              t.date.month == _selectedMonth.month;
        }).toList();

        final daysInMonth = DateTime(
          _selectedMonth.year,
          _selectedMonth.month + 1,
          0,
        ).day;

        final dailyExpenses = List<double>.filled(daysInMonth, 0);
        for (final expense in expenses) {
          dailyExpenses[expense.date.day - 1] += expense.amount;
        }

        final maxExpense = dailyExpenses.reduce((a, b) => a > b ? a : b);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FadeTransition(
            opacity: _chartAnimation,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: coralAccent.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.show_chart_rounded, color: coralAccent, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Daily Expense Trend',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 200,
                    child: AnimatedBuilder(
                      animation: _chartAnimation,
                      builder: (context, child) {
                        return LineChart(
                          LineChartData(
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              horizontalInterval: maxExpense > 0 ? maxExpense / 4 : 1,
                              getDrawingHorizontalLine: (value) => FlLine(
                                color: borderLight,
                                strokeWidth: 1,
                              ),
                            ),
                            titlesData: FlTitlesData(
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 7,
                                  getTitlesWidget: (value, meta) {
                                    if (value.toInt() % 7 == 0 || value.toInt() == daysInMonth - 1) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          '${value.toInt() + 1}',
                                          style: TextStyle(
                                            color: textMuted,
                                            fontSize: 11,
                                          ),
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: dailyExpenses.asMap().entries.map((e) {
                                  return FlSpot(
                                    e.key.toDouble(),
                                    e.value * _chartAnimation.value,
                                  );
                                }).toList(),
                                isCurved: true,
                                color: coralAccent,
                                barWidth: 3,
                                isStrokeCapRound: true,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [
                                      coralAccent.withOpacity(0.3),
                                      coralAccent.withOpacity(0.05),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ],
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
      },
    );
  }

  Widget _buildCategoryList(BuildContext context) {
    return Consumer3<TransactionProvider, CategoryProvider, SettingsProvider>(
      builder: (context, transactionProvider, categoryProvider, settingsProvider, child) {
        final expenses = transactionProvider.transactions.where((t) {
          return t.type == TransactionType.expense &&
              t.date.year == _selectedMonth.year &&
              t.date.month == _selectedMonth.month;
        }).toList();

        final currency = settingsProvider.userProfile.currency;
        final categoryTotals = <String, Map<String, dynamic>>{};
        
        for (final expense in expenses) {
          final category = categoryProvider.getCategoryById(expense.categoryId);
          final name = category?.name ?? 'Other';
          final icon = category?.icon ?? '💰';
          
          if (!categoryTotals.containsKey(name)) {
            categoryTotals[name] = {'amount': 0.0, 'icon': icon};
          }
          categoryTotals[name]!['amount'] = 
              (categoryTotals[name]!['amount'] as double) + expense.amount;
        }

        if (categoryTotals.isEmpty) {
          return const SizedBox.shrink();
        }

        final sortedCategories = categoryTotals.entries.toList()
          ..sort((a, b) => (b.value['amount'] as double).compareTo(a.value['amount'] as double));
        final total = categoryTotals.values
            .fold(0.0, (sum, item) => sum + (item['amount'] as double));

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FadeTransition(
            opacity: _chartAnimation,
            child: Container(
              decoration: BoxDecoration(
                color: cardWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: orangeAccent.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.category_rounded, color: orangeAccent, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Category Breakdown',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sortedCategories.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      indent: 20,
                      endIndent: 20,
                      color: borderLight,
                    ),
                    itemBuilder: (context, index) {
                      final category = sortedCategories[index];
                      final amount = category.value['amount'] as double;
                      final percentage = (amount / total) * 100;
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: chartColors[index % chartColors.length].withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                category.value['icon'] as String,
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    category.key,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: percentage / 100,
                                      backgroundColor: borderLight,
                                      valueColor: AlwaysStoppedAnimation(
                                        chartColors[index % chartColors.length],
                                      ),
                                      minHeight: 6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _formatCurrency(amount, currency),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: textDark,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${percentage.toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    color: textMuted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyChart(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: cardWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderLight),
        ),
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: borderLight,
                ),
                child: Icon(
                  Icons.pie_chart_outline_rounded,
                  size: 40,
                  color: textMuted.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(
                  color: textMuted,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMonthPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: cardWhite,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              decoration: BoxDecoration(
                color: borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Select Month',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: 12,
                itemBuilder: (context, index) {
                  final month = DateTime(DateTime.now().year, index + 1);
                  final isSelected = month.month == _selectedMonth.month &&
                      month.year == _selectedMonth.year;
                  return ListTile(
                    onTap: () {
                      setState(() {
                        _selectedMonth = month;
                      });
                      _chartController.reset();
                      _chartController.forward();
                      Navigator.pop(context);
                    },
                    title: Text(
                      DateFormat('MMMM yyyy').format(month),
                      style: TextStyle(
                        color: isSelected ? blueAccent : textDark,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle_rounded, color: blueAccent)
                        : null,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(double amount, String currency) {
    final formatter = NumberFormat.currency(
      symbol: currency == 'IDR' ? 'Rp ' : '$currency ',
      decimalDigits: currency == 'IDR' ? 0 : 2,
    );
    return formatter.format(amount);
  }
}
