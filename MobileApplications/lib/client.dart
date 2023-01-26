import 'package:http/http.dart' as http;

const String baseUrl = 'https://accounts.spotify.com/authorize';

class Client {
  var client = http.Client();

  Future<dynamic> authorizeClient(String clientID) async {
    var url = Uri.parse(baseUrl + clientID);
    var _headers = {};
  }
}
