import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StatFetcher {
  Future<String> getID(username) async {
    final url = "https://fortniteapi.io/v1/lookup?username=$username";
    var parsedUrl = Uri.parse(url);
    final http.Response response2 = await http.get(parsedUrl,
        headers: {'Authorization': '07c4969c-7271f85b-4178249c-4955adfa'});
    final IDbody = jsonDecode(response2.body);
    final userID = IDbody['account_id'];
    return userID;
  }

  Future<String> getStats(userId) async {
    final url = "https://fortniteapi.io/v1/stats?account=$userId";
    var parsedUrl = Uri.parse(url);
    final http.Response result = await http.get(parsedUrl,
        headers: {'Authorization': '07c4969c-7271f85b-4178249c-4955adfa'});
    return result.body;
  }
}
