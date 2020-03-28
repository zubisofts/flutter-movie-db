// To parse this JSON data, do
//
//     final tv = tvFromJson(jsonString);

import 'dart:convert';

Tv tvFromJson(String str) => Tv.fromMap(json.decode(str));

String tvToJson(Tv data) => json.encode(data.toMap());

class Tv {
    int page;
    int totalResults;
    int totalPages;
    List<Result> results;

    Tv({
        this.page,
        this.totalResults,
        this.totalPages,
        this.results,
    });

    factory Tv.fromMap(Map<dynamic, dynamic> json) => Tv(
        page: json["page"],
        totalResults: json["total_results"],
        totalPages: json["total_pages"],
        results: List<Result>.from(json["results"].map((x) => Result.fromMap(x))),
    );

    Map<dynamic, dynamic> toMap() => {
        "page": page,
        "total_results": totalResults,
        "total_pages": totalPages,
        "results": List<dynamic>.from(results.map((x) => x.toMap())),
    };
}

class Result {
    String originalName;
    List<int> genreIds;
    String name;
    dynamic popularity;
    List<String> originCountry;
    dynamic voteCount;
    DateTime firstAirDate;
    String backdropPath;
    OriginalLanguage originalLanguage;
    int id;
    dynamic voteAverage;
    String overview;
    String posterPath;

    Result({
        this.originalName,
        this.genreIds,
        this.name,
        this.popularity,
        this.originCountry,
        this.voteCount,
        this.firstAirDate,
        this.backdropPath,
        this.originalLanguage,
        this.id,
        this.voteAverage,
        this.overview,
        this.posterPath,
    });

    factory Result.fromMap(Map<dynamic, dynamic> json) => Result(
        originalName: json["original_name"],
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        name: json["name"],
        popularity: json["popularity"].toDouble(),
        originCountry: List<String>.from(json["origin_country"].map((x) => x)),
        voteCount: json["vote_count"],
        firstAirDate: DateTime.parse(json["first_air_date"]),
        backdropPath: json["backdrop_path"],
        originalLanguage: originalLanguageValues.map[json["original_language"]],
        id: json["id"],
        voteAverage: json["vote_average"].toDouble(),
        overview: json["overview"],
        posterPath: json["poster_path"],
    );

    Map<dynamic, dynamic> toMap() => {
        "original_name": originalName,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "name": name,
        "popularity": popularity,
        "origin_country": List<dynamic>.from(originCountry.map((x) => x)),
        "vote_count": voteCount,
        "first_air_date": "${firstAirDate.year.toString().padLeft(4, '0')}-${firstAirDate.month.toString().padLeft(2, '0')}-${firstAirDate.day.toString().padLeft(2, '0')}",
        "backdrop_path": backdropPath,
        "original_language": originalLanguageValues.reverse[originalLanguage],
        "id": id,
        "vote_average": voteAverage,
        "overview": overview,
        "poster_path": posterPath,
    };
}

enum OriginalLanguage { EN, NL, JA }

final originalLanguageValues = EnumValues({
    "en": OriginalLanguage.EN,
    "ja": OriginalLanguage.JA,
    "nl": OriginalLanguage.NL
});

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}
