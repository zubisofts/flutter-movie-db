
class MovieDetails {
  bool adult;
  String backdropPath;
  dynamic budget;
  List<Genres> genres;
  int id;
  String imdbId;
  String originalLanguage;
  String originalTitle;
  String overview;
  dynamic popularity;
  String posterPath;
  List<ProductionCountries> productionCountries;
  String releaseDate;
  dynamic revenue;
  dynamic runtime;
  List<SpokenLanguages> spokenLanguages;
  String status;
  String tagline;
  String title;
  bool video;
  dynamic voteAverage;
  dynamic voteCount;
  String homepage;

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
      dynamic voteCount,
      String homepage}) {
    this.adult = adult;
    this.backdropPath = backdropPath;
    this.budget = budget;
    this.genres = genres;
    this.id = id;
    this.imdbId = imdbId;
    this.originalLanguage = originalLanguage;
    this.originalTitle = originalTitle;
    this.overview = overview;
    this.popularity = popularity;
    this.posterPath = posterPath;
    this.productionCountries = productionCountries;
    this.releaseDate = releaseDate;
    this.revenue = revenue;
    this.runtime = runtime;
    this.spokenLanguages = spokenLanguages;
    this.status = status;
    this.tagline = tagline;
    this.title = title;
    this.video = video;
    this.voteAverage = voteAverage;
    this.voteCount = voteCount;
    this.homepage=homepage;
  }
//
//  bool get adult => _adult;
//  set adult(bool adult) => _adult = adult;
//  String get backdropPath => _backdropPath;
//  set backdropPath(String backdropPath) => _backdropPath = backdropPath;
//  dynamic get budget => _budget;
//  set budget(dynamic budget) => _budget = budget;
//  List<Genres> get genres => _genres;
//  set genres(List<Genres> genres) => _genres = genres;
//  int get id => _id;
//  set id(int id) => _id = id;
//  String get imdbId => _imdbId;
//  set imdbId(String imdbId) => _imdbId = imdbId;
//  String get originalLanguage => _originalLanguage;
//  set originalLanguage(String originalLanguage) =>
//      _originalLanguage = originalLanguage;
//  String get originalTitle => _originalTitle;
//  set originalTitle(String originalTitle) => _originalTitle = originalTitle;
//  String get overview => _overview;
//  set overview(String overview) => _overview = overview;
//  double get popularity => _popularity;
//  set popularity(double popularity) => _popularity = popularity;
//  String get posterPath => _posterPath;
//  set posterPath(String posterPath) => _posterPath = posterPath;
//  List<ProductionCountries> get productionCountries => _productionCountries;
//  set productionCountries(List<ProductionCountries> productionCountries) =>
//      _productionCountries = productionCountries;
//  String get releaseDate => _releaseDate;
//  set releaseDate(String releaseDate) => _releaseDate = releaseDate;
//  dynamic get revenue => _revenue;
//  set revenue(dynamic revenue) => _revenue = revenue;
//  dynamic get runtime => _runtime;
//  set runtime(dynamic runtime) => _runtime = runtime;
//  List<SpokenLanguages> get spokenLanguages => _spokenLanguages;
//  set spokenLanguages(List<SpokenLanguages> spokenLanguages) =>
//      _spokenLanguages = spokenLanguages;
//  String get status => _status;
//  set status(String status) => _status = status;
//  String get tagline => _tagline;
//  set tagline(String tagline) => _tagline = tagline;
//  String get title => _title;
//  set title(String title) => _title = title;
//  bool get video => _video;
//  set video(bool video) => _video = video;
//  dynamic get voteAverage => _voteAverage;
//  set voteAverage(dynamic voteAverage) => _voteAverage = voteAverage;
//  dynamic get voteCount => _voteCount;
//  set voteCount(dynamic voteCount) => _voteCount = voteCount;
//  String get homepage => _homepage;
//  set homepage(String voteCount) => _homepage = homepage;

  MovieDetails.fromJson(Map<dynamic, dynamic> json) {
    adult = json['adult'];
    backdropPath = json['backdrop_path'];
    budget = json['budget'];
    if (json['genres'] != null) {
      genres = new List<Genres>();
      json['genres'].forEach((v) {
        genres.add(new Genres.fromJson(v));
      });
    }
    id = json['id'];
    imdbId = json['imdb_id'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    overview = json['overview'];
    popularity = json['popularity'];
    posterPath = json['poster_path'];
    if (json['production_countries'] != null) {
      productionCountries = new List<ProductionCountries>();
      json['production_countries'].forEach((v) {
        productionCountries.add(new ProductionCountries.fromJson(v));
      });
    }
    releaseDate = json['release_date'];
    revenue = json['revenue'];
    runtime = json['runtime'];
    if (json['spoken_languages'] != null) {
      spokenLanguages = new List<SpokenLanguages>();
      json['spoken_languages'].forEach((v) {
        spokenLanguages.add(new SpokenLanguages.fromJson(v));
      });
    }
    status = json['status'];
    tagline = json['tagline'];
    title = json['title'];
    video = json['video'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
    homepage = json['homepage'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adult'] = this.adult;
    data['backdrop_path'] = this.backdropPath;
    data['budget'] = this.budget;
    if (this.genres != null) {
      data['genres'] = this.genres.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    data['imdb_id'] = this.imdbId;
    data['original_language'] = this.originalLanguage;
    data['original_title'] = this.originalTitle;
    data['overview'] = this.overview;
    data['popularity'] = this.popularity;
    data['poster_path'] = this.posterPath;
    if (this.productionCountries != null) {
      data['production_countries'] =
          this.productionCountries.map((v) => v.toJson()).toList();
    }
    data['release_date'] = this.releaseDate;
    data['revenue'] = this.revenue;
    data['runtime'] = this.runtime;
    if (this.spokenLanguages != null) {
      data['spoken_languages'] =
          this.spokenLanguages.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['tagline'] = this.tagline;
    data['title'] = this.title;
    data['video'] = this.video;
    data['vote_average'] = this.voteAverage;
    data['vote_count'] = this.voteCount;
    data['homepage'] = this.homepage;
    return data;
  }
}

class Genres {
  int id;
  String name;

  Genres({int id, String name}) {
    this.id = id;
    this.name = name;
  }
//
//  int get id => id;
//  set id(int id) => id = id;
//  String get name => _name;
//  set name(String name) => _name = name;

  Genres.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class ProductionCountries {
  String iso31661;
  String name;

  ProductionCountries({String iso31661, String name}) {
    this.iso31661 = iso31661;
    this.name = name;
  }

//  String get iso31661 => _iso31661;
//  set iso31661(String iso31661) => _iso31661 = iso31661;
//  String get name => _name;
//  set name(String name) => _name = name;

  ProductionCountries.fromJson(Map<dynamic, dynamic> json) {
    iso31661 = json['iso_3166_1'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<String, dynamic>();
    data['iso_3166_1'] = this.iso31661;
    data['name'] = this.name;
    return data;
  }
}

class SpokenLanguages {
  String iso6391;
  String name;

  SpokenLanguages({String iso6391, String name}) {
    this.iso6391 = iso6391;
    this.name = name;
  }

//  String get iso6391 => _iso6391;
//  set iso6391(String iso6391) => _iso6391 = iso6391;
//  String get name => _name;
//  set name(String name) => _name = name;

  SpokenLanguages.fromJson(Map<dynamic, dynamic> json) {
    iso6391 = json['iso_639_1'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iso_639_1'] = this.iso6391;
    data['name'] = this.name;
    return data;
  }
}
