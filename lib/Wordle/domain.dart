enum GameColor {
  unset,
  none,
  partial,
  exact,
}

enum TurnResult { unset, successful, unsuccessful, partial }

class Settings {
  bool isDarkMode;
  bool isHardMode;

  Settings(this.isDarkMode, this.isHardMode);

  Settings.fromJson(Map<String, dynamic> json)
      : isDarkMode = json['isDarkMode'],
        isHardMode = json['isHardMode'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isDarkMode'] = isDarkMode;
    data['isHardMode'] = isHardMode;
    return data;
  }
}

class Letter {
  int index;
  String value;
  GameColor color;

  Letter(this.index, this.value, this.color);

  Letter.fromJson(Map<String, dynamic> json)
      : index = json['index'],
        value = json['value'],
        color = GameColor.values.byName(json['color']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['index'] = index;
    data['value'] = value;
    data['color'] = color.name;
    return data;
  }
}

class Board {
  List<Letter> tiles;

  Board(this.tiles);

  factory Board.fromJson(Map<String, dynamic> json) {
    var tiles = <Letter>[];
    json['tiles'].forEach((tile) {
      tiles.add(Letter.fromJson(tile));
    });
    return Board(tiles);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tiles'] = tiles;
    return data;
  }
}

class Context {
  Board board;
  List<List<Letter>> keys;
  String answer;
  String guess;
  List<Letter> attempt;
  TurnResult turnResult;
  int remainingTries;
  String message;
  int currentIndex;

  Context(this.board, this.keys, this.answer, this.guess, this.attempt, this.turnResult,
      this.remainingTries, this.message, this.currentIndex);

  factory Context.fromJson(Map<String, dynamic> json) {
    var isPrevious = json['board'] is List;
    Board board;
    if (isPrevious) {
      var tiles = <Letter>[];
      json['board'].forEach((letter) {
        tiles.add(Letter.fromJson(letter));
      });
      board = Board(tiles);
    } else {
      board = Board.fromJson(json['board']);
    }
    var keys = <List<Letter>>[];
    if (json['keys'] != null) {
      json['keys'].forEach((row) {
        var rowKeys = <Letter>[];
        row.forEach((key) {
          rowKeys.add(Letter.fromJson(key));
        });
        keys.add(rowKeys);
      });
    }
    String answer = json['answer'];
    String guess = json['guess'];
    var attempt = <Letter>[];
    json['attempt'].forEach((letter) {
      attempt.add(Letter.fromJson(letter));
    });
    TurnResult turnResult = TurnResult.values.byName(json['turnResult']);
    int remainingTries = json['remainingTries'];
    String message = json['message'];
    int currentIndex = json['currentIndex'];
    DateTime? lastPlayed = json['lastPlayed'] != null ? DateTime.parse(json['lastPlayed']) : null;

    return Context(board, keys, answer, guess, attempt, turnResult, remainingTries, message,
        currentIndex, );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['board'] = board;
    data['keys'] = keys;
    data['answer'] = answer;
    data['guess'] = guess;
    data['attempt'] = attempt;
    data['turnResult'] = turnResult.name;
    data['remainingTries'] = remainingTries;
    data['message'] = message;
    data['currentIndex'] = currentIndex;
    return data;
  }
}

class Stats {
  int won;
  int lost;
  Streak streak;
  List<int> guessDistribution;
  int lastGuess;
  String lastBoard;
  int gameNumber;

  Stats(this.won, this.lost, this.streak, this.guessDistribution, this.lastGuess, this.lastBoard,
      this.gameNumber);

  Stats.fromJson(Map<String, dynamic> json)
      : won = json['won'],
        lost = json['lost'],
        streak = json['streak'] = Streak.fromJson(json['streak']),
        guessDistribution = json['guessDistribution'].cast<int>(),
        lastGuess = json['lastGuess'],
        lastBoard = json['lastBoard'] ?? '',
        gameNumber = json['gameNumber'] ?? 0;

  int get played => guessDistribution.reduce((value, g) => value + g) + lost;

  int get percentWon => played == 0 ? 0 : (won / played * 100).round();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['won'] = won;
    data['lost'] = lost;
    data['streak'] = streak.toJson();
    data['guessDistribution'] = guessDistribution;
    data['lastGuess'] = lastGuess;
    data['lastBoard'] = lastBoard;
    data['gameNumber'] = gameNumber;
    return data;
  }
}

class Streak {
  int current;
  int max;

  Streak(this.current, this.max);

  Streak.fromJson(Map<String, dynamic> json)
      : current = json['current'],
        max = json['max'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current'] = current;
    data['max'] = max;
    return data;
  }
}