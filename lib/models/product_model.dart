// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
    // int id;
    String id;
    String title;
    String slug;
    // int price;
    String price;
    String description;
    Category category;
    List<String> images;
    String creationAt;
    String updatedAt;

    Product({
        required this.id,
        required this.title,
        required this.slug,
        required this.price,
        required this.description,
        required this.category,
        required this.images,
        required this.creationAt,
        required this.updatedAt,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"].toString(),
        title: json["title"].toString(),
        slug: json["slug"].toString(),
        price: json["price"].toString(),
        description: json["description"].toString(),
        category: Category.fromJson(json["category"]),
        images: List<String>.from(json["images"].map((x) => x)),
        creationAt: json["creationAt"].toString(),
        updatedAt: json["updatedAt"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "slug": slug,
        "price": price,
        "description": description,
        "category": category.toJson(),
        "images": List<dynamic>.from(images.map((x) => x)),
        "creationAt": creationAt,
        "updatedAt": updatedAt,
    };
}

class Category {
    // int id;
    String id;
    String name;
    String slug;
    String image;
    String creationAt;
    String updatedAt;

    Category({
        required this.id,
        required this.name,
        required this.slug,
        required this.image,
        required this.creationAt,
        required this.updatedAt,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"].toString(),
        name: json["name"].toString(),
        slug: json["slug"].toString(),
        image: json["image"].toString(),
        creationAt: json["creationAt"].toString(),
        updatedAt: json["updatedAt"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "image": image,
        "creationAt": creationAt,
        "updatedAt": updatedAt,
    };
}
