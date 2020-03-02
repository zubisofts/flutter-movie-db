// To parse this JSON data, do
//
//     final movieReview = movieReviewFromJson(jsonString);

import 'dart:convert';

MovieReview movieReviewFromJson(String str) => MovieReview.fromMap(json.decode(str));

String movieReviewToJson(MovieReview data) => json.encode(data.toMap());

class MovieReview {
  int id;
  int page;
  List<Result> results;
  dynamic totalPages;
  dynamic totalResults;

  MovieReview({
    this.id,
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  factory MovieReview.fromMap(Map<dynamic, dynamic> json) => MovieReview(
    id: json["id"],
    page: json["page"],
    results: List<Result>.from(json["results"].map((x) => Result.fromMap(x))),
    totalPages: json["total_pages"],
    totalResults: json["total_results"],
  );

  Map<dynamic, dynamic> toMap() => {
    "id": id,
    "page": page,
    "results": List<dynamic>.from(results.map((x) => x.toMap())),
    "total_pages": totalPages,
    "total_results": totalResults,
  };
}

class Result {
  String author;
  String content;
  String id;
  String url;

  Result({
    this.author,
    this.content,
    this.id,
    this.url,
  });

  factory Result.fromMap(Map<dynamic, dynamic> json) => Result(
    author: json["author"],
    content: json["content"],
    id: json["id"],
    url: json["url"],
  );

  Map<dynamic, dynamic> toMap() => {
    "author": author,
    "content": content,
    "id": id,
    "url": url,
  };
}
