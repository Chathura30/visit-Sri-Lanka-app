// lib/core/utils/currency_converter.dart
class CurrencyConverter {
  // Exchange rates (These should be fetched from an API in production)
  static const Map<String, double> rates = {
    'USD': 320.0,
    'EUR': 350.0,
    'GBP': 400.0,
    'INR': 3.8,
    'AUD': 210.0,
    'LKR': 1.0,
  };

  static double convertToLKR(double amount, String currency) {
    if (currency == 'LKR') return amount;
    return amount * (rates[currency] ?? 1.0);
  }

  static double convertFromLKR(double amount, String currency) {
    if (currency == 'LKR') return amount;
    return amount / (rates[currency] ?? 1.0);
  }

  static List<String> getSupportedCurrencies() {
    return rates.keys.toList();
  }
}
