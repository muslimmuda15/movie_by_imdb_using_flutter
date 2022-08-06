import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:submission_movie_catalog/movie/detail/movie_detail.dart';
import 'package:submission_movie_catalog/movie/movie_item.dart';

import '../model/movie_model.dart';
import '../service/movie_api.dart';
import '../util/logger.dart';

class MoviePage extends StatefulWidget {
  MoviePage({Key? key}) : super(key: key);

  MovieScenePage createState() => MovieScenePage();
}

class MovieScenePage extends State<MoviePage> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  List<MovieData> movieList = [];
  List<MovieData> movieListFiltered = [];
  String? movieError = null;
  late ScrollController controller;

  bool? loading = null;
  Icon searchIcon = new Icon(Icons.search);
  Widget appbarTitle = Text("Movie List");
  final TextEditingController filter = new TextEditingController();
  Timer? timer = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appbarTitle,
          backgroundColor: Colors.blue,
          actions: <Widget>[
            IconButton(
              onPressed: searchPressed,
              icon: searchIcon
            )
          ],
        ),
        body: buildMovie()
    );
  }

  @override
  void initState() {
    controller = ScrollController();
    controller.addListener(scrollListener);
    filter.addListener(() {
      timer?.cancel();
      if(filter.text.isEmpty){
        for(var i = 0; i < movieListFiltered.length; i++){
          listKey.currentState?.removeItem(0, (BuildContext context, Animation<double> animation) {
            return Container();
          });
        }
        movieListFiltered = movieList;
        for(var i = 0; i < movieList.length; i++){
          listKey.currentState?.insertItem(i);
        }
      } else {
        timer = Timer(const Duration(milliseconds: 500), () {
          setState(() {
            for(var i = 0; i < movieListFiltered.length; i++){
              listKey.currentState?.removeItem(0, (BuildContext context, Animation<double> animation) {
                return Container();
              });
            }
            movieListFiltered =
                movieList.where((movie) => (movie.title?.toLowerCase().contains(
                    filter.text) ?? false) ||
                    (movie.overview?.contains(filter.text) ?? false))
                    .toList();

            for(var i = 0; i < movieListFiltered.length; i++){
              listKey.currentState?.insertItem(i);
            }
          });
        });
      }
    });
    super.initState();
    fetchMovie();
  }

  Widget buildMovie() {
    if (loading == null) {
      return Center(
          child: SizedBox(
            child: LoadingIndicator(
              indicatorType: Indicator.audioEqualizer,
              colors: const [
                Colors.red,
                Colors.yellow,
                Colors.green,
                Colors.blue
              ],
              strokeWidth: 2,
            ),
            height: 100,
            width: 100,
          )
      );
    } else if (loading == false) {
      return Center(
          child: SizedBox(
              child: Text(movieError ?? "Something went wrong")
          )
      );
    } else {
      if(movieListFiltered.length > 0) {
        return AnimatedList(
            key: listKey,
            initialItemCount: movieListFiltered.length,
            controller: controller,
            itemBuilder: buildMovieItem
        );
      } else {
        return Center(
          child: Text("Nothing movie can be show here!"),
        );
      }
    }
  }

  Widget buildMovieItem(BuildContext context, int index, Animation<double> animation) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MovieDetails(movieListFiltered[index].id ?? 0))
          )
        },
        child: MovieItem(index: index, movieData: movieListFiltered[index])
    );
  }

  scrollListener() {
    if(controller.offset >= controller.position.maxScrollExtent && !controller.position.outOfRange){
      Log.d("REACH BOTTOM");
    }
  }

  searchPressed() {
    setState(() {
      if (searchIcon.icon == Icons.search) {
        searchIcon = new Icon(Icons.close);
        appbarTitle = new TextField(
          controller: filter,
          autofocus: true,
          decoration: new InputDecoration(
            prefixIcon: new Icon(Icons.search),
            hintText: "Search..."
          ),
        );
      } else {
        searchIcon = new Icon(Icons.search);
        appbarTitle = new Text("Movie List");
        filter.text = "";
      }
    });
  }

  Future fetchMovie() async {
    MovieApi client = new MovieApi();
    var response = await client.getMovieList(page: 1);

    setState(() {
      try {
        if (response != null) {
          if (response.data != null) {
            if (response.data!["results"] != null) {
              List list = response.data!["results"];
              if (list.length > 0) {
                loading = true;
                list.forEach((item) {
                  movieList.add(MovieData.fromJson(item));
                  movieListFiltered.add(MovieData.fromJson(item));
                });
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