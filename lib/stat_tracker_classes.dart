import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JsonDecoder {
  decodeJson(jsonData) {
    final decoded = jsonDecode(jsonData);
    return decoded;
  }
}

class StatFetcher extends JsonDecoder {
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

  Player assignStats(body) {
    final Player player = Player();
    player.setStats(body);
    return player;
  }
}

class Player extends JsonDecoder {
  String username = '';
  int level = 0;
  double playerKD = 0.0;
  double playerWinRate = 0.0;
  int playerKills = 0;
  int playerMatches = 0;

  void setStats(body) {
    final playerJSON = decodeJson(body);
    setUsername(playerJSON);
    setLevel(playerJSON);
    setKD(playerJSON);
    setWinRate(playerJSON);
    setKills(playerJSON);
    setMatchesPlayed(playerJSON);
  }

  String setUsername(playerJSON) {
    final newUsername = playerJSON.keys.first;
    return username = newUsername;
  }

  int setLevel(playerJSON) {
    final newLevel = playerJSON['account']['level'];
    return level = newLevel;
  }

  double setKD(playerJSON) {
    var overallKD = ((playerJSON['global_stats']['solo']['kd']) +
        (playerJSON['global_stats']['duo']['kd']) +
        (playerJSON['global_stats']['trio']['kd']) +
        (playerJSON['global_stats']['squad']['kd']) / 4);
    return playerKD = overallKD;
  }

  double setWinRate(playerJSON) {
    var overallWinRate = ((playerJSON['global_stats']['solo']['winrate']) +
        (playerJSON['global_stats']['duo']['winrate']) +
        (playerJSON['global_stats']['trio']['winrate']) +
        (playerJSON['global_stats']['squad']['winrate']) / 4);
    return playerWinRate = overallWinRate;
  }

  int setKills(playerJSON) {
    var overallKills = ((playerJSON['global_stats']['solo']['kills']) +
        (playerJSON['global_stats']['duo']['kills']) +
        (playerJSON['global_stats']['trio']['kills']) +
        (playerJSON['global_stats']['squad']['kills']));
    return playerKills = overallKills;
  }

  int setMatchesPlayed(playerJSON) {
    var overallMatchesPlayed = ((playerJSON['global_stats']['solo']
            ['matchesplayed']) +
        (playerJSON['global_stats']['duo']['matchesplayed']) +
        (playerJSON['global_stats']['trio']['matchesplayed']) +
        (playerJSON['global_stats']['squad']['matchesplayed']));
    return playerMatches = overallMatchesPlayed;
  }

  String getUsername() {
    return username;
  }

  int getLevel() {
    return level;
  }

  double getPlayerKD() {
    return playerKD;
  }

  double getPlayerWinRate() {
    return playerWinRate;
  }

  int getPlayerKills() {
    return playerKills;
  }

  int getMatchesPlayed() {
    return playerMatches;
  }
}
