import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:MindOfWords/Spell/domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpellStatsService {
  Future<String> _readAsset(String fileName) async {
    WidgetsFlutterBinding.ensureInitialized();
    return await rootBundle.loadString(fileName);
  }

  Future<SpellStats> loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    String? usr = prefs.getString('userName');
    if(usr == null){
      usr = "null";
    }
    final jsonString = json.encode({"userName": usr});
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http
        .post(Uri.parse("https://mowapi.herokuapp.com/getStatsSpell"),
            headers: headers, body: jsonString)
        .timeout(const Duration(seconds: 5))
        .catchError((onError) {
      print("Conexion no establecida, error en la conexion");
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);

      return SpellStats.fromJson(body["stat"]);
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  Future<SpellStats> updateStats(
      SpellStats stats, bool won, int index, int gameNumber) async {
    if (won) {

      stats.won += 1;
      stats.streak.current += 1;
      if (stats.streak.current > stats.streak.max) {
        stats.streak.max = stats.streak.current;
      }
    } else {
      stats.lost += 1;
      stats.streak.current = 0;

    }


    await saveStats(stats);
    return stats;
  }

  Future<void> saveStats(SpellStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode({"userName":await prefs.getString('userName') ,"stat": stats});
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http
        .post(Uri.parse("https://mowapi.herokuapp.com/setStatsSpell"),
        headers: headers, body: jsonString)
        .timeout(const Duration(seconds: 5))
        .catchError((onError) {
      print("Conexion no establecida, error en la conexion");
    });

  }
}
