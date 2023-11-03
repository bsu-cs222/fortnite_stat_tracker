import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JsonDecoder {
  decodeJson(jsonData) {
    final decoded = jsonDecode(jsonData);
    return decoded;
  }
}

mixin DataExtractor {
  String pullString(File file) {
    String fileData = file.readAsStringSync();
    return fileData;
  }
}

class StatFetcher extends JsonDecoder with DataExtractor {
  final File apiFile = File('lib/Auth');
  Future<String?> getID(username) async {
    final url = "https://fortniteapi.io/v1/lookup?username=$username";
    Uri parsedUrl = Uri.parse(url);
    final http.Response response2 = await http
        .get(parsedUrl, headers: {'Authorization': pullString(apiFile)});
    final iDBody = jsonDecode(response2.body);
    final userID = iDBody['account_id'];
    return userID;
  }

  Future<String> getStatJSON(String userId, String platform) async {
    String url = "https://fortniteapi.io/v1/stats?account=$userId";
    if (platform == "xbl") {
      url = "https://fortniteapi.io/v1/stats?account=$userId&platform=xbl";
    } else if (platform == "psn") {
      url = "https://fortniteapi.io/v1/stats?account=$userId&platform=psn";
    }
    Uri parsedUrl = Uri.parse(url);
    final http.Response result = await http
        .get(parsedUrl, headers: {'Authorization': pullString(apiFile)});
    return result.body;
  }
}

class PlayerStatsDecoder extends JsonDecoder {
  decodeStats(String body) {
    final jsonPlayerData = decodeJson(body);
    return jsonPlayerData;
  }

  String setUsername(final jsonPlayerData) {
    final newUsername = jsonPlayerData['name'];
    return newUsername;
  }

  int setLevel(final jsonPlayerData) {
    final newLevel = jsonPlayerData['account']['level'];
    return newLevel;
  }

  double setKD(final jsonPlayerData) {
    final overallKD = ((jsonPlayerData['global_stats']['solo']['kd']) +
        (jsonPlayerData['global_stats']['duo']['kd']) +
        (jsonPlayerData['global_stats']['trio']['kd']) +
        (jsonPlayerData['global_stats']['squad']['kd']) / 4);
    return overallKD;
  }

  double setWinRate(final jsonPlayerData) {
    var overallWinRate = ((jsonPlayerData['global_stats']['solo']['winrate']) +
        (jsonPlayerData['global_stats']['duo']['winrate']) +
        (jsonPlayerData['global_stats']['trio']['winrate']) +
        (jsonPlayerData['global_stats']['squad']['winrate']) / 4);
    return overallWinRate;
  }

  int setKills(final jsonPlayerData) {
    final overallKills = ((jsonPlayerData['global_stats']['solo']['kills']) +
        (jsonPlayerData['global_stats']['duo']['kills']) +
        (jsonPlayerData['global_stats']['trio']['kills']) +
        (jsonPlayerData['global_stats']['squad']['kills']));
    return overallKills;
  }

  int setMatchesPlayed(final jsonPlayerData) {
    final overallMatchesPlayed = ((jsonPlayerData['global_stats']['solo']
            ['matchesplayed']) +
        (jsonPlayerData['global_stats']['duo']['matchesplayed']) +
        (jsonPlayerData['global_stats']['trio']['matchesplayed']) +
        (jsonPlayerData['global_stats']['squad']['matchesplayed']));
    return overallMatchesPlayed;
  }
}

class PlayerStatsAssigner {
  String username = '';
  int level = 0;
  double kD = 0.0;
  double winRate = 0.0;
  int eliminations = 0;
  int matchesPlayed = 0;
  void assignJsonStats(String body) {
    final decoder = PlayerStatsDecoder();
    final decodedData = decoder.decodeStats(body);
    username = decoder.setUsername(decodedData);
    level = decoder.setLevel(decodedData);
    kD = decoder.setKD(decodedData);
    winRate = decoder.setWinRate(decodedData);
    eliminations = decoder.setKills(decodedData);
    matchesPlayed = decoder.setMatchesPlayed(decodedData);
  }
}
