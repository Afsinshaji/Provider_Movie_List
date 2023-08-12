import '../../core/strings.dart';
import '../../infrastructure/api_key.dart';

class ApiEndPoints {
 static const getMovies = '$kBaseUrl/discover/movie?api_key=$apiKey&page={pagenumber}';
}
