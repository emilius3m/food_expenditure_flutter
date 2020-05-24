import 'dart:convert';
import 'package:Spesa/connection.dart';
import 'package:Spesa/models/user.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

class UserRepository {

  final String _url = 'http://' + con.getUrl() + '/login.php';
  User current;
  var headers = {"accept" : "application/json"};

  Future<User> authenticate({
    @required String username,
    @required String password,
  }) async {

    Map<String, String> body = {
      'username': username,
      'password': password,
    };

    await Future.delayed(Duration(seconds: 1));

    final response = await http.post(_url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        Map userMap = jsonDecode(response.body);
        current= User.fromJson(userMap);

        return current;
      }else{
        throw new Exception("Non e' possibile loggarsi!");
      }
    }
  String getUserName()  {
      return current.idUser;
  }

}
