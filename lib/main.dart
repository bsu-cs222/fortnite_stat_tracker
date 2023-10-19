import 'dart:convert';

import "package:fortnite_api_io/fortnite_api_io.dart";
import 'package:http/http.dart' as http;

void main() async {
  const url = "https://fortniteapi.io/v1/lookup?username=MaxSineFN";

  var parsedUrl = Uri.parse(url);

  final http.Response response2 = await http.get(parsedUrl,
      headers: {'Authorization': '07c4969c-7271f85b-4178249c-4955adfa'});

  final IDbody = jsonDecode(response2.body);

  final pagesMap = IDbody['account_id'];

  print(pagesMap);

  var url2 = "https://fortniteapi.io/v1/stats?account=$pagesMap";

  var parsedUrl2 = Uri.parse(url2);

  final http.Response result = await http.get(parsedUrl2,
      headers: {'Authorization': '07c4969c-7271f85b-4178249c-4955adfa'});

  print(result.body);
}
