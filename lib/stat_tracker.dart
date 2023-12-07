import 'package:http/http.dart' as http;
import 'dart:convert';

class JsonDecoder {
  dynamic decodeJson(final jsonData) {
    final decoded = jsonDecode(jsonData);
    return decoded;
  }
}

class SpaceReplacer {
  String replaceSpaces(String input) {
    StringBuffer output = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      if (input[i] == ' ') {
        output.write('%20');
      } else {
        output.write(input[i]);
      }
    }
    return output.toString();
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
  List<String> gameModesList = ['solo', 'duo', 'trio', 'squad'];

  String parseUsername(final jsonPlayerData) {
    String newUsername = jsonPlayerData['name'];
    return newUsername;
  }

  int parseLevel(final jsonPlayerData) {
    int newLevel = jsonPlayerData['account']['level'];
    return newLevel;
  }

  double parsePlayerKD(final jsonPlayerData) {
    double overallKD = ((jsonPlayerData['global_stats']['solo']['kd']) +
        (jsonPlayerData['global_stats']['duo']['kd']) +
        (jsonPlayerData['global_stats']['trio']['kd']) +
        (jsonPlayerData['global_stats']['squad']['kd']) / 4);
    return overallKD;
  }

  double parsePlayerWinRate(final jsonPlayerData) {
    double overallWinRate = ((jsonPlayerData['global_stats']['solo']
            ['winrate']) +
        (jsonPlayerData['global_stats']['duo']['winrate']) +
        (jsonPlayerData['global_stats']['trio']['winrate']) +
        (jsonPlayerData['global_stats']['squad']['winrate']) / 4);
    return overallWinRate;
  }

  int parsePlayerKills(final jsonPlayerData) {
    int overallKills = ((jsonPlayerData['global_stats']['solo']['kills']) +
        (jsonPlayerData['global_stats']['duo']['kills']) +
        (jsonPlayerData['global_stats']['trio']['kills']) +
        (jsonPlayerData['global_stats']['squad']['kills']));
    return overallKills;
  }

  int parsePlayerMatchesPlayed(final jsonPlayerData) {
    int overallMatchesPlayed = ((jsonPlayerData['global_stats']['solo']
            ['matchesplayed']) +
        (jsonPlayerData['global_stats']['duo']['matchesplayed']) +
        (jsonPlayerData['global_stats']['trio']['matchesplayed']) +
        (jsonPlayerData['global_stats']['squad']['matchesplayed']));
    return overallMatchesPlayed;
  }

  List<double> parsePlayerGameModeKDs(final jsonPlayerData) {
    List<double> kDList = [];
    double kD = 0.0;
    for (int i = 0; i < 4; i++) {
      kD = jsonPlayerData['global_stats'][gameModesList[i]]['kd'].toDouble();
      kDList.add(kD);
    }
    return kDList;
  }

  List<double> parsePlayerGameModeWinRates(final jsonPlayerData) {
    List<double> winRateList = [];
    for (int i = 0; i < 4; i++) {
      double winRate = jsonPlayerData['global_stats'][gameModesList[i]]
              ['winrate']
          .toDouble();
      winRateList.add(winRate);
    }
    return winRateList;
  }

  List<int> parsePlayerGameModeEliminations(final jsonPlayerData) {
    List<int> eliminationsList = [];
    int eliminations = 0;
    for (int i = 0; i < 4; i++) {
      eliminations = jsonPlayerData['global_stats'][gameModesList[i]]['kills'];
      eliminationsList.add(eliminations);
    }
    return eliminationsList;
  }

  List<int> parsePlayerGameModeMatchesPlayed(final jsonPlayerData) {
    List<int> matchesPlayedList = [];
    int matchesPlayed = 0;
    for (int i = 0; i < 4; i++) {
      matchesPlayed =
          jsonPlayerData['global_stats'][gameModesList[i]]['matchesplayed'];
      matchesPlayedList.add(matchesPlayed);
    }

    return matchesPlayedList;
  }
}

class Player extends PlayerStatsDecoder {
  String username = '';
  int level = 0;
  double kD = 0.0;
  double winRate = 0.0;
  int eliminations = 0;
  int matchesPlayed = 0;
  List<double> gameModeKDList = [];
  List<double> gameModeWinRateList = [];
  List<int> gameModeEliminationsList = [];
  List<int> gameModeMatchesPlayedList = [];

  void assignAllStats(dynamic decodedData) {
    assignOverallStats(decodedData);
    assignGameModeSpecificStats(decodedData);
  }

  void assignOverallStats(dynamic decodedData) {
    username = parseUsername(decodedData);
    level = parseLevel(decodedData);
    kD = parsePlayerKD(decodedData);
    winRate = parsePlayerWinRate(decodedData);
    eliminations = parsePlayerKills(decodedData);
    matchesPlayed = parsePlayerMatchesPlayed(decodedData);
  }

  void assignGameModeSpecificStats(dynamic decodedData) {
    gameModeKDList = parsePlayerGameModeKDs(decodedData);
    gameModeWinRateList = parsePlayerGameModeWinRates(decodedData);
    gameModeEliminationsList = parsePlayerGameModeEliminations(decodedData);
    gameModeMatchesPlayedList = parsePlayerGameModeMatchesPlayed(decodedData);
  }
}

class Filterer {
  dynamic returnOverallStat(Player player, String stat) {
    switch (stat) {
      case 'KD':
        return player.kD;
      case 'Win Rate':
        return player.winRate;
      case 'Eliminations':
        return player.eliminations;
      case 'Matches Played':
        return player.matchesPlayed;
      default:
        return const FormatException();
    }
  }

  int returnGameModeListIndex(String gameMode) {
    switch (gameMode) {
      case 'Solos':
        return 0;
      case 'Duos':
        return 1;
      case 'Trios':
        return 2;
      case 'Squads':
        return 3;
      default:
        throw const FormatException();
    }
  }

  dynamic returnSpecificGameModeStat(
      Player player, String stat, String gameMode) {
    switch (stat) {
      case 'KD':
        return player.gameModeKDList[returnGameModeListIndex(gameMode)];
      case 'Win Rate':
        return player.gameModeWinRateList[returnGameModeListIndex(gameMode)];
      case 'Eliminations':
        return player
            .gameModeEliminationsList[returnGameModeListIndex(gameMode)];
      case 'Matches Played':
        return player
            .gameModeMatchesPlayedList[returnGameModeListIndex(gameMode)];
      default:
        throw const FormatException();
    }
  }
}

class AccountSorter extends Filterer {
  List<Player> sortAccountListByOverallStat(
      List<Player> leaderboard, String stat) {
    leaderboard.sort((a, b) =>
        returnOverallStat(b, stat).compareTo(returnOverallStat(a, stat)));
    return leaderboard;
  }

  List<Player> sortAccountListByGameModeStat(
      List<Player> leaderboard, String stat, String gameMode) {
    leaderboard.sort((a, b) => returnSpecificGameModeStat(b, stat, gameMode)
        .compareTo(returnSpecificGameModeStat(a, stat, gameMode)));
    return leaderboard;
  }
}
