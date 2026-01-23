import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/account_provider.dart';
import '../../data/models/account_model.dart';

class AddAccountDialog extends StatefulWidget {
  const AddAccountDialog({Key? key}) : super(key: key);

  @override
  State<AddAccountDialog> createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends State<AddAccountDialog> {
  late TextEditingController _nameController;
  late TextEditingController _balanceController;
  late String _selectedIcon;
  late AccountType _selectedType;
  bool _isLoading = false;

  // List of account types and icons (keuangan & barang kredit)
  final Map<String, String> _accountIcons = {
    '💳': 'Credit Card',
    '🏦': 'Bank',
    '📱': 'E-Wallet',
    '💰': 'Cash',
    '💵': 'Cash Stack',
    '🏧': 'ATM',
    '💸': 'Loan/Expenses',
    '🏠': 'Mortgage',
    '🚗': 'Car Loan',
    '🛒': 'Installment',
    '🎓': 'Education Loan',
    '🏥': 'Medical Debt',
    '🧾': 'Bills',
    '🪙': 'Savings',
    '📈': 'Investment',
    '🔁': 'Recurring',
  };

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _balanceController = TextEditingController();
    _selectedIcon = '💳';
    _selectedType = AccountType.cash;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tambah Account Baru',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nama Account',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _balanceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Saldo Awal (Rp)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<AccountType>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: 'Jenis Account',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: AccountType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_getAccountTypeName(type)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Pilih Icon:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: GridView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: _accountIcons.length,
                itemBuilder: (context, index) {
                  final icon = _accountIcons.keys.toList()[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedIcon = icon);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedIcon == icon
                            ? Colors.blue.shade100
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _selectedIcon == icon
                              ? Colors.blue
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(icon, style: const TextStyle(fontSize: 28)),
                          const SizedBox(height: 6),
                          Text(
                            _accountIcons[icon] ?? '',
                            style: const TextStyle(fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _isLoading ? null : _createAccount,
                  child: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor,
                            ),
                          ),
                        )
                      : const Text('Buat'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _createAccount() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama account tidak boleh kosong')),
      );
      return;
    }

    final balance = (num.tryParse(_balanceController.text) ?? 0).toDouble();

    setState(() {
      _isLoading = true;
    });

    try {
      final now = DateTime.now();
      final account = AccountModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        type: _selectedType,
        icon: _selectedIcon,
        color: Colors.blue.value,
        initialBalance: balance,
        currentBalance: balance,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );

      if (!mounted) return;

      await Provider.of<AccountProvider>(context, listen: false)
          .addAccount(account);

      if (!mounted) return;

      Navigator.pop(context, account);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account berhasil dibuat')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getAccountTypeName(AccountType type) {
    switch (type) {
      case AccountType.cash:
        return 'Cash';
      case AccountType.bank:
        return 'Bank';
      case AccountType.ewallet:
        return 'E-wallet';
      case AccountType.liability:
        return 'Liability';
    }
  }
}
