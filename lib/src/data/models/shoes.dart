class Shoes {
  int id;
  String image;
  String name;
  String description;
  double price;
  String color;

  Shoes({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.price,
    required this.color,
  });

  factory Shoes.fromJson(Map<String, dynamic> json) => Shoes(
        id: json['id'],
        image: json['image'],
        name: json['name'],
        description: json['description'],
        price: json['price'],
        color: json['color'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['color'] = color;
    return data;
  }
}
