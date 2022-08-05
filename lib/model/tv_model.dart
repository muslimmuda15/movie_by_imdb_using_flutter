class TvData {
  String? backdrop_path, original_name, overview, poster_path, first_air_date, name;
  int? id, vote_count;
  double? vote_average;

  TvData(
      this.backdrop_path,
      this.original_name,
      this.overview,
      this.poster_path,
      this.first_air_date,
      this.name,
      this.id,
      this.vote_count,
      this.vote_average
  );

  TvData.fromJson(Map data) {
    backdrop_path = data["backdrop_path"];
    original_name = data["original_name"];
    overview = data["overview"];
    poster_path = data["poster_path"];
    first_air_date = data["first_air_date"];
    name = data["name"];
    id = data["id"];
    vote_count = data["vote_count"];
    vote_average = data["vote_average"].toDouble();
  }
}