// To parse this JSON data, do
//
//     final productVm = productVmFromJson(jsonString);

import 'dart:convert';

HomeModel productVmFromJson(String str) => HomeModel.fromJson(json.decode(str));

String productVmToJson(HomeModel data) => json.encode(data.toJson());

class HomeModel {
  HomeModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  dynamic message;
  HomeDataModel? data;

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
    status: json["status"],
    message: json["message"],
    data: HomeDataModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data!.toJson(),
  };
}

class HomeDataModel {
  HomeDataModel({
    this.banners,
    this.products,
    this.ad,
  });

  List<BannerModel>? banners;
  List<ProductModel>? products;
  String? ad;

  factory HomeDataModel.fromJson(Map<String, dynamic> json) => HomeDataModel(
    banners: List<BannerModel>.from(json["banners"].map((x) => BannerModel.fromJson(x))),
    products: List<ProductModel>.from(json["products"].map((x) => ProductModel.fromJson(x))),
    ad: json["ad"],
  );

  Map<String, dynamic> toJson() => {
    "banners": List<dynamic>.from(banners!.map((x) => x.toJson())),
    "products": List<dynamic>.from(products!.map((x) => x.toJson())),
    "ad": ad,
  };
}

class BannerModel {
  BannerModel({
    this.id,
    this.image,
    this.category,
    this.product,
  });

  int? id;
  String? image;
  dynamic category;
  dynamic product;

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
    id: json["id"],
    image: json["image"],
    category: json["category"],
    product: json["product"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "category": category,
    "product": product,
  };
}

class ProductModel {
  ProductModel({
    required this.id,
    this.price,
    this.oldPrice,
    this.discount,
    required this.image,
    required this.name,
    this.description,
    this.images,
    this.inFavorites,
    required this.inCart,
  });

  int id;
  double? price;
  double? oldPrice;
  int? discount;
  String image;
  String name;
  String? description;
  List<String>? images;
  bool? inFavorites;
  bool inCart;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json["id"],
    price: json["price"].toDouble(),
    oldPrice: json["old_price"].toDouble(),
    discount: json["discount"],
    image: json["image"],
    name: json["name"],
    description: json["description"],
    images: List<String>.from(json["images"].map((x) => x)),
    inFavorites: json["in_favorites"],
    inCart: json["in_cart"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "price": price,
    "old_price": oldPrice,
    "discount": discount,
    "image": image,
    "name": name,
    "description": description,
    "images": List<dynamic>.from(images!.map((x) => x)),
    "in_favorites": inFavorites,
    "in_cart": inCart,
  };
}
