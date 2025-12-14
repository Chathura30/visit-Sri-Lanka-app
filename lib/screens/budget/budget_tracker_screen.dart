// lib/screens/budget/budget_tracker_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../providers/budget_provider.dart';
import '../../models/expense_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_converter.dart';
import '../../widgets/custom_card.dart';

class BudgetTrackerScreen extends StatefulWidget {
  const BudgetTrackerScreen({super.key});

  @override
  State<BudgetTrackerScreen> createState() => _BudgetTrackerScreenState();
}

class _BudgetTrackerScreenState extends State<BudgetTrackerScreen> {
  String? _tripId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tripId = ModalRoute.of(context)?.settings.arguments as String?;
      if (_tripId != null) {
        Provider.of<BudgetProvider>(
          context,
          listen: false,
        ).loadExpenses(_tripId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Tracker'),
        actions: [
          Consumer<BudgetProvider>(
            builder: (context, provider, _) {
              return PopupMenuButton<String>(
                initialValue: provider.selectedCurrency,
                onSelected: (currency) {
                  provider.setSelectedCurrency(currency);
                },
                itemBuilder: (context) {
                  return CurrencyConverter.getSupportedCurrencies()
                      .map(
                        (currency) => PopupMenuItem(
                          value: currency,
                          child: Text(currency),
                        ),
                      )
                      .toList();
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<BudgetProvider>(
        builder: (context, provider, _) {
          if (_tripId == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text('No trip selected'),
                  const SizedBox(height: 8),
                  const Text('Please select a trip to view expenses'),
                ],
              ),
            );
          }

          return Column(
            children: [
              _buildSummaryCard(provider),
              _buildCategoryBreakdown(provider),
              Expanded(child: _buildExpensesList(provider)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddExpenseDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
    );
  }

  Widget _buildSummaryCard(BudgetProvider provider) {
    final total = provider.getTotalExpenses();
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'Total Expenses',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            '${provider.selectedCurrency} ${provider.convertAmount(total, 'LKR', provider.selectedCurrency).toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown(BudgetProvider provider) {
    final categoryTotals = provider.getExpensesByCategory();
    if (categoryTotals.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'By Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...categoryTotals.entries.map((entry) {
              final percentage =
                  (entry.value / provider.getTotalExpenses()) * 100;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key),
                        Text(
                          'LKR ${entry.value.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: Colors.grey[200],
                      color: AppColors.primary,
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesList(BudgetProvider provider) {
    if (provider.expenses.isEmpty) {
      return const Center(
        child: Text('No expenses yet. Add your first expense!'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.expenses.length,
      itemBuilder: (context, index) {
        final expense = provider.expenses[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Icon(Icons.receipt, color: AppColors.primary),
            ),
            title: Text(expense.description),
            subtitle: Text(
              '${expense.category} • ${expense.date.day}/${expense.date.month}/${expense.date.year}',
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${expense.currency} ${expense.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'LKR ${expense.amountInLKR.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddExpenseDialog() {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCurrency = 'LKR';
    String selectedCategory = 'Food';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Expense'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items:
                    [
                          'Food',
                          'Transport',
                          'Accommodation',
                          'Activities',
                          'Shopping',
                          'Other',
                        ]
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) selectedCategory = value;
                },
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                initialValue: selectedCurrency,
                decoration: const InputDecoration(labelText: 'Currency'),
                items: CurrencyConverter.getSupportedCurrencies()
                    .map(
                      (cur) => DropdownMenuItem(value: cur, child: Text(cur)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) selectedCurrency = value;
                },
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_tripId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No trip selected')),
                );
                return;
              }

              final amount = double.tryParse(amountController.text) ?? 0;
              final expense = ExpenseModel(
                id: const Uuid().v4(),
                tripId: _tripId!,
                category: selectedCategory,
                amount: amount,
                currency: selectedCurrency,
                amountInLKR: CurrencyConverter.convertToLKR(
                  amount,
                  selectedCurrency,
                ),
                description: descriptionController.text,
                date: DateTime.now(),
              );

              Provider.of<BudgetProvider>(
                context,
                listen: false,
              ).addExpense(expense);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
