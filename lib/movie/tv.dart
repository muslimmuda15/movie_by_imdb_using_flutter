import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:submission_movie_catalog/movie/detail/tv_detail.dart';
import 'package:submission_movie_catalog/movie/tv_item.dart';
import 'package:submission_movie_catalog/service/movie_api.dart';

import '../model/tv_model.dart';
import '../util/logger.dart';

class TvPage extends StatefulWidget {
  const TvPage({super.key});

  @override
  TvScenePage createState() => TvScenePage();
}

class TvScenePage extends State<TvPage> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  List<TvData> tvList = [];
  List<TvData> tvListFiltered = [];
  String? tvError;
  late ScrollController controller;

  bool? loading;
  Icon searchIcon = const Icon(Icons.search);
  Widget appbarTitle = const Text("Tv List");
  final TextEditingController filter = TextEditingController();
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appbarTitle,
          backgroundColor: Colors.blue,
          actions: <Widget>[
            IconButton(onPressed: () => searchPressed(), icon: searchIcon)
          ],
        ),
        body: buildTv());
  }

  @override
  void initState() {
    controller = ScrollController();
    controller.addListener(scrollListener);
    filter.addListener(() {
      timer?.cancel();
      if (filter.text.isEmpty) {
        for (var i = 0; i < tvListFiltered.length; i++) {
          listKey.currentState?.removeItem(0,
              (BuildContext context, Animation<double> animation) {
            return Container();
          });
        }
        tvListFiltered = tvList;
        for (var i = 0; i < tvList.length; i++) {
          listKey.currentState?.insertItem(i);
        }
      } else {
        timer = Timer(const Duration(milliseconds: 500), () {
          setState(() {
            for (var i = 0; i < tvListFiltered.length; i++) {
              listKey.currentState?.removeItem(0,
                  (BuildContext context, Animation<double> animation) {
                return Container();
              });
            }
            tvListFiltered = tvList
                .where((tv) =>
                    (tv.name?.toLowerCase().contains(filter.text) ?? false) ||
                    (tv.overview?.contains(filter.text) ?? false))
                .toList();

            for (var i = 0; i < tvListFiltered.length; i++) {
              listKey.currentState?.insertItem(i);
            }
          });
        });
      }
    });
    super.initState();
    fetchTv();
  }

  Widget buildTv() {
    if (loading == null) {
      return const Center(
        child: SizedBox(
          height: 100,
          width: 100,
          child: LoadingIndicator(
            indicatorType: Indicator.audioEqualizer,
            colors: [Colors.red, Colors.yellow, Colors.green, Colors.blue],
            strokeWidth: 2,
          ),
        ),
      );
    } else if (loading == false) {
      return Center(
          child: SizedBox(child: Text(tvError ?? "Something went wrong")));
    } else {
      if (tvListFiltered.isNotEmpty) {
        return AnimatedList(
            key: listKey,
            initialItemCount: tvListFiltered.length,
            controller: controller,
            itemBuilder: buildTvItem);
      } else {
        return const Center(
          child: Text("Nothing tv can be show here!"),
        );
      }
    }
  }

  Widget buildTvItem(
      BuildContext context, int index, Animation<double> animation) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TvDetails(id: tvListFiltered[index].id ?? 0)))
            },
        child: TvItem(index: index, tvData: tvListFiltered[index]));
  }

  scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      Log.d("REACH BOTTOM");
    }
  }

  searchPressed() {
    setState(() {
      if (searchIcon.icon == Icons.search) {
        searchIcon = const Icon(Icons.close);
        appbarTitle = TextField(
          controller: filter,
          autofocus: true,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search), hintText: "Search..."),
        );
      } else {
        searchIcon = const Icon(Icons.search);
        appbarTitle = const Text("Tv List");
        filter.text = "";
      }
    });
  }

  Future fetchTv() async {
    MovieApi client = MovieApi();
    var response = await client.getTvList(page: 1);

    setState(() {
      try {
        if (response != null) {
          if (response.data != null) {
            if (response.data!["results"] != null) {
              List list = response.data!["results"];
              if (list.isNotEmpty) {
                loading = true;
                for (var item in list) {
                  tvList.add(TvData.fromJson(item));
                  tvListFiltered.add(TvData.fromJson(item));
                }
              } else {
                loading = false;
                tvError = "You have no data";
                return;
              }
            } else {
              tvError = "Cannot find result data";
              loading = false;
            }
          } else {
            tvError = "The response data is failed, try again!";
            loading = false;
          }
        } else {
          tvError = "The response is failed, try again!";
          loading = false;
        }
      } catch (e, stack) {
        if (e is DioError) {
          tvError = "dio error : ${e.message}";
          loading = false;
        } else {
          tvError = "unknow error : $e";
          loading = false;
        }
        Log.d("Error", e, stack);
      }
    });
  }
}
