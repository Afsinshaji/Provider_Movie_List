import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:movie_app_provider/domain/core/api_end_points.dart';

import 'package:movie_app_provider/domain/core/failure/main_failure.dart';

import 'package:movie_app_provider/domain/movie_list/movie_list_model/movie_list_model.dart';

import '../../domain/movie_list/movie_list_model/result.dart';
import '../../domain/movie_list/movie_list_service.dart';

class MovieListImplementation extends MovieListService {
  final dio = Dio();
  // creating a singleton
  MovieListImplementation.internal();
  static MovieListImplementation instance = MovieListImplementation.internal();
  MovieListImplementation factory() {
    return instance;
  }

  //
  @override
  Future<Either<MainFailure, MovieListModel>> movieList(int num) async {
    if (num > 500) {
      return const Left(MainFailure.clientFailure());
    }
    try {
      const url = ApiEndPoints.getMovies;
      final response = await dio.get(url.replaceFirst('{pagenumber}', '$num'));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = MovieListModel.fromJson(response.data);
        return Right(result);
      } else {
        return const Left(MainFailure.serverFailure());
      }
    } catch (e) {
      log(e.toString());
      return const Left(MainFailure.clientFailure());
    }
  }
}

  List<Result> getData(Either<MainFailure, MovieListModel> data) {
    final List<Result> list = data.fold((l) => [], (r) => r.results ??= []);

    return list;
  }
