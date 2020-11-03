import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier{
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if(_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null){
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(String email, String password, String urlSegment) async{
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDop9f_Pm1mXQ8GqsiqD5lYy6oQJAD7Vmc';
    try{
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },),
      );
      final responseData = json.decode(response.body);
      if(responseData['error'] != null){
        throw HttpException(responseData['error']['message']);
      }
      // idToken is a firebase Auth id token for the authenticated user
      _token = responseData['idToken'];

      // localId is the authenticated id
      _userId = responseData['localId'];

      _expiryDate = DateTime.now().add(
        Duration(
            seconds: int.parse(responseData['expiresIn'],
            ),
        ),
      );
      notifyListeners();
    }
    catch(error){
      throw error;
    }
  }

  // signing up
  Future<void> signup(String email, String password) async{
    return _authenticate(email, password, 'signUp');
  }

  // user login
  Future<void> login(String email, String password) async{
    return _authenticate(email, password, 'signInWithPassword');
  }
}