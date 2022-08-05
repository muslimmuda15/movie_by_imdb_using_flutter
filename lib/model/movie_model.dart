class MovieData {
  bool? adult;
  String? backdrop_path, original_title, overview, poster_path, release_date, title;
  int? id, vote_count;
  double? vote_average;

  MovieData(
      this.adult,
      this.backdrop_path,
      this.original_title,
      this.overview,
      this.poster_path,
      this.release_date,
      this.title,
      this.id,
      this.vote_count,
      this.vote_average
  );

  MovieData.fromJson(Map data) {
    adult = data["adult"];
    backdrop_path = data["backdrop_path"];
    original_title = data["original_title"];
    overview = data["overview"];
    poster_path = data["poster_path"];
    release_date = data["release_date"];
    title = data["title"];
    id = data["id"];
    vote_count = data["vote_count"];
    vote_average = data["vote_average"].toDouble();
  }
}