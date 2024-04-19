
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/models.dart';

class MoviesProvider extends ChangeNotifier
{

  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-ES'; 
  final String _apiKey = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhOWU5NzQ0ODRlOGRlYzYxOTQ4MDE5YmEyZDg1YTg1YyIsInN1YiI6IjYxNjAzM2Y4MzNlYzI2MDAyOGViNGZhNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.vz_sDOxuzFGfpFSjtY56Jwvdky2VyqFfJtApBmpVseA';

  List<Movie> onDisplayMovies = [];
  List<Movie> onPopularMovies = [];
  Map<int, List<Cast>> movieCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );

  final StreamController<List<Movie>> _suggestionStreamController = StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => _suggestionStreamController.stream;

  MoviesProvider(){
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> getJsonData( String endpoint, [int page = 1] ) async {
    final url = Uri.https(_baseUrl, endpoint,{
      'language': _language,
      'page': '$page',
    });

    final response = await http.get(
      url,
      headers:{
        HttpHeaders.authorizationHeader: _apiKey,
        'accept': 'application/json',
      }
    );

    return response.body;
  }

  getOnDisplayMovies() async {

    final nowPlayingResponse = NowPlayingResponse.fromRawJson(await getJsonData('3/discover/movie'));
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;
    final popularResponse = PopularResponse.fromRawJson(await getJsonData('3/movie/popular', _popularPage));
    onPopularMovies = [...onPopularMovies,...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    // Revisar el mapa
    if (movieCast.containsKey(movieId)){
      return movieCast[movieId]!;
    }
    
    final jsondata = await getJsonData('3/movie/$movieId/credits');
    final credistResponse = CreditsReponse.fromRawJson(jsondata);
    movieCast[movieId] = credistResponse.cast;
    return credistResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async{
    
    final url = Uri.https(_baseUrl, '3/search/movie',{
      'query': query,
      'language': _language
    });

    final response = await http.get(
      url,
      headers:{
        HttpHeaders.authorizationHeader: _apiKey,
        'accept': 'application/json',
      }
    );

    final searchMovieResp = SearchMovieResponse.fromRawJson(response.body);
    
    return searchMovieResp.results;

  }

  void getSuggestionsByQuery(String searchStream){
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final result = await searchMovies(value);
      _suggestionStreamController.add(result);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) { 
      debouncer.value = searchStream;
    });

    Future.delayed(const Duration(milliseconds:301)).then((_) => timer.cancel());
  }

}