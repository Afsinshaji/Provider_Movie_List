import '../../domain/movie_list/movie_list_model/result.dart';

class ProviderResponse {
  final List<Result>? resultingData;
  final bool isLoading;
  final bool isError;

  ProviderResponse({
    required this.resultingData,
    required this.isLoading,
    required this.isError,
  });
}
