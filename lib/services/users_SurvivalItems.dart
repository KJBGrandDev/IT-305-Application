import 'dart:convert';

const String usersItemsApiUrl =
    'https://raw.githubusercontent.com/KJBGrandDev/Mobile_Dev_MidtermExam_JSON/main/items.json';

UsersItems usersItemsFromJson(String str) =>
    UsersItems.fromJson(json.decode(str));

String usersItemsToJson(UsersItems data) => json.encode(data.toJson());

class UsersItems {
  UsersItems({required this.data});

  final List<Item> data;

  factory UsersItems.fromJson(Map<String, dynamic> json) => UsersItems(
    data: List<Item>.from(
      (json['data'] as List).map((item) => Item.fromJson(item)),
    ),
  );

  Map<String, dynamic> toJson() => {
    'data': List<dynamic>.from(data.map((item) => item.toJson())),
  };
}

class Item {
  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.category,
    required this.quantity,
  });

  final int id;
  final String name;
  final String description;
  final String image;
  final String category;
  final int quantity;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json['id'] as int,
    name: json['name'] as String,
    description: json['description'] as String,
    image: json['image'] as String,
    category: json['category'] as String,
    quantity: json['quantity'] as int,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'image': image,
    'category': category,
    'quantity': quantity,
  };
}
