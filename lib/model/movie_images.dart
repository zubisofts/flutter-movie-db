// To parse this JSON data, do
//
//     final movieImages = movieImagesFromJson(jsonString);

import 'dart:convert';

MovieImages movieImagesFromJson(String str) => MovieImages.fromMap(json.decode(str));

String movieImagesToJson(MovieImages data) => json.encode(data.toMap());

class MovieImages {
    int id;
    List<Backdrop> backdrops;
    List<Backdrop> posters;

    MovieImages({
        this.id,
        this.backdrops,
        this.posters,
    });

    factory MovieImages.fromMap(Map<String, dynamic> json) => MovieImages(
        id: json["id"],
        backdrops: List<Backdrop>.from(json["backdrops"].map((x) => Backdrop.fromMap(x))),
        posters: List<Backdrop>.from(json["posters"].map((x) => Backdrop.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "backdrops": List<dynamic>.from(backdrops.map((x) => x.toMap())),
        "posters": List<dynamic>.from(posters.map((x) => x.toMap())),
    };
}

class Backdrop {
    double aspectRatio;
    String filePath;
    int height;
    String iso6391;
    double voteAverage;
    int voteCount;
    int width;

    Backdrop({
        this.aspectRatio,
        this.filePath,
        this.height,
        this.iso6391,
        this.voteAverage,
        this.voteCount,
        this.width,
    });

    factory Backdrop.fromMap(Map<String, dynamic> json) => Backdrop(
        aspectRatio: json["aspect_ratio"].toDouble(),
        filePath: json["file_path"],
        height: json["height"],
        iso6391: json["iso_639_1"] == null ? null : json["iso_639_1"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
        width: json["width"],
    );

    Map<String, dynamic> toMap() => {
        "aspect_ratio": aspectRatio,
        "file_path": filePath,
        "height": height,
        "iso_639_1": iso6391 == null ? null : iso6391,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "width": width,
    };
}

class Poster {
    double aspectRatio;
    String filePath;
    int height;
    String iso6391;
    double voteAverage;
    int voteCount;
    int width;

    Poster({
        this.aspectRatio,
        this.filePath,
        this.height,
        this.iso6391,
        this.voteAverage,
        this.voteCount,
        this.width,
    });

    factory Poster.fromMap(Map<String, dynamic> json) => Poster(
        aspectRatio: json["aspect_ratio"].toDouble(),
        filePath: json["file_path"],
        height: json["height"],
        iso6391: json["iso_639_1"] == null ? null : json["iso_639_1"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
        width: json["width"],
    );

    Map<String, dynamic> toMap() => {
        "aspect_ratio": aspectRatio,
        "file_path": filePath,
        "height": height,
        "iso_639_1": iso6391 == null ? null : iso6391,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "width": width,
    };
}
