import 'package:flutter_ui_challenge/respository/constants.dart';

class MovieDetails {
  bool _adult;
  String _backdropPath;
  dynamic _budget;
  List<Genres> _genres;
  int _id;
  String _imdbId;
  String _originalLanguage;
  String _originalTitle;
  String _overview;
  double _popularity;
  String _posterPath;
  List<ProductionCountries> _productionCountries;
  String _releaseDate;
  dynamic _revenue;
  dynamic _runtime;
  List<SpokenLanguages> _spokenLanguages;
  String _status;
  String _tagline;
  String _title;
  bool _video;
  dynamic _voteAverage;
  dynamic _voteCount;

  MovieDetails(
      {bool adult,
      String backdropPath,
      int budget,
      List<Genres> genres,
      int id,
      String imdbId,
      String originalLanguage,
      String originalTitle,
      String overview,
      double popularity,
      String posterPath,
      List<ProductionCountries> productionCountries,
      String releaseDate,
      dynamic revenue,
      dynamic runtime,
      List<SpokenLanguages> spokenLanguages,
      String status,
      String tagline,
      String title,
      bool video,
      dynamic voteAverage,
      dynamic voteCount}) {
    this._adult = adult;
    this._backdropPath = backdropPath;
    this._budget = budget;
    this._genres = genres;
    this._id = id;
    this._imdbId = imdbId;
    this._originalLanguage = originalLanguage;
    this._originalTitle = originalTitle;
    this._overview = overview;
    this._popularity = popularity;
    this._posterPath = posterPath;
    this._productionCountries = productionCountries;
    this._releaseDate = releaseDate;
    this._revenue = revenue;
    this._runtime = runtime;
    this._spokenLanguages = spokenLanguages;
    this._status = status;
    this._tagline = tagline;
    this._title = title;
    this._video = video;
    this._voteAverage = voteAverage;
    this._voteCount = voteCount;
  }

  bool get adult => _adult;
  set adult(bool adult) => _adult = adult;
  String get backdropPath => _backdropPath;
  set backdropPath(String backdropPath) => _backdropPath = backdropPath;
  dynamic get budget => _budget;
  set budget(dynamic budget) => _budget = budget;
  List<Genres> get genres => _genres;
  set genres(List<Genres> genres) => _genres = genres;
  int get id => _id;
  set id(int id) => _id = id;
  String get imdbId => _imdbId;
  set imdbId(String imdbId) => _imdbId = imdbId;
  String get originalLanguage => _originalLanguage;
  set originalLanguage(String originalLanguage) =>
      _originalLanguage = originalLanguage;
  String get originalTitle => _originalTitle;
  set originalTitle(String originalTitle) => _originalTitle = originalTitle;
  String get overview => _overview;
  set overview(String overview) => _overview = overview;
  double get popularity => _popularity;
  set popularity(double popularity) => _popularity = popularity;
  String get posterPath => _posterPath;
  set posterPath(String posterPath) => _posterPath = posterPath;
  List<ProductionCountries> get productionCountries => _productionCountries;
  set productionCountries(List<ProductionCountries> productionCountries) =>
      _productionCountries = productionCountries;
  String get releaseDate => _releaseDate;
  set releaseDate(String releaseDate) => _releaseDate = releaseDate;
  dynamic get revenue => _revenue;
  set revenue(dynamic revenue) => _revenue = revenue;
  dynamic get runtime => _runtime;
  set runtime(dynamic runtime) => _runtime = runtime;
  List<SpokenLanguages> get spokenLanguages => _spokenLanguages;
  set spokenLanguages(List<SpokenLanguages> spokenLanguages) =>
      _spokenLanguages = spokenLanguages;
  String get status => _status;
  set status(String status) => _status = status;
  String get tagline => _tagline;
  set tagline(String tagline) => _tagline = tagline;
  String get title => _title;
  set title(String title) => _title = title;
  bool get video => _video;
  set video(bool video) => _video = video;
  dynamic get voteAverage => _voteAverage;
  set voteAverage(dynamic voteAverage) => _voteAverage = voteAverage;
  dynamic get voteCount => _voteCount;
  set voteCount(dynamic voteCount) => _voteCount = voteCount;

