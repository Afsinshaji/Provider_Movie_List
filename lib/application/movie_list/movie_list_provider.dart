import 'package:flutter/material.dart';
import 'package:movie_app_provider/application/movie_list/provider_response.dart';
import 'package:movie_app_provider/infrastructure/movie_list/movie_list_implementation.dart';

class MovieListProvider extends ChangeNotifier {
  ProviderResponse resultData = ProviderResponse(
    resultingData: [],
    isLoading: true,
    isError: false,
  );

  Future<void> getMovieList(int num) async {
    try {
      final result = await MovieListImplementation.instance.movieList(num);
      resultData = result.fold(
          (l) => ProviderResponse(
                resultingData: [],
                isLoading: false,
                isError: true,
              ),
          (r) => ProviderResponse(
                resultingData: r.results,
                isLoading: false,
                isError: false,
              ));
    } catch (e) {
      resultData = ProviderResponse(
        resultingData: [],
        isLoading: false,
        isError: true,
      );
    }
    notifyListeners();
  }
}
