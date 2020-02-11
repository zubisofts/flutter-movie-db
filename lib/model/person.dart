// To parse this JSON data, do
//
//     final person = personFromJson(jsonString);

import 'dart:convert';

Person personFromJson(String str) => Person.fromMap(json.decode(str));

String personToJson(Person data) => json.encode(data.toMap());

class Person {
    final DateTime birthday;
    final String knownForDepartment;
    final dynamic deathday;
    final int id;
    final String name;
    final List<String> alsoKnownAs;
    final int gender;
    final String biography;
    final double popularity;
    final String placeOfBirth;
    final String profilePath;
    final bool adult;
    final String imdbId;
    final String homepage;

    Person({
        this.birthday,
        this.knownForDepartment,
        this.deathday,
        this.id,
        this.name,
        this.alsoKnownAs,
        this.gender,
        this.biography,
        this.popularity,
        this.placeOfBirth,
        this.profilePath,
        this.adult,
        this.imdbId,
        this.homepage,
    });

    factory Person.fromMap(Map<String, dynamic> json) => Person(
        birthday: json["birthday"] == null ? null : DateTime.parse(json["birthday"]),
        knownForDepartment: json["known_for_department"] == null ? null : json["known_for_department"],
        deathday: json["deathday"],
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        alsoKnownAs: json["also_known_as"] == null ? null : List<String>.from(json["also_known_as"].map((x) => x)),
        gender: json["gender"] == null ? null : json["gender"],
        biography: json["biography"] == null ? null : json["biography"],
        popularity: json["popularity"] == null ? null : json["popularity"].toDouble(),
        placeOfBirth: json["place_of_birth"] == null ? null : json["place_of_birth"],
        profilePath: json["profile_path"] == null ? null : json["profile_path"],
        adult: json["adult"] == null ? null : json["adult"],
        imdbId: json["imdb_id"] == null ? null : json["imdb_id"],
        homepage: json["homepage"] == null ? null : json["homepage"],
    );

    Map<String, dynamic> toMap() => {
        "birthday": birthday == null ? null : "${birthday.year.toString().padLeft(4, '0')}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}",
        "known_for_department": knownForDepartment == null ? null : knownForDepartment,
        "deathday": deathday,
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "also_known_as": alsoKnownAs == null ? null : List<dynamic>.from(alsoKnownAs.map((x) => x)),
        "gender": gender == null ? null : gender,
        "biography": biography == null ? null : biography,
        "popularity": popularity == null ? null : popularity,
        "place_of_birth": placeOfBirth == null ? null : placeOfBirth,
        "profile_path": profilePath == null ? null : profilePath,
        "adult": adult == null ? null : adult,
        "imdb_id": imdbId == null ? null : imdbId,
        "homepage": homepage == null ? null : homepage,
    };
}
