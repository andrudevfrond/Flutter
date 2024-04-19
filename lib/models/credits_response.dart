

import 'dart:convert';

class CreditsReponse {
    int id;
    List<Cast> cast;
    List<Cast> crew;

    CreditsReponse({
        required this.id,
        required this.cast,
        required this.crew,
    });

    factory CreditsReponse.fromRawJson(String str) => CreditsReponse.fromJson(json.decode(str));

    factory CreditsReponse.fromJson(Map<String, dynamic> json) => CreditsReponse(
        id: json["id"],
        cast: List<Cast>.from(json["cast"].map((x) => Cast.fromJson(x))),
        crew: List<Cast>.from(json["crew"].map((x) => Cast.fromJson(x))),
    );
}

class Cast {
    bool adult;
    int gender;
    int id;
    String knownForDepartment;
    String name;
    String originalName;
    double popularity;
    String? profilePath;
    int? castId;
    String? character;
    String creditId;
    int? order;
    String? department;
    String? job;

    get fullProfrilePath {
      if (profilePath != null) {
        return 'https://image.tmdb.org/t/p/w500${profilePath}';
      } else {
        return 'https://st4.depositphotos.com/14953852/24787/v/600/depositphotos_247872612-stock-illustration-no-image-available-icon-vector.jpg';
      } 
    }

    Cast({
        required this.adult,
        required this.gender,
        required this.id,
        required this.knownForDepartment,
        required this.name,
        required this.originalName,
        required this.popularity,
        this.profilePath,
        this.castId,
        this.character,
        required this.creditId,
        this.order,
        this.department,
        this.job,
    });

    factory Cast.fromRawJson(String str) => Cast.fromJson(json.decode(str));

    factory Cast.fromJson(Map<String, dynamic> json) => Cast(
        adult: json["adult"],
        gender: json["gender"],
        id: json["id"],
        knownForDepartment: json["known_for_department"]!,
        name: json["name"],
        originalName: json["original_name"],
        popularity: json["popularity"]?.toDouble(),
        profilePath: json["profile_path"] ?? json["profile_path"],
        castId: json["cast_id"],
        character: json["character"] ?? json["character"],
        creditId: json["credit_id"] ?? json["credit_id"],
        order: json["order"] ?? json["order"],
        department: json["department"] ?? json["department"],
        job: json["job"] ?? json["job"],
    );    
}




