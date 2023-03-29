import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie/screens/DescriptionScreen.dart';
import 'package:movie/screens/Services/Services.dart';
import 'package:shimmer/shimmer.dart';

class SearchMovies extends StatefulWidget {
  final movies;
  const SearchMovies({super.key, required this.movies});

  @override
  State<SearchMovies> createState() => _SearchMoviesState();
}

class _SearchMoviesState extends State<SearchMovies> {
  Services services = Services();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // widget.movies = widget.movies
    //     .where((element) => element['poster_path'] != null)
    //     .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      backgroundColor: Colors.indigo,
      body: FutureBuilder<List<dynamic>>(
          future: Future.value(widget.movies),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> cast = snapshot.data!
                  .where((element) => element['profile_path'] != null)
                  .toList();
              return GridView.builder(
                itemCount: widget.movies.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.5,
                ),
                itemBuilder: (context, index) {
                  if (index == widget.movies.length) {
                    return _buildProgressIndicator();
                  }

                  final movie = widget.movies[index];
                  return _buildMovieCard(movie);
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error:${snapshot.error}');
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildProgressIndicator();
            } else {
              return Container();
            }
          }),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildMovieCard(movie) {
    return SizedBox(
      height: 150,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DescScreen(movieData: movie),
                        ));
                  },
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return _buildProgressIndicator();
                    },
                    errorWidget: (context, url, error) {
                      return const Center(
                          child: Icon(
                        Icons.error,
                        size: 30,
                      ));
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              movie['title'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              movie['release_date'],
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
