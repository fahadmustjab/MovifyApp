import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie/screens/DescriptionScreen.dart';
import 'package:shimmer/shimmer.dart';

class ListMovies extends StatelessWidget {
  List movies;
  ListMovies({super.key, required this.movies});

  Future<List<dynamic>> getMyList() async {
    movies = movies.where((element) => element['poster_path'] != null).toList();
    return Future.value(movies);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: getMyList(),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            height: 170,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DescScreen(movieData: movie),
                                    ));
                              },
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    _buildProgressIndicator(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                movie['title'],
                                maxLines: 2,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  color: Colors.white,
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              movie['release_date'].toString().split('-')[0] +
                                  '    ',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 12,
                            ),
                            Text(
                              movie['vote_average'].toStringAsFixed(1),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return _buildProgressIndicator();
        }
      },
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        direction: ShimmerDirection.rtl,
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
}
