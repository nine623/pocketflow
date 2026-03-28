import '../models/category_model.dart';

class CategoryEngine {
  static final List<CategoryModel> categories = [
    CategoryModel(
      mainCategory: "Transport",
      subCategory: "Taxi",
      keywords: ["bolt", "grab", "taxi"],
    ),
    CategoryModel(
      mainCategory: "Food",
      subCategory: "Restaurant",
      keywords: ["food", "restaurant", "kfc", "pizza", "mcdonald"],
    ),
    CategoryModel(
      mainCategory: "Car",
      subCategory: "Fuel",
      keywords: ["fuel", "gas", "petrol", "diesel"],
    ),
    CategoryModel(
      mainCategory: "Shopping",
      subCategory: "General",
      keywords: ["shopping", "mall", "shop"],
    ),
  ];

  static CategoryModel? detect(String text) {
    final input = text.toLowerCase();

    for (var category in categories) {
      for (var keyword in category.keywords) {
        if (input.contains(keyword)) {
          return category;
        }
      }
    }

    return null;
  }
}
