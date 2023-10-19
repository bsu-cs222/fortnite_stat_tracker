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

class player {
  String username = '';
  String level = '';
  String playerKD = '';
  String playerWinRate = '';
  String playerKills = '';
  String playerMatches = '';

  String setUsername(newUsername) {
    return username = newUsername;
  }

  String setLevel(newLevel) {
    return username = newLevel;
  }

  double setKD(soloKD, duoKD, trioKD, squadKD) {
    var overallKD = (soloKD + duoKD + trioKD + squadKD) / 4;
    return playerKD = overallKD;
  }

  double setWinRate(soloWinRate, duoWinRate, trioWinRate, squadWinRate) {
    var overallWinRate =
        (soloWinRate + duoWinRate + trioWinRate + squadWinRate) / 4;
    return playerWinRate = overallWinRate;
  }

  String setKills(soloKills, duoKills, trioKills, squadKills) {
    var overallKills = (soloKills + duoKills + trioKills + squadKills);
    return playerKills = overallKills;
  }

  String setMatchesPlayed(soloMatchesPlayed, duoMatchesPlayed,
      trioMatchesPlayed, squadMatchesPlayed) {
    var overallMatchesPlayed = (soloMatchesPlayed +
        duoMatchesPlayed +
        trioMatchesPlayed +
        squadMatchesPlayed);
    return playerMatches = overallMatchesPlayed;
  }
}
