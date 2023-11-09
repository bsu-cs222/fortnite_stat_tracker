import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JsonDecoder {
  decodeJson(final jsonData) {
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
  Future<String?> getID(String username) async {
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
  List<String> gamemodesList = ['solo', 'duo', 'trio', 'squad'];
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

  List<double> setGamemodeSpecificKDs(final jsonPlayerData) {
    List<double> kDList = [];
    double kD = 0.0;
    for (int i = 0; i < 4; i++) {
      kD = jsonPlayerData['global_stats'][gamemodesList[i]]['kd'];
      kDList.add(kD);
    }
    return kDList;
  }

  List<double> setGamemodeSpecificWinrates(final jsonPlayerData) {
    List<double> winrateList = [];
    double winrate = 0.0;
    for (int i = 0; i < 4; i++) {
      winrate = jsonPlayerData['global_stats'][gamemodesList[i]]['winrate'];
      winrateList.add(winrate);
    }
    return winrateList;
  }

  List<int> setGamemodeSpecificEliminations(final jsonPlayerData) {
    List<int> eliminationsList = [];
    int eliminations = 0;
    for (int i = 0; i < 4; i++) {
      eliminations = jsonPlayerData['global_stats'][gamemodesList[i]]['kills'];
      eliminationsList.add(eliminations);
    }
    return eliminationsList;
  }

  List<int> setGamemodeSpecificMatchesPlayed(final jsonPlayerData) {
    List<int> matchesPlayedList = [];
    int matches = 0;
    for (int i = 0; i < 4; i++) {
      matches =
          jsonPlayerData['global_stats'][gamemodesList[i]]['matchesplayed'];
      matchesPlayedList.add(matches);
    }
    return matchesPlayedList;
  }
}

class PlayerStatsAssigner {
  final decoder = PlayerStatsDecoder();
  String username = '';
  int level = 0;
  double kD = 0.0;
  double winRate = 0.0;
  int eliminations = 0;
  int matchesPlayed = 0;
  List<double> gamemodeKDList = [];
  List<double> gamemodeWinrateList = [];
  List<int> gamemodeEliminationsList = [];
  List<int> gamemodeMatchesPlayedList = [];

  void assignAllStats(String body) {
    assignOverallStats(body);
    assignGamemodeSpecificStats(body);
  }

  void assignOverallStats(String body) {
    final decodedData = decoder.decodeStats(body);
    username = decoder.setUsername(decodedData);
    level = decoder.setLevel(decodedData);
    kD = decoder.setKD(decodedData);
    winRate = decoder.setWinRate(decodedData);
    eliminations = decoder.setKills(decodedData);
    matchesPlayed = decoder.setMatchesPlayed(decodedData);
  }

  void assignGamemodeSpecificStats(String body) {
    final decodedData = decoder.decodeStats(body);
    gamemodeKDList = decoder.setGamemodeSpecificKDs(decodedData);
    gamemodeWinrateList = decoder.setGamemodeSpecificWinrates(decodedData);
    gamemodeEliminationsList =
        decoder.setGamemodeSpecificEliminations(decodedData);
    gamemodeMatchesPlayedList =
        decoder.setGamemodeSpecificMatchesPlayed(decodedData);
  }
}
