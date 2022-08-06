class MovieDetailsData {
  bool? adult;
  String? backdrop_path, original_title, overview, poster_path, release_date, title, homepage;
  int? id, vote_count;
  double? vote_average, popularity;
  List<MovieDetailsProductionData> genres = [], production_companies = [];

  MovieDetailsData.fromJson(Map? data) {
    adult = data?["adult"];
    backdrop_path = data?["backdrop_path"];
    original_title = data?["original_title"];
    overview = data?["overview"];
    poster_path = data?["poster_path"];
    release_date = data?["release_date"];
    title = data?["title"];
    id = data?["id"];
    vote_count = data?["vote_count"];
    vote_average = data?["vote_average"].toDouble();
    homepage = data?["homepage"];
    popularity = data?["popularity"].toDouble();
    List genreData = data?["genres"];
    genreData.forEach((item) {
      genres.add(MovieDetailsProductionData.fromJson(item));
    });
    List productionData = data?["genres"];
    productionData.forEach((item) {
      production_companies.add(MovieDetailsProductionData.fromJson(item));
    });
  }
}

class MovieDetailsProductionData {
  int? id;
  String? name, logo_path, origin_country;

  MovieDetailsProductionData.fromJson(Map data){
    id = data["id"];
    name = data["name"];
    logo_path = data["logo_path"];
    origin_country = data["origin_country"];
  }
}