// lib/providers/budget_provider.dart
import 'package:flutter/material.dart';
import '../models/expense_model.dart';
import '../services/database_service.dart';
import '../services/firebase_service.dart';
import '../services/connectivity_service.dart';
import '../core/utils/currency_converter.dart';

class BudgetProvider with ChangeNotifier {
  List<ExpenseModel> _expenses = [];
  bool _isLoading = false;
  bool _isOnline = false;
  String _selectedCurrency = 'LKR';

  List<ExpenseModel> get expenses => _expenses;
  bool get isLoading => _isLoading;
  bool get isOnline => _isOnline;
  String get selectedCurrency => _selectedCurrency;

  BudgetProvider() {
    _initAsync();
  }

  Future<void> _initAsync() async {
    _isOnline = await ConnectivityService.isConnected();

    ConnectivityService.connectivityStream.listen((connected) {
      if (_isOnline != connected) {
        _isOnline = connected;
        notifyListeners();
      }
    });
  }

  Future<void> loadExpenses(String tripId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _expenses = await DatabaseService.instance.getExpensesByTrip(tripId);

      if (_isOnline) {
        await syncExpenses(tripId);
      }
    } catch (e) {
      print('Error loading expenses: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addExpense(ExpenseModel expense) async {
    await DatabaseService.instance.insertExpense(expense);
    _expenses.add(expense);

    if (_isOnline) {
      await FirebaseService.syncExpense(expense);
    }

    notifyListeners();
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    await DatabaseService.instance.updateExpense(expense);
    final index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _expenses[index] = expense;
    }

    if (_isOnline) {
      await FirebaseService.syncExpense(expense);
    }

    notifyListeners();
  }

  Future<void> deleteExpense(String id) async {
    await DatabaseService.instance.deleteExpense(id);
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  Future<void> syncExpenses(String tripId) async {
    if (!_isOnline) return;

    try {
      for (var expense in _expenses.where((e) => !e.isSynced)) {
        await FirebaseService.syncExpense(expense);
      }
    } catch (e) {
      print('Error syncing expenses: $e');
    }
  }

  double getTotalExpenses() {
    return _expenses.fold(0.0, (sum, expense) => sum + expense.amountInLKR);
  }

  double getTotalByCategory(String category) {
    return _expenses
        .where((e) => e.category == category)
        .fold(0.0, (sum, expense) => sum + expense.amountInLKR);
  }

  Map<String, double> getExpensesByCategory() {
    final Map<String, double> categoryTotals = {};
    for (var expense in _expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amountInLKR;
    }
    return categoryTotals;
  }

  void setSelectedCurrency(String currency) {
    _selectedCurrency = currency;
    notifyListeners();
  }

  double convertAmount(double amount, String fromCurrency, String toCurrency) {
    final inLKR = CurrencyConverter.convertToLKR(amount, fromCurrency);
    return CurrencyConverter.convertFromLKR(inLKR, toCurrency);
  }
}
