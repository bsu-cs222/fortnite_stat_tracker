import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JsonDecoder {
  dynamic decodeJson(final jsonData) {
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

class Player {
  final decoder = PlayerStatsDecoder();
  String username = '';
  int level = 0;
  double overallKD = 0.0;
  double overallWinRate = 0.0;
  int overallEliminations = 0;
  int overallMatchesPlayed = 0;
  List<double> kDList = [];
  List<double> winrateList = [];
  List<int> eliminationsList = [];
  List<int> matchesPlayedList = [];

  void assignAllStats(String body) {
    assignOverallStats(body);
    assignGamemodeSpecificStats(body);
  }

  void assignOverallStats(String body) {
    final decodedData = decoder.decodeStats(body);
    username = decoder.setUsername(decodedData);
    level = decoder.setLevel(decodedData);
    overallKD = decoder.setOverallKD(decodedData);
    overallWinRate = decoder.setOverallWinRate(decodedData);
    overallEliminations = decoder.setOverallKills(decodedData);
    overallMatchesPlayed = decoder.setOverallMatchesPlayed(decodedData);
  }

  void assignGamemodeSpecificStats(String body) {
    final decodedData = decoder.decodeStats(body);
    kDList = decoder.setGamemodeSpecificKDs(decodedData);
    winrateList = decoder.setGamemodeSpecificWinrates(decodedData);
    eliminationsList = decoder.setGamemodeSpecificEliminations(decodedData);
    matchesPlayedList = decoder.setGamemodeSpecificMatchesPlayed(decodedData);
  }
}

class PlayerStatsDecoder extends JsonDecoder {
  List<String> gamemodesList = ['solo', 'duo', 'trio', 'squad'];
  dynamic decodeStats(String body) {
    final jsonPlayerData = decodeJson(body);
    return jsonPlayerData;
  }

  String setUsername(final jsonPlayerData) {
    String newUsername = jsonPlayerData['name'];
    return newUsername;
  }

  int setLevel(final jsonPlayerData) {
    int newLevel = jsonPlayerData['account']['level'];
    return newLevel;
  }

  double setOverallKD(final jsonPlayerData) {
    double overallKD = ((jsonPlayerData['global_stats']['solo']['kd']) +
        (jsonPlayerData['global_stats']['duo']['kd']) +
        (jsonPlayerData['global_stats']['trio']['kd']) +
        (jsonPlayerData['global_stats']['squad']['kd']) / 4);
    return overallKD;
  }

  double setOverallWinRate(final jsonPlayerData) {
    double overallWinRate = ((jsonPlayerData['global_stats']['solo']
            ['winrate']) +
        (jsonPlayerData['global_stats']['duo']['winrate']) +
        (jsonPlayerData['global_stats']['trio']['winrate']) +
        (jsonPlayerData['global_stats']['squad']['winrate']) / 4);
    return overallWinRate;
  }

  int setOverallKills(final jsonPlayerData) {
    int overallKills = ((jsonPlayerData['global_stats']['solo']['kills']) +
        (jsonPlayerData['global_stats']['duo']['kills']) +
        (jsonPlayerData['global_stats']['trio']['kills']) +
        (jsonPlayerData['global_stats']['squad']['kills']));
    return overallKills;
  }

  int setOverallMatchesPlayed(final jsonPlayerData) {
    int overallMatchesPlayed = ((jsonPlayerData['global_stats']['solo']
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
      kD = jsonPlayerData['global_stats'][gamemodesList[i]]['kd'].toDouble();
      kDList.add(kD);
    }
    return kDList;
  }

  List<double> setGamemodeSpecificWinrates(final jsonPlayerData) {
    List<double> winrateList = [];
    for (int i = 0; i < 4; i++) {
      double winrate = jsonPlayerData['global_stats'][gamemodesList[i]]
              ['winrate']
          .toDouble();
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
