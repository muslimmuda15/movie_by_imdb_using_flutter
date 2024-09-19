import 'package:dio/dio.dart';
import 'package:dio_logger/dio_logger.dart';

class MovieApi {
  static const String baseUrl = "https://api.themoviedb.org/3/";
  static const String key = "aaddea52a73aa3d1af17bbdd6ddb924d";
  static const String imageUrl = "https://image.tmdb.org/t/p/w400";
  var api = MovieApi.createApi();

  static Dio createApi() {
    var option = BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: 10000,
        receiveTimeout: 60000,
        contentType: "application/json;charset=utf-8",
        queryParameters: {"api_key": key});
    return Dio(option)..interceptors.add(dioLoggerInterceptor);
  }

  Future<Response<Map>?> getMovieList({required int page}) async {
    Response<Map>? response = await api.get("/discover/movie",
        queryParameters: {"language": "en-US", "page": page});
    return response;
  }

  Future<Response<Map>?> getTvList({required int page}) async {
    Response<Map>? response = await api.get("/tv/popular",
        queryParameters: {"language": "en-US", "page": page});
    return response;
  }

  Future<Response<Map>?> getMovieDetails({required int id}) async {
    Response<Map>? response =
        await api.get("/movie/$id", queryParameters: {"language": "en-US"});
    return response;
  }

  Future<Response<Map>?> getTvDetails({required int id}) async {
    Response<Map>? response =
        await api.get("/tv/$id", queryParameters: {"language": "en-US"});
    return response;
  }
}
