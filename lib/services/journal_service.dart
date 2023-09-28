import 'dart:convert';
import 'dart:io';

import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/webcliente.dart';
import 'package:http/http.dart' as http;

class JournalService {
  static const String resource = "journals/";
  String url = WebCliente.url;
  http.Client  client = WebCliente().client;



  String getUrl() {
    return "$url$resource";
  }

  Future<bool> register(Journal journal, String token) async {
    //print('Print teste');
    String jsonJournal = jsonEncode(journal.toMap());
    //print(jsonJournal);
    //print('Print teste fim');

    http.Response response = await client.post(
      Uri.parse(getUrl()),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonJournal,
    );

    if (response.statusCode != 201) {

      if (json.decode(response.body) == 'jwt expired' ){
        throw TokenNotValidException();
      }

      throw HttpException(response.body);

    }
    return true;
  }

  Future<bool> edit(String id, Journal journal, {required String token}) async  {
    journal.updatedAt = DateTime.now();
    String jsonJournal = jsonEncode(journal.toMap());

    http.Response response = await client.put(
      Uri.parse("${getUrl()}$id"),
      headers: {
        'Content-type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonJournal,
    );

    if (response.statusCode != 200) {

      if (json.decode(response.body) == 'jwt expired' ){
        throw TokenNotValidException();
      }

      throw HttpException(response.body);

    }

    return true;
  }

  Future<bool> delete(String id, {required String token}) async {
    http.Response response = await client.delete(
      Uri.parse("${getUrl()}$id"),
      headers: {
        'Content-type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200){

      if (json.decode(response.body) == 'jwt expired' ){
        throw TokenNotValidException();
      }

      throw HttpException(response.body);

    }

    return true;
  }

  Future<List<Journal>> getAll({required String id, required String token}) async {
    http.Response response = await client.get(
        Uri.parse("${url}users/$id/journals"),
        headers: {"Authorization": "Bearer $token"});
    if (response.statusCode != 200) {
      if (json.decode(response.body) == 'jwt expired' ){
        throw TokenNotValidException();
      }

      throw HttpException(response.body);
    }
    List<Journal> list = [];

    List<dynamic> listDynamic = jsonDecode(response.body);

    for (var jsonMap in listDynamic) {
      list.add(Journal.fromMap(jsonMap));
    }
    //print(list.length);
    return list;
  }
}


class TokenNotValidException implements Exception{

}