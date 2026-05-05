class Sport {
  final int id;
  final String name;
  final String? icon;
  final String? description;

  Sport({
    required this.id,
    required this.name,
    this.icon,
    this.description,
  });

  factory Sport.fromJson(Map<String, dynamic> json) {
    return Sport(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      description: json['description'],
    );
  }
}