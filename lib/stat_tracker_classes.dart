import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StatFetcher {
  Future<String> getID(username) async {
    const url = "https://fortniteapi.io/v1/lookup?username=MaxSineFN";
    var parsedUrl = Uri.parse(url);
    final http.Response response2 = await http.get(parsedUrl,
        headers: {'Authorization': '07c4969c-7271f85b-4178249c-4955adfa'});
    final IDbody = jsonDecode(response2.body);
    final userID = IDbody['account_id'];
    return userID;
  }
}
