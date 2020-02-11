class PersonImages {
  List<Profiles> profiles;
  int id;

  PersonImages({this.profiles, this.id});

  PersonImages.fromJson(Map<String, dynamic> json) {
    if (json['profiles'] != null) {
      profiles = new List<Profiles>();
      json['profiles'].forEach((v) {
        profiles.add(new Profiles.fromJson(v));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.profiles != null) {
      data['profiles'] = this.profiles.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    return data;
  }
}

class Profiles {
  dynamic width;
  dynamic height;
  dynamic voteCount;
  dynamic voteAverage;
  dynamic filePath;
  dynamic aspectRatio;

  Profiles(
      {this.width,
      this.height,
      this.voteCount,
      this.voteAverage,
      this.filePath,
      this.aspectRatio});

  Profiles.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    height = json['height'];
    voteCount = json['vote_count'];
    voteAverage = json['vote_average'];
    filePath = json['file_path'];
    aspectRatio = json['aspect_ratio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['width'] = this.width;
    data['height'] = this.height;
    data['vote_count'] = this.voteCount;
    data['vote_average'] = this.voteAverage;
    data['file_path'] = this.filePath;
    data['aspect_ratio'] = this.aspectRatio;
    return data;
  }
}
