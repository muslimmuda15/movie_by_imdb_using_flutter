import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:submission_movie_catalog/model/tv_details_model.dart';

import '../../service/movie_api.dart';
import '../../util/helper.dart';
import '../../util/logger.dart';

class TvDetails extends StatefulWidget {
  late int id;
  TvDetails(int id) {
    this.id = id;
  }

  TvDetailsPage createState() => TvDetailsPage(id);
}

class TvDetailsPage extends State<TvDetails> {
  late int id;
  bool? loading = null;
  String? TvError = null;
  TvDetailsData? data = null;

  TvDetailsPage(int id){
    this.id = id;
  }

  @override
  void initState() {
    super.initState();
    fetchDetailsTv();
  }

  @override
  Widget build(BuildContext context) {
    if (loading == null) {
      return Scaffold(
          body: Center(
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
          )
      );
    } else if (loading == false) {
      return Scaffold(
          body: Center(
              child: SizedBox(
                  child: Text(TvError ?? "Something went wrong")
              )
          )
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
                      MovieApi.imageUrl + (data?.backdrop_path ?? "")),
                  Container(
                    margin: EdgeInsets.all(16),
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
                                width: 100
                            ),
                            /**
                             * Title video, date, vote
                             */
                            Flexible(
                                fit: FlexFit.loose,
                                child:
                                Container(
                                    margin: EdgeInsets.only(
                                        left: 16, right: 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.only(bottom: 8),
                                            child: Text(
                                              data?.name ?? "",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            )
                                        ), // Title
                                        Padding(
                                            padding: EdgeInsets.only(bottom: 4),
                                            child: Text(Prettifier.date(
                                                data?.first_air_date))),
                                        Padding(
                                            padding: EdgeInsets.only(bottom: 4),
                                            child: RatingBarIndicator(
                                              itemSize: 16,
                                              rating: data?.vote_average ?? 0.0,
                                              itemBuilder: (context, index) =>
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.red,
                                                  ),
                                            )),
                                        Padding(
                                            padding: EdgeInsets.only(bottom: 8),
                                            child: Text("${(data?.vote_count ??
                                                0)} votes")),
                                        if(data?.genres == null)
                                          Container()
                                        else
                                          Container(
                                              height: 50,
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  scrollDirection: Axis
                                                      .horizontal,
                                                  itemCount: data?.genres
                                                      .length ?? 0,
                                                  itemBuilder: (
                                                      BuildContext context,
                                                      int index) =>
                                                      Container(
                                                          margin: EdgeInsets
                                                              .only(right: 4),
                                                          child: Chip(
                                                              label: Text(
                                                                  style: TextStyle(
                                                                    fontSize: 11,
                                                                  ),
                                                                  data
                                                                      ?.genres[index]
                                                                      .name ??
                                                                      "")
                                                          )
                                                      )
                                              )
                                          )
                                      ],
                                    )
                                )
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 16, bottom: 8),
                          child: Text("Storyline",
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 16),
                          child: Text(data?.overview ?? ""),
                        ),
                        if((data?.production_companies.where((item) => item.logo_path != null).length ?? 0) > 0)
                          Container(
                            margin: EdgeInsets.only(top: 16, bottom: 16),
                            child: Text("Production Companies",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),),
                          ),
                        Container(
                          height: 100,
                          child: Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: data?.genres.length,
                                itemBuilder: (BuildContext context,
                                    int index) {
                                  if (data?.production_companies[index].logo_path == null) {
                                    return Container();
                                  } else {
                                    return Card(
                                      semanticContainer: true,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: Image.network(
                                        MovieApi.imageUrl +
                                            (data?.production_companies[index]
                                                .logo_path ?? ""),
                                        fit: BoxFit.fill,
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              8.0)),
                                    );
                                  }
                                }
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
      );
    }
  }

  Future fetchDetailsTv() async {
    MovieApi client = new MovieApi();
    var response = await client.getTvDetails(id: id);

    setState(() {
      try {
        if (response != null) {
          if (response.data != null) {
            data = TvDetailsData.fromJson(response.data);
            loading = true;
          } else {
            TvError = "The response data is failed, try again!";
            loading = false;
          }
        } else {
          TvError = "The response is failed, try again!";
          loading = false;
        }
      } catch (e, stack) {
        if (e is DioError) {
          TvError = "dio error : " + e.message;
          loading = false;
        } else {
          TvError = "unknow error : " + e.toString();
          loading = false;
        }
        Log.d("Error", e, stack);
      }
    });
  }
}