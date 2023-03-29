import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie/screens/Services/Services.dart';
import 'package:shimmer/shimmer.dart';

class ListCast extends StatelessWidget {
  final movieId;
  const ListCast({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    Services services = Services();
    return FutureBuilder<List<dynamic>>(
      future: services.getMovieCast(movieId),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          List<dynamic> cast = snapshot.data!
              .where((element) => element['profile_path'] != null)
              .toList();
          return SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cast.length,
              itemBuilder: (context, index) {
                final actor = cast[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://image.tmdb.org/t/p/w200${actor['profile_path']}',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  _buildProgressIndicator(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          actor['name'] ?? '',
                          style: TextStyle(color: Colors.white),
                        ),
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
