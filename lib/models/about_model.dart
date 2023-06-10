// To parse this JSON data, do
//
//     final aboutModel = aboutModelFromJson(jsonString);

import 'dart:convert';

AboutModel aboutModelFromJson(String str) => AboutModel.fromJson(json.decode(str));

String aboutModelToJson(AboutModel data) => json.encode(data.toJson());

class AboutModel {
  AboutModel({
    this.status,
    this.message,
    required this.data,
  });

  bool? status;
  dynamic message;
  Data data;

  factory AboutModel.fromJson(Map<String, dynamic> json) => AboutModel(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.about,
    this.terms,
  });

  String about;
  String? terms;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    about: json["about"],
    terms: json["terms"],
  );

  Map<String, dynamic> toJson() => {
    "about": about,
    "terms": terms,
  };
}
