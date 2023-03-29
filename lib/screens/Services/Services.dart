import 'dart:convert';

import 'package:dart_sentiment/dart_sentiment.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class Services {
  final apikey = 'b79147befe2e1a151fcdf55906684a94';

  Future<List<dynamic>> getSimilarMovies(int movieId) async {
    final response = await get(Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId/similar?api_key=$apikey'));
    print(response.body.toString());
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List<dynamic>;
      return results;
    } else {
      throw Exception('Error');
    }
  }

  Future<List> fetch(url) async {
    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to fetch Movies. Really sorry');
    }
  }

  Future<List> searchMovies(String query) async {
    final response = await get(Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=$apikey&query=$query'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to fetch Movies. Really sorry');
    }
  }

  Future<List> fetchNowPlayingMoviesPage(int pageNo) async {
    final url =
        'https://api.themoviedb.org/3/movie/now_playing?api_key=$apikey&page=$pageNo';
    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to fetch Movies. Really sorry');
    }
  }

  Future<List> fetchMoviesPages(int pageNo, String categoryUrl) async {
    final url = '$categoryUrl?api_key=$apikey&page=$pageNo';
    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to fetch Movies. Really sorry');
    }
  }

  Future<List<String>> fetchGenres(int movieId) async {
    final String movieUrl =
        'https://api.themoviedb.org/3/movie/$movieId?api_key=$apikey';
    final response = await get(Uri.parse(movieUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final genres = data['genres'] as List<dynamic>;
      return genres.map((e) => e['name'].toString()).toList();
    } else {
      throw Exception('Failed to Load Movie Genre');
    }
  }

  Future<List<dynamic>> getMovieCast(int movieId) async {
    final url =
        'https://api.themoviedb.org/3/movie/$movieId/credits?api_key=$apikey';
    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['cast'];
    } else {
      throw Exception('Unable');
    }
  }
}