  MovieDetails.fromJson(Map<String, dynamic> json) {
    _adult = json['adult'];
    _backdropPath = json['backdrop_path'];
    _budget = json['budget'];
    if (json['genres'] != null) {
      _genres = new List<Genres>();
      json['genres'].forEach((v) {
        _genres.add(new Genres.fromJson(v));
      });
    }
    _id = json['id'];
    _imdbId = json['imdb_id'];
    _originalLanguage = json['original_language'];
    _originalTitle = json['original_title'];
    _overview = json['overview'];
    _popularity = json['popularity'];
    _posterPath = IMAGE_URL+json['poster_path'];
    if (json['production_countries'] != null) {
      _productionCountries = new List<ProductionCountries>();
      json['production_countries'].forEach((v) {
        _productionCountries.add(new ProductionCountries.fromJson(v));
      });
    }
    _releaseDate = json['release_date'];
    _revenue = json['revenue'];
    _runtime = json['runtime'];
    if (json['spoken_languages'] != null) {
      _spokenLanguages = new List<SpokenLanguages>();
      json['spoken_languages'].forEach((v) {
        _spokenLanguages.add(new SpokenLanguages.fromJson(v));
      });
    }
    _status = json['status'];
    _tagline = json['tagline'];
    _title = json['title'];
    _video = json['video'];
    _voteAverage = json['vote_average'];
    _voteCount = json['vote_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adult'] = this._adult;
    data['backdrop_path'] = this._backdropPath;
    data['budget'] = this._budget;
    if (this._genres != null) {
      data['genres'] = this._genres.map((v) => v.toJson()).toList();
    }
    data['id'] = this._id;
    data['imdb_id'] = this._imdbId;
    data['original_language'] = this._originalLanguage;
    data['original_title'] = this._originalTitle;
    data['overview'] = this._overview;
    data['popularity'] = this._popularity;
    data['poster_path'] = this._posterPath;
    if (this._productionCountries != null) {
      data['production_countries'] =
          this._productionCountries.map((v) => v.toJson()).toList();
    }
    data['release_date'] = this._releaseDate;
    data['revenue'] = this._revenue;
    data['runtime'] = this._runtime;
    if (this._spokenLanguages != null) {
      data['spoken_languages'] =
          this._spokenLanguages.map((v) => v.toJson()).toList();
    }
    data['status'] = this._status;
    data['tagline'] = this._tagline;
    data['title'] = this._title;
    data['video'] = this._video;
    data['vote_average'] = this._voteAverage;
    data['vote_count'] = this._voteCount;
    return data;
  }
}

class Genres {
  int _id;
  String _name;

  Genres({int id, String name}) {
    this._id = id;
    this._name = name;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get name => _name;
  set name(String name) => _name = name;

  Genres.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    return data;
  }
}

class ProductionCountries {
  String _iso31661;
  String _name;

  ProductionCountries({String iso31661, String name}) {
    this._iso31661 = iso31661;
    this._name = name;
  }

  String get iso31661 => _iso31661;
  set iso31661(String iso31661) => _iso31661 = iso31661;
  String get name => _name;
  set name(String name) => _name = name;

  ProductionCountries.fromJson(Map<String, dynamic> json) {
    _iso31661 = json['iso_3166_1'];
    _name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iso_3166_1'] = this._iso31661;
    data['name'] = this._name;
    return data;
  }
}

class SpokenLanguages {
  String _iso6391;
  String _name;

  SpokenLanguages({String iso6391, String name}) {
    this._iso6391 = iso6391;
    this._name = name;
  }

  String get iso6391 => _iso6391;
  set iso6391(String iso6391) => _iso6391 = iso6391;
  String get name => _name;
  set name(String name) => _name = name;

  SpokenLanguages.fromJson(Map<String, dynamic> json) {
    _iso6391 = json['iso_639_1'];
    _name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iso_639_1'] = this._iso6391;
    data['name'] = this._name;
    return data;
  }
}
