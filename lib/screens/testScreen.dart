import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Movie {
  final int id;
  final String title;
  final String posterPath;

  Movie({required this.id, required this.title, required this.posterPath});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        id: json['id'], title: json['title'], posterPath: json['poster_path']);
  }
}

class TmdbApi {
  final String _apiKey = 'b79147befe2e1a151fcdf55906684a94i';

  Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=$_apiKey&query=$query'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> movies = json['results'];
      return movies.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }
}

class MovieSearchScreen extends StatefulWidget {
  @override
  _MovieSearchScreenState createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  final TmdbApi _tmdbApi = TmdbApi();
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _movies = [];

  void _searchMovies(String query) async {
    final movies = await _tmdbApi.searchMovies(query);
    setState(() {
      _movies = movies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search movies',
          ),
          onChanged: (query) {
            _searchMovies(query);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: _movies.length,
        itemBuilder: (context, index) {
          final movie = _movies[index];
          return ListTile(
            leading: Image.network(
                'https://image.tmdb.org/t/p/w92/${movie.posterPath}'),
            title: Text(movie.title),
          );
        },
      ),
    );
  }
}
