import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:submission_movie_catalog/model/movie_model.dart';

import '../service/movie_api.dart';

class MovieItem extends StatelessWidget {
  late int index;
  late MovieData movieData;
  MovieItem({Key? key, required int index, required MovieData movieData}){
    this.index = index;
    this.movieData = movieData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
            left: 16, right: 16, bottom: 8, top: index == 0 ? 16 : 0),
        child:
        Center(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => {},
              child: Card(
                semanticContainer: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: new ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Image.network(
                        MovieApi.imageUrl +
                            (movieData.backdrop_path ?? ""),
                        fit: BoxFit.cover,
                        height: 150,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text(
                          movieData.title ?? "",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        subtitle: Text(
                          movieData.overview ?? "",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
        )
    );
  }
}