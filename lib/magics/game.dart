
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';


class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  int scoreX = 0;
  int scoreO = 0;
  bool turnOfO = false;
  String PlayersChoice = '';
  String opponent = '';
  int filledBoxes = 0;
  List<String> xOrOList = [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  ];
  bool playerSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Center(
          child: Text('Tic Tac Toe',
              style: TextStyle(fontFamily: 'font2', fontSize: 40,)),
        ),
        backgroundColor: const Color.fromRGBO(190, 201, 223, 20),
        actions: [
          IconButton(
            onPressed: () {
              clearBoard();
            },
            icon: const Icon(
              Icons.refresh,
            ),
          )
        ],
      ),
      backgroundColor: const Color.fromRGBO(22, 78, 99, 20),
      body: playerSelected
          ? Column(
        children: [
          buildPointsTable(),
          buildGrid(),
          buildTurn(),
        ],
      )
          : buildPlayerSelection(),
    );
  }

  Widget buildPlayerSelection() {
    return BounceInDown(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              '       Welcome \nTo Tic - Tac - Toe',
              style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'font2',
                  color: Colors.white,
                 // fontWeight: FontWeight.bold
              ),
            ),
          ),
          SizedBox(
            height: 30,
            width: 20,
          ),
          Center(
            child: Text(
              'Select Your Symbol',
              style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'font6',
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 30,
            width: 20,
          ),
          Center(
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    PlayersChoice = 'X';
                    opponent = 'O';
                    playerSelected = true;
                  });
                },
                child: const Text(
                  'Symbol X',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontFamily: 'font9',
                  ),
                )),
          ),
          SizedBox(
            height: 30,
            width: 20,
          ),
          Center(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  PlayersChoice = 'O';
                  opponent = 'X';
                  playerSelected = true;
                });
              },
              child: const Text(
                'Symbol O',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontFamily: 'font9',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGrid() {
    return Expanded(
      flex: 3,
      child: ZoomIn(
        child: GridView.builder(
          itemCount: xOrOList.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                tappedIndex(index);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: Center(
                  child: Text(
                    xOrOList[index],
                    style: TextStyle(
                      color: xOrOList[index] == "X" ? Colors.white : Colors.red,
                      fontSize: 40,
                      fontFamily: 'font6',
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void tappedIndex(int index) {
    setState(() {
      if (turnOfO && xOrOList[index] == '') {
        xOrOList[index] = 'O';
        filledBoxes += 1;
      } else if (!turnOfO && xOrOList[index] == '') {
        xOrOList[index] = 'X';
        filledBoxes += 1;
      }
      turnOfO = !turnOfO;
      checkWinner();
    });
  }

  Widget buildTurn() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          turnOfO ? 'Turn Of O' : 'Turn of X',
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'font12',
            fontSize: 25,
          ),
        ),
      ),
    );
  }

  void clearBoard() {
    setState(() {
      for (var i = 0; i < xOrOList.length; i++) {
        xOrOList[i] = '';
      }
      filledBoxes = 0;
    });
  }

  Widget buildPointsTable() {
    return Expanded(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Your Choice : $PlayersChoice',
                    style: const TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                      fontFamily: 'font1',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    PlayersChoice == 'X'
                        ? scoreX.toString()
                        : scoreO.toString(),
                    style: const TextStyle(
                      fontSize: 25.0,
                      color: Colors.white,
                      fontFamily: 'font1',
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Opponent : $opponent',
                    style: const TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                      fontFamily: 'font1',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    opponent == 'O' ? scoreO.toString() : scoreX.toString(),
                    style: const TextStyle(
                      fontSize: 25.0,
                      color: Colors.white,
                      fontFamily: 'font1',
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void checkWinner() {
    // Checking first row
    if (xOrOList[0] == xOrOList[1] &&
        xOrOList[0] == xOrOList[2] &&
        xOrOList[0] != '') {
      showWinDialog(context, 'You win', xOrOList[0]);
      return;
    }

    // Checking second row
    if (xOrOList[3] == xOrOList[4] &&
        xOrOList[3] == xOrOList[5] &&
        xOrOList[3] != '') {
      showWinDialog(context, 'You win', xOrOList[3]);
      return;
    }

    // Checking third row
    if (xOrOList[6] == xOrOList[7] &&
        xOrOList[6] == xOrOList[8] &&
        xOrOList[6] != '') {
      showWinDialog(context, 'You win', xOrOList[6]);
      return;
    }

    // Checking first column
    if (xOrOList[0] == xOrOList[3] &&
        xOrOList[0] == xOrOList[6] &&
        xOrOList[0] != '') {
      showWinDialog(context, 'You win', xOrOList[0]);
      return;
    }

    // Checking second column
    if (xOrOList[1] == xOrOList[4] &&
        xOrOList[1] == xOrOList[7] &&
        xOrOList[1] != '') {
      showWinDialog(context, 'You win', xOrOList[1]);
      return;
    }

    // Checking third column
    if (xOrOList[2] == xOrOList[5] &&
        xOrOList[2] == xOrOList[8] &&
        xOrOList[2] != '') {
      showWinDialog(context, 'You win', xOrOList[2]);
      return;
    }

    // Checking diagonal
    if (xOrOList[0] == xOrOList[4] &&
        xOrOList[0] == xOrOList[8] &&
        xOrOList[0] != '') {
      showWinDialog(context, 'You win', xOrOList[0]);
      return;
    }

    // Checking diagonal
    if (xOrOList[2] == xOrOList[4] &&
        xOrOList[2] == xOrOList[6] &&
        xOrOList[2] != '') {
      showWinDialog(context, 'You win', xOrOList[2]);
      return;
    }

    if (filledBoxes == xOrOList.length) {
      showDrawDialog(context);
    }
  }

  void showWinDialog(BuildContext context, String winner, String winnerChoice) {
    final isPlayerWinner = winnerChoice == PlayersChoice;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Colors.white,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPlayerWinner ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                size: 60,
                color: isPlayerWinner ? Colors.green : Colors.red,
              ),
              SizedBox(height: 20),
              Text(
                isPlayerWinner ? 'Congratulations!' : 'Sorry!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isPlayerWinner ? Colors.green : Colors.red,
                ),
              ),
              SizedBox(height: 10),
              Text(
                isPlayerWinner
                    ? 'You win! Well done!'
                    : 'You lose! Better luck next time.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    if (isPlayerWinner) {
                      if (PlayersChoice == 'X') {
                        scoreX++;
                      } else {
                        scoreO++;
                      }
                    } else {
                      if (PlayersChoice == 'X') {
                        scoreO++;
                      } else {
                        scoreX++;
                      }
                    }
                    clearBoard();
                  });
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDrawDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Colors.white,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.schedule,
                size: 60,
                color: Colors.orange,
              ),
              SizedBox(height: 20),
              Text(
                'It\'s a Draw!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'No winner this time.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    clearBoard();
                  });
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }}