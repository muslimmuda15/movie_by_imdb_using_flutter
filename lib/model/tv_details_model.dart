class TvDetailsData {
  String? backdrop_path, original_name, overview, poster_path, first_air_date, name, homepage;
  int? id, vote_count, number_of_episodes, number_of_seasons;
  double? vote_average, popularity;
  List<TvDetailsProductionData> genres = [], created_by = [], production_companies = [], seasons = [];

  TvDetailsData.fromJson(Map? data) {
    backdrop_path = data?["backdrop_path"];
    original_name = data?["original_name"];
    overview = data?["overview"];
    poster_path = data?["poster_path"];
    first_air_date = data?["first_air_date"];
    name = data?["name"];
    id = data?["id"];
    vote_count = data?["vote_count"];
    vote_average = data?["vote_average"].toDouble();
    homepage = data?["homepage"];
    number_of_episodes = data?["number_of_episodes"];
    number_of_seasons = data?["number_of_seasons"];
    popularity = data?["popularity"];
    List genreData = data?["genres"];
    genreData.forEach((item) {
      genres.add(TvDetailsProductionData.fromJson(item));
    });
    List createdData = data?["created_by"];
    createdData.forEach((item) {
      created_by.add(TvDetailsProductionData.fromJson(item));
    });
    List productionData = data?["production_companies"];
    productionData.forEach((item) {
      production_companies.add(TvDetailsProductionData.fromJson(item));
    });
    List seasonsData = data?["seasons"];
    seasonsData.forEach((item) {
      seasons.add(TvDetailsProductionData.fromJson(item));
    });
  }
}

class TvDetailsProductionData {
  int? id, episode_count, season_number;
  String? name, profile_path, origin_country, logo_path, air_date, overview, poster_path;

  TvDetailsProductionData.fromJson(Map data){
    id = data["id"];
    name = data["name"];
    profile_path = data["logo_path"];
    logo_path = data["logo_path"];
    poster_path = data["poster_path"];
    overview = data["overview"];
    air_date = data["air_date"];
    episode_count = data["episode_count"];
    origin_country = data["origin_country"];
    season_number = data["season_number"];
  }
}