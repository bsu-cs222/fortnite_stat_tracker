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
  List<String> gamemodesList = ['solo', 'duo', 'trio', 'squad'];

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

  List<double> parsePlayerGamemodeKDs(final jsonPlayerData) {
    List<double> kDList = [];
    double kD = 0.0;
    for (int i = 0; i < 4; i++) {
      kD = jsonPlayerData['global_stats'][gamemodesList[i]]['kd'].toDouble();
      kDList.add(kD);
    }
    return kDList;
  }

  List<double> parsePlayerGamemodeWinrates(final jsonPlayerData) {
    List<double> winrateList = [];
    for (int i = 0; i < 4; i++) {
      double winrate = jsonPlayerData['global_stats'][gamemodesList[i]]
              ['winrate']
          .toDouble();
      winrateList.add(winrate);
    }
    return winrateList;
  }

  List<int> parsePlayerGamemodeEliminations(final jsonPlayerData) {
    List<int> eliminationsList = [];
    int eliminations = 0;
    for (int i = 0; i < 4; i++) {
      eliminations = jsonPlayerData['global_stats'][gamemodesList[i]]['kills'];
      eliminationsList.add(eliminations);
    }
    return eliminationsList;
  }

  List<int> parsePlayerGamemodeMatchesPlayed(final jsonPlayerData) {
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
    username = decoder.parseUsername(decodedData);
    level = decoder.parseLevel(decodedData);
    kD = decoder.parsePlayerKD(decodedData);
    winRate = decoder.parsePlayerWinRate(decodedData);
    eliminations = decoder.parsePlayerKills(decodedData);
    matchesPlayed = decoder.parsePlayerMatchesPlayed(decodedData);
  }

  void assignGameModeSpecificStats(dynamic decodedData) {
    gamemodeKDList = decoder.parsePlayerGamemodeKDs(decodedData);
    gamemodeWinrateList = decoder.parsePlayerGamemodeWinrates(decodedData);
    gamemodeEliminationsList =
        decoder.parsePlayerGamemodeEliminations(decodedData);
    gamemodeMatchesPlayedList =
        decoder.parsePlayerGamemodeMatchesPlayed(decodedData);
  }
}

class FilterHandler {
  dynamic returnOverallStat(Player player, String stat) {
    switch (stat) {
      case 'KD':
        return player.kD;
      case 'winRate':
        return player.winRate;
      case 'eliminations':
        return player.eliminations;
      case 'matchesPlayed':
        return player.matchesPlayed;
      default:
        return const FormatException();
    }
  }

  int determineGamemode(String gamemode) {
    switch (gamemode) {
      case 'solo':
        return 0;
      case 'duo':
        return 1;
      case 'trio':
        return 2;
      case 'squad':
        return 3;
      default:
        throw const FormatException();
    }
  }

  dynamic returnSpecificGamemodeStat(
      Player player, String stat, String gamemode) {
    switch (stat) {
      case 'KD':
        return player.gamemodeKDList[determineGamemode(gamemode)];
      case 'winRate':
        return player.gamemodeWinrateList[determineGamemode(gamemode)];
      case 'eliminations':
        return player.gamemodeEliminationsList[determineGamemode(gamemode)];
      case 'matchesPlayed':
        return player.gamemodeMatchesPlayedList[determineGamemode(gamemode)];
      default:
        throw const FormatException();
    }
  }
}

class AccountSorter extends FilterHandler {
  List<Player> sortAccountListByOverallStat(
      List<Player> leaderboard, String stat) {
    leaderboard.sort((a, b) =>
        returnOverallStat(b, stat).compareTo(returnOverallStat(a, stat)));
    return leaderboard;
  }

  List<Player> sortAccountListByGamemodeStat(
      List<Player> leaderboard, String stat, String gamemode) {
    leaderboard.sort((a, b) => returnSpecificGamemodeStat(b, stat, gamemode)
        .compareTo(returnSpecificGamemodeStat(a, stat, gamemode)));
    return leaderboard;
  }
}
