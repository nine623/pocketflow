class Category {
  final int? id;
  final String name;
  final String type; // income / expense
  final int color;
  final int icon;

  Category({
    this.id,
    required this.name,
    required this.type,
    required this.color,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'color': color,
      'icon': icon,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      color: map['color'],
      icon: map['icon'],
    );
  }
}
