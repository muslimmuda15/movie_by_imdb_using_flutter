import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:submission_movie_catalog/model/tv_details_model.dart';

import '../../service/movie_api.dart';
import '../../util/helper.dart';
import '../../util/logger.dart';

class TvDetails extends StatefulWidget {
  final int id;
  const TvDetails({super.key, required this.id});

  @override
  TvDetailsPage createState() => TvDetailsPage();
}

class TvDetailsPage extends State<TvDetails> {
  bool? loading;
  String? tvError;
  TvDetailsData? data;

  @override
  void initState() {
    super.initState();
    fetchDetailsTv();
  }

  @override
  Widget build(BuildContext context) {
    if (loading == null) {
      return const Scaffold(
        body: Center(
          child: SizedBox(
            height: 100,
            width: 100,
            child: LoadingIndicator(
              indicatorType: Indicator.audioEqualizer,
              colors: [Colors.red, Colors.yellow, Colors.green, Colors.blue],
              strokeWidth: 2,
            ),
          ),
        ),
      );
    } else if (loading == false) {
      return Scaffold(
        body: Center(
          child: SizedBox(
            child: Text(tvError ?? "Something went wrong"),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(data?.name ?? ""),
          backgroundColor: Colors.blue,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                /**
                   * Image banner
                   */
                Image.network(
                  MovieApi.imageUrl + (data?.backdrop_path ?? ""),
                  errorBuilder: (context, error, stackTrace) =>
                      Image.asset('images/no_image.png', fit: BoxFit.contain),
                ),
                Container(
                  margin: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          /**
                             * Image poster
                             */
                          Image.network(
                            MovieApi.imageUrl + (data?.poster_path ?? ""),
                            fit: BoxFit.cover,
                            width: 100,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                              'images/no_image.png',
                              fit: BoxFit.cover,
                              width: 100,
                            ),
                          ),
                          /**
                             * Title video, date, vote
                             */
                          Flexible(
                            fit: FlexFit.loose,
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Text(
                                      data?.name ?? "",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ), // Title
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Text(
                                      Prettifier.date(data?.first_air_date),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: RatingBarIndicator(
                                      itemSize: 16,
                                      rating: data?.vote_average ?? 0.0,
                                      itemBuilder: (context, index) =>
                                          const Icon(
                                        Icons.star,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Text(
                                        "${(data?.vote_count ?? 0)} votes"),
                                  ),
                                  if (data?.genres == null)
                                    Container()
                                  else
                                    SizedBox(
                                      height: 50,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: data?.genres.length ?? 0,
                                        itemBuilder:
                                            (BuildContext context, int index) =>
                                                Container(
                                          margin:
                                              const EdgeInsets.only(right: 4),
                                          child: Chip(
                                            label: Text(
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                ),
                                                data?.genres[index].name ?? ""),
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16, bottom: 8),
                        child: const Text(
                          "Storyline",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Text(data?.overview!.trim().isNotEmpty ?? false
                            ? data?.overview ?? "-"
                            : "-"),
                      ),
                      if ((data?.production_companies
                                  .where((item) => item.logo_path != null)
                                  .length ??
                              0) >
                          0)
                        Container(
                          margin: const EdgeInsets.only(top: 16, bottom: 16),
                          child: const Text(
                            "Production Companies",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      if (data?.production_companies.isNotEmpty ?? false)
                        SizedBox(
                          height: 100,
                          child: Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: data?.production_companies.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (data?.production_companies[index]
                                        .logo_path ==
                                    null) {
                                  return Container();
                                } else {
                                  return Card(
                                    semanticContainer: true,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Image.network(
                                      MovieApi.imageUrl +
                                          (data?.production_companies[index]
                                                  .logo_path ??
                                              ""),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Future fetchDetailsTv() async {
    MovieApi client = MovieApi();
    var response = await client.getTvDetails(id: widget.id);

    setState(() {
      try {
        if (response != null) {
          if (response.data != null) {
            data = TvDetailsData.fromJson(response.data);
            loading = true;
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
          tvError = "dio error : " + e.message;
          loading = false;
        } else {
          tvError = "unknow error : " + e.toString();
          loading = false;
        }
        Log.d("Error", e, stack);
      }
    });
  }
}
