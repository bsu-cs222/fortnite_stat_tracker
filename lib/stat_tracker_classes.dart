import 'package:http/http.dart' as http;
import 'dart:convert';

class JsonDecoder {
  dynamic decodeJson(final jsonData) {
    final decoded = jsonDecode(jsonData);
    return decoded;
  }
}

class StatFetcher extends JsonDecoder {
  //final File apiFile = File('lib/Auth.txt');
  Future<String?> getID(String username) async {
    final url = "https://fortniteapi.io/v1/lookup?username=$username";
    Uri parsedUrl = Uri.parse(url);
    final http.Response response2 = await http.get(parsedUrl,
        headers: {'Authorization': '07c4969c-7271f85b-4178249c-4955adfa'});
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
    final http.Response result = await http.get(parsedUrl,
        headers: {'Authorization': '07c4969c-7271f85b-4178249c-4955adfa'});
    return result.body;
  }
}

class PlayerStatsDecoder extends JsonDecoder {
  List<String> gamemodesList = ['solo', 'duo', 'trio', 'squad'];

  String setUsername(final jsonPlayerData) {
    String newUsername = jsonPlayerData['name'];
    return newUsername;
  }

  int setLevel(final jsonPlayerData) {
    int newLevel = jsonPlayerData['account']['level'];
    return newLevel;
  }

  double setKD(final jsonPlayerData) {
    double overallKD = ((jsonPlayerData['global_stats']['solo']['kd']) +
        (jsonPlayerData['global_stats']['duo']['kd']) +
        (jsonPlayerData['global_stats']['trio']['kd']) +
        (jsonPlayerData['global_stats']['squad']['kd']) / 4);
    return overallKD;
  }

  double setWinRate(final jsonPlayerData) {
    double overallWinRate = ((jsonPlayerData['global_stats']['solo']
            ['winrate']) +
        (jsonPlayerData['global_stats']['duo']['winrate']) +
        (jsonPlayerData['global_stats']['trio']['winrate']) +
        (jsonPlayerData['global_stats']['squad']['winrate']) / 4);
    return overallWinRate;
  }

  int setKills(final jsonPlayerData) {
    int overallKills = ((jsonPlayerData['global_stats']['solo']['kills']) +
        (jsonPlayerData['global_stats']['duo']['kills']) +
        (jsonPlayerData['global_stats']['trio']['kills']) +
        (jsonPlayerData['global_stats']['squad']['kills']));
    return overallKills;
  }

  int setMatchesPlayed(final jsonPlayerData) {
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

class Player {
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

  void assignAllStats(dynamic decodedData) {
    assignOverallStats(decodedData);
    assignGameModeSpecificStats(decodedData);
  }

  void assignOverallStats(dynamic decodedData) {
    username = decoder.setUsername(decodedData);
    level = decoder.setLevel(decodedData);
    kD = decoder.setKD(decodedData);
    winRate = decoder.setWinRate(decodedData);
    eliminations = decoder.setKills(decodedData);
    matchesPlayed = decoder.setMatchesPlayed(decodedData);
  }

  void assignGameModeSpecificStats(dynamic decodedData) {
    gamemodeKDList = decoder.setGamemodeSpecificKDs(decodedData);
    gamemodeWinrateList = decoder.setGamemodeSpecificWinrates(decodedData);
    gamemodeEliminationsList =
        decoder.setGamemodeSpecificEliminations(decodedData);
    gamemodeMatchesPlayedList =
        decoder.setGamemodeSpecificMatchesPlayed(decodedData);
  }

  dynamic sortByStat(String stat) {
    switch (stat) {
      case 'KD':
        return kD;
      case 'winRate':
        return winRate;
      case 'eliminations':
        return eliminations;
      case 'matchesPlayed':
        return matchesPlayed;
    }
  }
}

class AccountSorter {
  List<Player> sortAccountsByOverallStat(List<Player> leaderboard, stat) {
    leaderboard
        .sort((a, b) => b.sortByStat(stat).compareTo(a.sortByStat(stat)));
    return leaderboard;
  }

  List<Player> sortAccountByGamemodeStat(List<Player> leaderboard) {
    leaderboard
        .sort((a, b) => b.gamemodeKDList[0].compareTo(a.gamemodeKDList[0]));
    return leaderboard;
  }
}
