import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/tv_model.dart';
import '../service/movie_api.dart';

class TvItem extends StatelessWidget {
  late int index;
  late TvData tvData;
  TvItem({Key? key, required int index, required TvData tvData}){
    this.index = index;
    this.tvData = tvData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
            left: 16, right: 16, bottom: 8, top: index == 0 ? 16 : 0),
        child:
        Center(
          child: Card(
            semanticContainer: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child:
            new ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.network(
                    MovieApi.imageUrl + (tvData.backdrop_path ?? ""),
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
                      tvData.name ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    subtitle: Text(
                      tvData.overview ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}