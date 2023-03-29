import 'dart:convert';

import 'package:dart_sentiment/dart_sentiment.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:movie/components/TextStyles.dart';
import 'package:movie/screens/components/ListMovies.dart';
import 'package:movie/screens/Services/Services.dart';
import 'package:movie/screens/components/ListCast.dart';
import 'package:readmore/readmore.dart';

class DescScreen extends StatefulWidget {
  dynamic movieData;
  DescScreen({super.key, required this.movieData});

  @override
  State<DescScreen> createState() => _DescScreenState();
}

class _DescScreenState extends State<DescScreen> {
  Services services = Services();
  List<String> genres = [];
  List<dynamic> similarMovies = [];
  final sentiment = Sentiment();
  List positiveReviews = <String>[];
  List negativeReviews = <String>[];

  @override
  void initState() {
    super.initState();
    getData(widget.movieData['id']);
  }

  void getData(int movieId) async {
    final data = await services.fetchGenres(movieId);
    final similar = await services.getSimilarMovies(movieId);
    fetchReviews(movieId);

    setState(() {
      genres = data;
      similarMovies = similar;
    });
  }

  Future<void> fetchReviews(int movieId) async {
    final apikey = 'b79147befe2e1a151fcdf55906684a94';
    final url =
        'https://api.themoviedb.org/3/movie/$movieId/reviews?api_key=$apikey';
    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['results'];
      final reviews = data.map((review) => review['content']).toList();
      final postive = <String>[];
      final negative = <String>[];

      for (final review in reviews) {
        final sentimentResult = sentiment.analysis(review);
        if (sentimentResult['comparative'] > 0) {
          postive.add(review);
        } else {
          negative.add(review);
        }

        setState(() {
          positiveReviews = postive;
          negativeReviews = negative;
        });
      }
      print("Positive Reviews ${positiveReviews.toList()}");
      print(negativeReviews.toList());
    } else {
      throw Exception('Error Fetching Reviews');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 400.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://image.tmdb.org/t/p/w500${widget.movieData['poster_path']}?h=250'),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter)),
            ),
            Center(
              child: Text(
                widget.movieData['title'].toString(),
                style: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                Text(
                  widget.movieData['release_date'],
                  style: GoogleFonts.lato(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                Text(
                  widget.movieData['vote_average'].toString(),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Icon(Icons.save_as),
                )
              ],
            ),
            const Text(
              'Description',
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, bottom: 10, right: 5),
              child: ReadMoreText(
                widget.movieData['overview'].toString(),
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                trimLines: 2,
                colorClickableText: Colors.red,
                trimMode: TrimMode.Line,
                trimCollapsedText: 'Show more',
                trimExpandedText: 'Show less',
                moreStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            const Text(
              'Genres',
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: genres.length,
                itemBuilder: (context, index) {
                  final genre = genres[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 100,
                          height: 50,
                          child: Center(child: Text(genre.toString())),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Cast',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListCast(movieId: widget.movieData['id']),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Similar Movies',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListMovies(movies: similarMovies),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Top Positive Reviews',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: positiveReviews.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.person),
                          title: Text('Username'),
                          subtitle: Text(
                            positiveReviews[index].toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Top Negative Reviews',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: negativeReviews.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Card(
                        elevation: 4.0,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: ListTile(
                            title: Text('Username'),
                            subtitle: Text(
                              negativeReviews[index].toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                            leading: Icon(Icons.person)),
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
