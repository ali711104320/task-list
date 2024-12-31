class Task {
  int? id;
  String name;
  String details;
  bool isFavorite;

  Task(
      {this.id,
      required this.name,
      required this.details,
      this.isFavorite = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'details': details,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      name: map['name'],
      details: map['details'],
      isFavorite: map['isFavorite'] == 1,
    );
  }
}
