class Cat {
  int id;
  String name;
  String image;

  Cat({required this.id, required this.name, required this.image});

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      id: json['id'] ?? 0,
      name: json['name'] ?? "No Name",
      image: json['image'] ?? "https://placehold.co/600x400",
    );
  }
}