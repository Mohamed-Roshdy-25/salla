// To parse this JSON data, do
//
//     final cartsChangeModel = cartsChangeModelFromJson(jsonString);

import 'dart:convert';

ChangeCartsModel cartsChangeModelFromJson(String str) => ChangeCartsModel.fromJson(json.decode(str));

String cartsChangeModelToJson(ChangeCartsModel data) => json.encode(data.toJson());

class ChangeCartsModel {
  ChangeCartsModel({
    this.status,
    required this.message,
    this.data,
  });

  bool? status;
  late String message;
  Data? data;

  factory ChangeCartsModel.fromJson(Map<String, dynamic> json) => ChangeCartsModel(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.quantity,
    this.product,
  });

  int? id;
  int? quantity;
  Product? product;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    quantity: json["quantity"],
    product: Product.fromJson(json["product"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "quantity": quantity,
    "product": product!.toJson(),
  };
}

class Product {
  Product({
    this.id,
    this.price,
    this.oldPrice,
    this.discount,
    this.image,
    this.name,
    this.description,
  });

  int? id;
  dynamic price;
  dynamic oldPrice;
  int? discount;
  String? image;
  String? name;
  String? description;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    price: json["price"],
    oldPrice: json["old_price"],
    discount: json["discount"],
    image: json["image"],
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "price": price,
    "old_price": oldPrice,
    "discount": discount,
    "image": image,
    "name": name,
    "description": description,
  };
}
