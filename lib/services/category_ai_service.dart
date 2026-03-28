class CategoryAIService {
  static Map<String, String>? detect(String text) {
    final input = text.toLowerCase();

    if (input.contains("taxi") ||
        input.contains("grab") ||
        input.contains("bolt")) {
      return {"main": "Transport", "sub": "Taxi"};
    }

    if (input.contains("coffee") || input.contains("cafe")) {
      return {"main": "Food", "sub": "Coffee"};
    }

    if (input.contains("gas") || input.contains("fuel")) {
      return {"main": "Transport", "sub": "Fuel"};
    }

    if (input.contains("salary")) {
      return {"main": "Income", "sub": "Salary"};
    }

    return null;
  }
}
