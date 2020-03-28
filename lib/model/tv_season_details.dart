// To parse this JSON data, do
//
//     final tvSeasonDetails = tvSeasonDetailsFromJson(jsonString);

import 'dart:convert';

TvSeasonDetails tvSeasonDetailsFromJson(String str) => TvSeasonDetails.fromMap(json.decode(str));

String tvSeasonDetailsToJson(TvSeasonDetails data) => json.encode(data.toMap());

class TvSeasonDetails {
  String id;
  DateTime airDate;
  List<Episode> episodes;
  String name;
  String overview;
  int tvSeasonDetailsId;
  String posterPath;
  int seasonNumber;

  TvSeasonDetails({
    this.id,
    this.airDate,
    this.episodes,
    this.name,
    this.overview,
    this.tvSeasonDetailsId,
    this.posterPath,
    this.seasonNumber,
  });

  factory TvSeasonDetails.fromMap(Map<String, dynamic> json) => TvSeasonDetails(
    id: json["_id"],
    airDate: DateTime.parse(json["air_date"]),
    episodes: List<Episode>.from(json["episodes"].map((x) => Episode.fromMap(x))),
    name: json["name"],
    overview: json["overview"],
    tvSeasonDetailsId: json["id"],
    posterPath: json["poster_path"],
    seasonNumber: json["season_number"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "air_date": "${airDate.year.toString().padLeft(4, '0')}-${airDate.month.toString().padLeft(2, '0')}-${airDate.day.toString().padLeft(2, '0')}",
    "episodes": List<dynamic>.from(episodes.map((x) => x.toMap())),
    "name": name,
    "overview": overview,
    "id": tvSeasonDetailsId,
    "poster_path": posterPath,
    "season_number": seasonNumber,
  };
}

class Episode {
  DateTime airDate;
  int episodeNumber;
  int id;
  String name;
  String overview;
  String productionCode;
  int seasonNumber;
  int showId;
  String stillPath;
  double voteAverage;
  int voteCount;
  List<Crew> crew;
  List<GuestStar> guestStars;

  Episode({
    this.airDate,
    this.episodeNumber,
    this.id,
    this.name,
    this.overview,
    this.productionCode,
    this.seasonNumber,
    this.showId,
    this.stillPath,
    this.voteAverage,
    this.voteCount,
    this.crew,
    this.guestStars,
  });

  factory Episode.fromMap(Map<String, dynamic> json) => Episode(
    airDate: DateTime.parse(json["air_date"]),
    episodeNumber: json["episode_number"],
    id: json["id"],
    name: json["name"],
    overview: json["overview"],
    productionCode: json["production_code"],
    seasonNumber: json["season_number"],
    showId: json["show_id"],
    stillPath: json["still_path"],
    voteAverage: json["vote_average"].toDouble(),
    voteCount: json["vote_count"],
    crew: List<Crew>.from(json["crew"].map((x) => Crew.fromMap(x))),
    guestStars: List<GuestStar>.from(json["guest_stars"].map((x) => GuestStar.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "air_date": "${airDate.year.toString().padLeft(4, '0')}-${airDate.month.toString().padLeft(2, '0')}-${airDate.day.toString().padLeft(2, '0')}",
    "episode_number": episodeNumber,
    "id": id,
    "name": name,
    "overview": overview,
    "production_code": productionCode,
    "season_number": seasonNumber,
    "show_id": showId,
    "still_path": stillPath,
    "vote_average": voteAverage,
    "vote_count": voteCount,
    "crew": List<dynamic>.from(crew.map((x) => x.toMap())),
    "guest_stars": List<dynamic>.from(guestStars.map((x) => x.toMap())),
  };
}

class Crew {
  int id;
  String creditId;
  String name;
  Department department;
  Job job;
  int gender;
  String profilePath;

  Crew({
    this.id,
    this.creditId,
    this.name,
    this.department,
    this.job,
    this.gender,
    this.profilePath,
  });

  factory Crew.fromMap(Map<String, dynamic> json) => Crew(
    id: json["id"],
    creditId: json["credit_id"],
    name: json["name"],
    department: departmentValues.map[json["department"]],
    job: jobValues.map[json["job"]],
    gender: json["gender"],
    profilePath: json["profile_path"] == null ? null : json["profile_path"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "credit_id": creditId,
    "name": name,
    "department": departmentValues.reverse[department],
    "job": jobValues.reverse[job],
    "gender": gender,
    "profile_path": profilePath == null ? null : profilePath,
  };
}

enum Department { WRITING, DIRECTING }

final departmentValues = EnumValues({
  "Directing": Department.DIRECTING,
  "Writing": Department.WRITING
});

enum Job { WRITER, DIRECTOR }

final jobValues = EnumValues({
  "Director": Job.DIRECTOR,
  "Writer": Job.WRITER
});

class GuestStar {
  int id;
  String name;
  String creditId;
  Character character;
  int order;
  int gender;
  String profilePath;

  GuestStar({
    this.id,
    this.name,
    this.creditId,
    this.character,
    this.order,
    this.gender,
    this.profilePath,
  });

  factory GuestStar.fromMap(Map<String, dynamic> json) => GuestStar(
    id: json["id"],
    name: json["name"],
    creditId: json["credit_id"],
    character: characterValues.map[json["character"]],
    order: json["order"],
    gender: json["gender"],
    profilePath: json["profile_path"] == null ? null : json["profile_path"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "credit_id": creditId,
    "character": characterValues.reverse[character],
    "order": order,
    "gender": gender,
    "profile_path": profilePath == null ? null : profilePath,
  };
}

enum Character { EMPTY, ANGELA_DARE_GWEN_THE_WAITRESS_HOMER_S_COUSIN_S_WIFE_VOICE }

final characterValues = EnumValues({
  "Angela Dare / Gwen the waitress / Homer's cousin's wife (voice)": Character.ANGELA_DARE_GWEN_THE_WAITRESS_HOMER_S_COUSIN_S_WIFE_VOICE,
  "": Character.EMPTY
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
