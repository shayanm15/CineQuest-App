import 'dart:convert';
import 'dart:async';
import 'package:cinequest/constants.dart';
import 'package:cinequest/movie.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MovieModel extends ChangeNotifier{
  static const trending_movie_URL = 'https://api.themoviedb.org/3/trending/movie/day?api_key=${Constants.API_key}';
  static const top_rated_movie_URL = 'https://api.themoviedb.org/3/movie/top_rated?api_key=${Constants.API_key}';
  static const upcoming_movie_URL = 'https://api.themoviedb.org/3/movie/upcoming?api_key=${Constants.API_key}';
  // static const upcoming_movie_URL = 'https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc&with_release_type=2|3&release_date.gte={min_date}&release_date.lte={max_date}&api_key=${Constants.API_key}';
  static const now_playing_movie_URL = 'https://api.themoviedb.org/3/movie/now_playing?api_key=${Constants.API_key}';
  // static const now_playing_movie_URL = 'https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc&with_release_type=2|3&release_date.gte={min_date}&release_date.lte={max_date}&api_key=${Constants.API_key}';

  List<Movie> all_trending_movies = [];
  List<Movie> get get_all_trending_movies => all_trending_movies;
  bool trending_movies_loaded = true;
  bool get get_trending_movies_loaded=> trending_movies_loaded;

  List<Movie> all_top_rated_movies = [];
  List<Movie> get get_all_top_rated_movies => all_top_rated_movies;
  bool top_rated_movies_loaded = true;
  bool get get_top_rated_movies_loaded=> top_rated_movies_loaded;

  List<Movie> all_upcoming_movies = [];
  List<Movie> get get_all_upcoming_movies => all_upcoming_movies;
  bool upcoming_movies_loaded = true;
  bool get get_upcoming_movies_loaded=> upcoming_movies_loaded;

  List<Movie> all_now_playing_movies = [];
  List<Movie> get get_all_now_playing_movies => all_now_playing_movies;
  bool now_playing_movies_loaded = true;
  bool get get_now_playing_movies_loaded => now_playing_movies_loaded;

  List<Movie> savedMovies = [];

  //saving movies
// Modify the toggleFavorite method to accept BuildContext

void toggleFavorite(BuildContext context, Movie movie) {
  movie.isFavorite = !movie.isFavorite;
  String message;
  if (movie.isFavorite) {
    savedMovies.add(movie);
    message = 'Movie Saved';
  } else {
    savedMovies.removeWhere((savedMovie) => savedMovie.id == movie.id);
    message = 'Movie Removed';
  }
  notifyListeners();

  // Show the AlertDialog with larger font size
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        content: Text(
          message,
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20), 
          textAlign: TextAlign.center, // Customize the font size here
        ),
      );
    },
  );

  // Close the AlertDialog after 2 seconds
  Timer(Duration(seconds: 2), () {
    Navigator.of(context, rootNavigator: true).pop('dialog');
  });
}

  MovieModel() {
    get_trending_movies();
    get_top_rated_movies();
    get_upcoming_movies();
    get_now_playing_movies();

  }

  void  get_trending_movies() async {
    final response = await http.get(Uri.parse(trending_movie_URL));
    if (response.statusCode == 200) {
      trending_movies_loaded = false;
      notifyListeners();

      var moviesJSON = jsonDecode(response.body)['results'] as List;
      all_trending_movies = moviesJSON.map((movie) => Movie.fromJson(movie)).toList();
      await Future.delayed(Duration(seconds: 5)); 

      trending_movies_loaded = true;
      notifyListeners();
    } else {
      trending_movies_loaded = false;
      notifyListeners();
      throw Exception('Something happended');
      
    }
  }

  void get_top_rated_movies() async {
    final response = await http.get(Uri.parse(top_rated_movie_URL));
    if (response.statusCode == 200) {
      top_rated_movies_loaded = false;
      notifyListeners();

      var moviesJSON = jsonDecode(response.body)['results'] as List;
      all_top_rated_movies = moviesJSON.map((movie) => Movie.fromJson(movie)).toList();
      await Future.delayed(Duration(seconds: 5)); 

      top_rated_movies_loaded = true;
      notifyListeners();
    } else {
      top_rated_movies_loaded = false;
      notifyListeners();
      throw Exception('Something happended');
      
    }
  }

  void get_upcoming_movies() async {
    final response = await http.get(Uri.parse(upcoming_movie_URL));
    if (response.statusCode == 200) {
      upcoming_movies_loaded = false;
      notifyListeners();

      var moviesJSON = jsonDecode(response.body)['results'] as List;
      all_upcoming_movies = moviesJSON.map((movie) => Movie.fromJson(movie)).toList();
      await Future.delayed(Duration(seconds: 5)); 

      upcoming_movies_loaded = true;
      notifyListeners();
    } else {
      upcoming_movies_loaded = false;
      notifyListeners();
      throw Exception('Something happended');
      
    }
  }

  void get_now_playing_movies() async {
    final response = await http.get(Uri.parse(now_playing_movie_URL));
    if (response.statusCode == 200) {
      now_playing_movies_loaded = false;
      notifyListeners();

      var moviesJSON = jsonDecode(response.body)['results'] as List;
      all_now_playing_movies = moviesJSON.map((movie) => Movie.fromJson(movie)).toList();
      await Future.delayed(Duration(seconds: 5)); 

      now_playing_movies_loaded = true;
      notifyListeners();
    } else {
      now_playing_movies_loaded = false;
      notifyListeners();
      throw Exception('Something happended');
      
    }
  }
}