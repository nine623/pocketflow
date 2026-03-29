class CategoryAIService {
  static final Map<String, Map<String, String>> rules = {
    'กาแฟ': {'main': 'Food', 'sub': 'Drink'},
    'coffee': {'main': 'Food', 'sub': 'Drink'},
    'ข้าว': {'main': 'Food', 'sub': 'Eat'},
    'อาหาร': {'main': 'Food', 'sub': 'Eat'},
    'bolt': {'main': 'Transport', 'sub': 'Taxi'},
    'grab': {'main': 'Transport', 'sub': 'Taxi'},
    'เงินเดือน': {'main': 'Income', 'sub': 'Salary'},
    'salary': {'main': 'Income', 'sub': 'Salary'},
  };

  static Map<String, String>? detect(String text) {
    text = text.toLowerCase();

    for (var key in rules.keys) {
      if (text.contains(key)) {
        return rules[key];
      }
    }
    return null;
  }
}
