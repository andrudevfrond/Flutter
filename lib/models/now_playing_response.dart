import 'dart:convert';

import 'package:peliculas/models/models.dart';

class NowPlayingResponse {
    int page;
    List<Movie> results;
    int totalPages;
    int totalResults;

    NowPlayingResponse({
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    factory NowPlayingResponse.fromRawJson(String str) => NowPlayingResponse.fromJson(json.decode(str));

    //String toRawJson() => json.encode(toJson());

    factory NowPlayingResponse.fromJson(Map<String, dynamic> json) => NowPlayingResponse(
        page         : json["page"],
        results      : List<Movie>.from(json["results"].map((x) => Movie.fromJson(x))),
        totalPages   : json["total_pages"],
        totalResults : json["total_results"],
    );
}