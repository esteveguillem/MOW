import 'package:MindOfWords/Synonyms/Models/Synonym.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:MindOfWords/Synonyms/domain.dart';
import 'package:MindOfWords/Wordle/services/context_service.dart';
import 'package:MindOfWords/Synonyms/services/keyboard_service.dart';
import 'package:MindOfWords/Synonyms/services/stats_service.dart';
import 'package:MindOfWords/Wordle/services/word_service.dart';

import '../HttpService.dart';

class SynGame {
  static const boardSize = 30;
  static const rowLength = 5;
  static const totalTries = 6;
  static const cellMargin = 8;

  SynGame() {
    // reloadGame();
  }

  static SynStatsService _statsService = SynStatsService();

  final _baseDate = DateTime(2021, DateTime.june, 19);

  late SynContext _context;
  late SynStats _stats;
  late final List<GlobalKey<AnimatorWidgetState>> _shakeKeys = [];
  late final List<GlobalKey<AnimatorWidgetState>> _bounceKeys = [];

  var _wordService = WordService();

  bool isEvaluating = false;
  SynStats get stats => _stats;
  int get _gameNumber => DateTime.now().difference(_baseDate).inDays;

  Future<Synonym> getSynonyms() async {
    final HttpService httpService = HttpService();
    Synonym synon = await httpService.getSynonyms();
    print(synon);
    return synon;
  }

  Future<bool> init() async {
    print("Init");
    await _initContext();
    await _wordService.init();
    _stats = await _statsService.loadStats();
    return true;
  }

  Future<bool> _initContext() async{
    Synonym s = await getSynonyms();
    _context = SynContext(KeyboardService.init().keys, s, '', [], 0,
        'Good Luck!', 0, DateTime.now());
    print("InitContext");
    // print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA${_context.answer}");

    return true;
  }
  Future<SynStats> _updateStats(bool won, int remainingTries) async {
    return await _statsService.updateStats(
        _stats, won, (remainingTries - totalTries).abs(), _gameNumber);
  }
   evaluateTurn(String letter) {
    isEvaluating = true;
    if (KeyboardService.isEnter(letter)) {
      return true;
    } else if (KeyboardService.isBackspace(letter)) {
      _context.guess = _context.guess.substring(0, _context.guess.length - 1);
      return false;
    } else if (KeyboardService.isSpace(letter)) {
      _context.guess = _context.guess + " ";
      return false;
    } else {
      _context.guess = _context.guess + letter;
      // print(_context.guess);
      return false;
    }
  }

  SynContext get context => _context;

  Future updateAfterSuccessfulGuess(List<String> a) async {
    var won = didWin(_context.answer.syn, a);
    if (won || _context.aciertos >= 1) {
      _stats = await _updateStats(won, 0);
    }
      _context.guess = '';
      _context.attempt = [];

  }

  bool didWin(List<String> correct, List<String> a){
    var count = 0;
    for (String correct in correct) {
      for (String guess in a) {
        if (guess == correct) {
          count += 1;
        }
      }
    }
    if(count == correct.length){
      return true;
    }else{
      return false;
    }
  }
  void reloadGame() {
    _statsService = SynStatsService();
    _wordService = WordService();
    init();
  }
}
