import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:movie/components/TextStyles.dart';
import 'package:movie/screens/components/ListMovies.dart';
import 'package:movie/screens/Services/Services.dart';
import 'package:movie/screens/ShowMore.dart';
import 'package:movie/screens/components/SearchMovies.dart';
import 'package:movie/screens/testScreen.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen>
    with TickerProviderStateMixin {
  List nowPlayingMovies = [];
  List upcomingMovies = [];
  List topRatedMovies = [];
  List popularMovies = [];

  final apikey = 'b79147befe2e1a151fcdf55906684a94';
  Services services = Services();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchNowPlaying(
        'https://api.themoviedb.org/3/movie/now_playing?api_key=$apikey',
        'https://api.themoviedb.org/3/movie/upcoming?api_key=$apikey&page=2',
        'https://api.themoviedb.org/3/movie/top_rated?api_key=$apikey',
        'https://api.themoviedb.org/3/movie/popular?api_key=$apikey');
  }

  Future<void> fetchNowPlaying(
      now_url, upcoming_url, top_rated, popular_movies) async {
    final movies = await services.fetch(now_url);
    final upcoming = await services.fetch(upcoming_url);
    final top = await services.fetch(top_rated);
    final popular = await services.fetch(popular_movies);

    setState(() {
      nowPlayingMovies = movies;
      upcomingMovies = upcoming;
      topRatedMovies = top;
      popularMovies = popular;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TabController _tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: CustomScrollView(
        slivers: [
          CustomAppBar(
            searchController: searchController,
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Now Playing',
                  style: AppStyles.heading1,
                ),
                ShowMoreButton(
                  title: 'Now Playing',
                  categoryUrl: 'https://api.themoviedb.org/3/movie/now_playing',
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ListMovies(movies: nowPlayingMovies),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Upcoming',
                  style: AppStyles.heading1,
                ),
                ShowMoreButton(
                  title: 'Upcoming',
                  categoryUrl: 'https://api.themoviedb.org/3/movie/upcoming',
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ListMovies(movies: upcomingMovies),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Top Rated',
                  style: AppStyles.heading1,
                ),
                ShowMoreButton(
                  title: 'Top Rated',
                  categoryUrl: 'https://api.themoviedb.org/3/movie/top_rated',
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ListMovies(movies: topRatedMovies),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Popular',
                  style: AppStyles.heading1,
                ),
                ShowMoreButton(
                  title: 'Popular',
                  categoryUrl: 'https://api.themoviedb.org/3/movie/popular',
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ListMovies(movies: popularMovies)
          ]))
        ],
      ),
    );
  }
}

class ShowMoreButton extends StatelessWidget {
  final title;
  final categoryUrl;
  const ShowMoreButton({
    Key? key,
    required this.title,
    required this.categoryUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Get.to(() => ShowMore(
                title: title,
                categoryUrl: categoryUrl,
              ));
        },
        child: const Text(
          '+Show More',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ));
  }
}

class CustomAppBar extends StatefulWidget {
  final searchController;
  const CustomAppBar({
    Key? key,
    required this.searchController,
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  List<dynamic> searchedMovies = [];
  Services services = Services();

  Future<void> fetchSearchMovies(String query) async {
    final search = await services.searchMovies(query);
    setState(() {
      searchedMovies = search;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      centerTitle: true,
      expandedHeight: 100,
      title: Container(
        alignment: Alignment.center,
        child: TextField(
          // onTap: () {
          //   Navigator.push(context, MaterialPageRoute(
          //     builder: (context) {
          //       return Scaffold()
          //     },
          //   ));
          // },
          onSubmitted: (value) async {
            await fetchSearchMovies(value);
            // searchedMovies = searchedMovies
            //     .where((element) => element['poster_path'] != null)
            //     .toList();

            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchMovies(
                    movies: searchedMovies,
                  ),
                ));
          },
          controller: widget.searchController,
          textAlign: TextAlign.start,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.white, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(40),
            ),
            hintText: 'Search',
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
    );
  }
}
