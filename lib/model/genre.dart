// To parse this JSON data, do
//
//     final genry = genryFromJson(jsonString);

import 'dart:convert';

Genry genryFromJson(String str) => Genry.fromMap(json.decode(str));

String genryToJson(Genry data) => json.encode(data.toMap());

class Genry {
  List<Genre> genres;

  Genry({
    this.genres,
  });

  factory Genry.fromMap(Map<String, dynamic> json) => Genry(
    genres: List<Genre>.from(json["genres"].map((x) => Genre.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "genres": List<dynamic>.from(genres.map((x) => x.toMap())),
  };
}

class Genre {
  int id;
  String name;

  Genre({
    this.id,
    this.name,
  });

  factory Genre.fromMap(Map<String, dynamic> json) => Genre(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
  };
}
