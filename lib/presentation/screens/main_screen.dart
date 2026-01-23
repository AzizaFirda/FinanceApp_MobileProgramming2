import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'statistics/statistics_screen.dart';
import 'assets/assets_screen.dart';
import 'settings/settings_screen.dart';
import 'transaction/add_transaction_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const StatisticsScreen(),
    const AssetsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.bar_chart_rounded,
                  label: 'Statistics',
                  index: 1,
                ),
                _buildNavItem(
                  icon: Icons.account_balance_wallet_rounded,
                  label: 'Assets',
                  index: 2,
                ),
                _buildNavItem(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  index: 3,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _currentIndex != 3
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddTransactionScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    final theme = Theme.of(context);

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentIndex = index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? theme.bottomNavigationBarTheme.selectedItemColor
                    : theme.bottomNavigationBarTheme.unselectedItemColor,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? theme.bottomNavigationBarTheme.selectedItemColor
                      : theme.bottomNavigationBarTheme.unselectedItemColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
