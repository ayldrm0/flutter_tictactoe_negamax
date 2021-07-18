import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var haveWinner = false;
  var output;
  var com = 0;
  var tier = 0;
  var you = 0;
  var filledSq = 0;
  var isMyTurn = true;
  var move;
  List gridViewText = List.filled(9, "");

  final scores = {"X": -10.0, "O": 10.0, "tie": 0.0};

  _onTap(int i) {
    if (isMyTurn && gridViewText[i] == "") {
      setState(() {
        gridViewText[i] = "X";
        isMyTurn = false;
        filledSq++;
        _whoWon("X", false);
      });
      if (!haveWinner) _comTapping();
    }
  }

  _comTapping() {
    negamax(gridViewText, 1);
    gridViewText[move] = "O";
    setState(() {
      isMyTurn = true;
      filledSq++;
      _whoWon("O", false);
    });
  }

  negamax(board, multiply) {
    var result;
    if (_whoWon("X", true) != null) {
      result = _whoWon("X", true);
    } else {
      result = _whoWon("O", true);
    }
    if (result != null) return multiply * scores[result];

    double bestScore = double.negativeInfinity;
    for (var i = 0; i < gridViewText.length; i++) {
      if (board[i] == "") {
        isMyTurn ? board[i] = "X" : board[i] = "O";
        filledSq++;
        isMyTurn = !isMyTurn;
        double score = -negamax(board, -multiply);
        board[i] = "";
        filledSq--;

        if (score >= bestScore) {
          bestScore = score;
          move = i;
        }
      }
    }

    return bestScore;
  }

  _whoWon(String letter, bool isSimulate) {
    if ((gridViewText[0] == "$letter" &&
            gridViewText[1] == "$letter" &&
            gridViewText[2] == "$letter") ||
        (gridViewText[3] == "$letter" &&
            gridViewText[4] == "$letter" &&
            gridViewText[5] == "$letter") ||
        (gridViewText[6] == "$letter" &&
            gridViewText[7] == "$letter" &&
            gridViewText[8] == "$letter") ||
        (gridViewText[0] == "$letter" &&
            gridViewText[3] == "$letter" &&
            gridViewText[6] == "$letter") ||
        (gridViewText[1] == "$letter" &&
            gridViewText[4] == "$letter" &&
            gridViewText[7] == "$letter") ||
        (gridViewText[2] == "$letter" &&
            gridViewText[5] == "$letter" &&
            gridViewText[8] == "$letter") ||
        (gridViewText[0] == "$letter" &&
            gridViewText[4] == "$letter" &&
            gridViewText[8] == "$letter") ||
        (gridViewText[2] == "$letter" &&
            gridViewText[4] == "$letter" &&
            gridViewText[6] == "$letter")) {
      if (letter == "X" && !isSimulate) {
        haveWinner = true;
        output = "You won!";
        you++;
      } else if (letter == "X" && isSimulate) {
        return "X";
      }
      if (letter == "O" && !isSimulate) {
        haveWinner = true;
        output = "Computer won!";
        com++;
      } else if (letter == "O" && isSimulate) {
        return "O";
      }
      return;
    } else if (filledSq == 9 && !isSimulate) {
      haveWinner = true;
      output = "Tier!";
      tier++;
    } else if (filledSq == 9 && isSimulate) {
      return "tie";
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData().copyWith(
        primaryColor: Colors.amber,
        accentColor: Colors.deepPurple,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
          ),
        ),
      ),
      home: Scaffold(
        backgroundColor: Colors.amber,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                "Tic-Tac-Toe",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              height: 300,
              width: 300,
              child: Stack(
                children: [
                  Image.network(
                    "https://upload.wikimedia.org/wikipedia/commons/6/64/Tic-tac-toe.png",
                  ),
                  GridView(
                    primary: true,
                    physics: new NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    children: List.generate(
                      9,
                      (index) => InkResponse(
                        enableFeedback: true,
                        child: Center(
                          child: Text(
                            gridViewText[index],
                            style: TextStyle(
                                fontSize: 60, fontWeight: FontWeight.bold),
                          ),
                        ),
                        onTap: isMyTurn ? () => _onTap(index) : null,
                      ),
                    ),
                  ),
                  haveWinner
                      ? Center(
                          child: Text(
                            output,
                            style: TextStyle(
                                fontSize: 35,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                backgroundColor: Colors.black38),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Com: $com",
                ),
                Text("Tier: $tier"),
                Text("You: $you")
              ],
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  gridViewText = List.filled(9, "");
                  isMyTurn = true;
                  filledSq = 0;
                  haveWinner = false;
                });
              },
              child: Text("New Game"),
              style: Theme.of(context).elevatedButtonTheme.style,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  gridViewText = List.filled(9, "");
                  isMyTurn = true;
                  com = 0;
                  you = 0;
                  tier = 0;
                  filledSq = 0;
                  haveWinner = false;
                });
              },
              child: Text("Reset Game"),
              style: Theme.of(context).elevatedButtonTheme.style,
            ),
          ],
        ),
      ),
    );
  }
}
