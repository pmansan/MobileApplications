import 'dart:async';
//import 'package:flutter_web_auth/flutter_web_auth.dart';
//import 'package:http/http.dart' show Client;

  //Client client = Client();

  String clientId = "015bbafc628b4e399c285e64ddc8d67f";
  String redirectUri = "https://QuizzMobileApp.com/callback";
  String state = "34fFs29kd09" ;//generateRandomState(); //un metodo para generar un estado aleatorio
  String scope = "user-read-private user-library-read";


  Uri authUrl = Uri.https("accounts.spotify.com", "authorize", {
  "client_id": clientId,
  "response_type": "code",
  "redirect_uri": redirectUri,
  "state": state,
  "scope": scope,
});

String url = authUrl.toString();
//print(url);

