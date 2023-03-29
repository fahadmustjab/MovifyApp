import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie/screens/DescriptionScreen.dart';
import 'package:movie/screens/Services/Services.dart';
import 'package:shimmer/shimmer.dart';

class ShowMore extends StatefulWidget {
  final title;
  final categoryUrl;
  const ShowMore({super.key, required this.title, required this.categoryUrl});

  @override
  State<ShowMore> createState() => _ShowMoreState();
}

class _ShowMoreState extends State<ShowMore> {
  List<dynamic> movies = [];
  bool isLoading = false;
  int current_page = 1;
  final int items = 20;
  final ScrollController _scrollController = ScrollController();
  Services services = Services();

  @override
  void initState() {
    super.initState();
    _getMovies();

    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      backgroundColor: Colors.indigo,
      body: GridView.builder(
        controller: _scrollController,
        itemCount: movies.length + 1,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.5,
        ),
        itemBuilder: (context, index) {
          if (index == movies.length) {
            return _buildProgressIndicator();
          }
          movies = movies
              .where((element) => element['poster_path'] != null)
              .toList();
          final movie = movies[index];
          return _buildMovieCard(movie);
        },
      ),
    );
  }

  void _getMovies() async {
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    final result =
        await services.fetchMoviesPages(current_page, widget.categoryUrl);
    print(current_page.toString());

    setState(() {
      isLoading = false;
      movies.addAll(result);
      current_page++;
    });
  }

  void _onScroll() {
    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.position.pixels;
    final double delta = MediaQuery.of(context).size.height * 0.25;
    if (maxScroll - currentScroll <= delta) {
      _getMovies();
    }
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
                    Get.to(() => DescScreen(movieData: movie));
                  },
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, _, __) {
                      return const Icon(Icons.error);
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
