import 'dart:math';
import 'package:MindOfWords/main.dart';
import 'package:flutter/material.dart';
import 'package:MindOfWords/Wordle/domain.dart';
import 'package:MindOfWords/Wordle/services/stats_service.dart';
import 'package:MindOfWords/Wordle/widgets/countdown.dart';
import 'package:share_plus/share_plus.dart';

import '../game.dart';
import '../wordle.dart';

class StatsWidget extends StatefulWidget {
  StatsWidget(this._stats, this._close, this._newGame, {Key? key})
      : super(key: key);

  final Stats _stats;
  final Function _close;
  final Function _newGame;

  Stats get stats => _stats;

  Function get close => _close;

  Function get newGame => _newGame;

  @override
  State<StatefulWidget> createState() => _StatsState();
}

class _StatsState extends State<StatsWidget> {
  int _getFlex(int number, int total) =>
      total == 0 ? 0 : (number / (number + (total - number)) * 10).ceil();

  Future<Stats> get _stats =>
      Future.microtask(() => StatsService().loadStats());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _stats,
        builder: (BuildContext context, AsyncSnapshot<Stats> snapshot) {
          return Material(
            shadowColor: Colors.black12,
            child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                    width: 500,
                    height: 520,
                    child: Stack(children: [
                      Positioned(
                          top: 0,
                          left: 0,
                          child: SizedBox(
                            width: 410,
                            height: 520,
                            child: Column(children: [
                              Row(
                                children: [
                                  const Spacer(),
                                  TextButton(
                                      onPressed: () => widget.close(),
                                      child: const Text("X",
                                          style: TextStyle(fontSize: 20)))
                                ],
                              ),
                              const Center(
                                  child: Text(
                                "STATISTICS",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              )),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 20, 10, 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4, right: 4),
                                      child: Column(
                                        children: [
                                          Text(
                                            widget.stats.played.toString(),
                                            style: const TextStyle(
                                              fontSize: 36,
                                            ),
                                          ),
                                          const Text(
                                            "Played",
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4, right: 4),
                                      child: Column(
                                        children: [
                                          Text(
                                            widget.stats.percentWon.toString(),
                                            style: const TextStyle(
                                              fontSize: 36,
                                            ),
                                          ),
                                          const Text(
                                            "Win %",
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4, right: 4),
                                      child: Column(
                                        children: [
                                          Text(
                                            widget.stats.streak.current
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 36,
                                            ),
                                          ),
                                          Column(children: const [
                                            Center(
                                                child: Text(
                                              "Current",
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            )),
                                            Center(
                                                child: Text(
                                              "Streak",
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ))
                                          ]),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4, right: 4),
                                      child: Column(
                                        children: [
                                          Text(
                                            widget.stats.streak.max.toString(),
                                            style: const TextStyle(
                                              fontSize: 36,
                                            ),
                                          ),
                                          Column(children: const [
                                            Center(
                                                child: Text(
                                              "Max",
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            )),
                                            Center(
                                                child: Text(
                                              "Streak",
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ))
                                          ]),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Center(
                                    child: Text(
                                  "GUESS DISTRIBUTION",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                )),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: _guessDistribution(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 16, left: 16),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.green),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => WordleApp()),
                                              );
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const [
                                                Text('PLAY AGAIN',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                    )),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      VerticalDivider(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        width: 2,
                                        indent: 2,
                                        endIndent: 2,
                                        thickness: 2,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 16, left: 16),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.green),
                                            onPressed: () {
                                              var guesses =
                                                  widget.stats.lastGuess == -1
                                                      ? 'X'
                                                      : widget.stats.lastGuess;
                                              Share.share(
                                                  'MOW ${widget.stats.gameNumber} $guesses/6\n${widget.stats.lastBoard}',
                                                  subject: 'MOW $guesses/6');
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const [
                                                Text('SHARE',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                    )),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Icon(
                                                  Icons.share,
                                                  color: Colors.white,
                                                  size: 24.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ]),
                          ))
                    ]))),
          );
        });
  }

  Widget _guessDistribution() {
    if (widget.stats.played == 0) {
      return const Center(
          child: Text(
        "No Data",
        style: TextStyle(fontSize: 20),
      ));
    }

    var maxGuess = widget.stats.guessDistribution.reduce(max);
    var children = <Widget>[];

    for (var i = 0; i < widget.stats.guessDistribution.length; i++) {
      children.add(_statRow(i + 1, widget.stats.guessDistribution[i], maxGuess,
          isCurrent: (i + 1) == widget.stats.lastGuess));
    }
    return Column(children: children);
  }

  Padding _statRow(int rowNumber, int completed, int total,
      {bool isCurrent = false}) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 3.0),
            child: Text(
              rowNumber.toString(),
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: _getFlex(completed, total),
            child: Container(
                color: isCurrent
                    ? Colors.green
                    : const Color.fromARGB(255, 90, 87, 87),
                child: Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: Text(
                    completed.toString(),
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                )),
          ),
          Expanded(
            flex: _getFlex(total - completed, total),
            child: Container(),
          ),
        ],
      ),
    );
  }
}
