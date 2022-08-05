import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:submission_movie_catalog/movie/movie.dart';

import '../../service/movie_api.dart';
import '../../util/logger.dart';

class MovieDetails extends StatefulWidget {
  late int id;
  MovieDetails(int id) {
    this.id = id;
  }

  MovieDetailsPage createState() => MovieDetailsPage(id);
}

class MovieDetailsPage extends State<MovieDetails> {
  late int id;
  bool? loading = null;
  String? movieError = null;

  MovieDetailsPage(int id){
    this.id = id;
  }

  @override
  void initState() {
    super.initState();
    fetchDetailsMovie();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future fetchDetailsMovie() async {
    MovieApi client = new MovieApi();
    var response = await client.getMovieDetails(id: id);

    setState(() {
      try {
        if (response != null) {
          if (response.data != null) {
            if (response.data!["results"] != null) {
              List list = response.data!["results"];
              if (list.length > 0) {
                loading = true;

              } else {
                loading = false;
                movieError = "You have no data";
                return;
              }
            } else {
              movieError = "Cannot find result data";
              loading = false;
            }
          } else {
            movieError = "The response data is failed, try again!";
            loading = false;
          }
        } else {
          movieError = "The response is failed, try again!";
          loading = false;
        }
      } catch (e, stack) {
        if (e is DioError) {
          movieError = "dio error : " + e.message;
          loading = false;
        } else {
          movieError = "unknow error : " + e.toString();
          loading = false;
        }
        Log.d("Error", e, stack);
      }
    });
  }
}