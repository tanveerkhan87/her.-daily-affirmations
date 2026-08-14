import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared/widgets/her_app_bar.dart';

/// Tic Tac Toe mini-game.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _scoreX = 0;
  int _scoreO = 0;
  bool _turnOfO = false;
  int _filledBoxes = 0;
  String _playerSymbol = '';
  String _opponentSymbol = '';
  bool _playerSelected = false;
  final List<String> _board = List.filled(9, '');

  void _clearBoard() => setState(() {
        _board.fillRange(0, 9, '');
        _filledBoxes = 0;
      });

  void _tap(int index) {
    if (_board[index].isNotEmpty) return;
    setState(() {
      _board[index] = _turnOfO ? 'O' : 'X';
      _filledBoxes++;
      _turnOfO = !_turnOfO;
      _checkWinner();
    });
  }

  void _checkWinner() {
    const wins = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6],
    ];
    for (final w in wins) {
      if (_board[w[0]].isNotEmpty && _board[w[0]] == _board[w[1]] && _board[w[1]] == _board[w[2]]) {
        _showResult(_board[w[0]] == _playerSymbol);
        return;
      }
    }
    if (_filledBoxes == 9) _showDraw();
  }

  void _showResult(bool playerWon) {
    _showGameDialog(
      icon: playerWon ? Icons.emoji_events : Icons.sentiment_dissatisfied,
      iconColor: playerWon ? AppColors.success : AppColors.error,
      title: playerWon ? 'Congratulations!' : 'Sorry!',
      message: playerWon ? 'You win! Well done!' : 'You lose! Better luck next time.',
      onOk: () {
        setState(() {
          if (playerWon) {
            _playerSymbol == 'X' ? _scoreX++ : _scoreO++;
          } else {
            _playerSymbol == 'X' ? _scoreO++ : _scoreX++;
          }
          _clearBoard();
        });
      },
    );
  }

  void _showDraw() {
    _showGameDialog(
      icon: Icons.schedule,
      iconColor: AppColors.warning,
      title: "It's a Draw!",
      message: 'No winner this time.',
      onOk: () => setState(() => _clearBoard()),
    );
  }

  void _showGameDialog({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    required VoidCallback onOk,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: iconColor),
            const SizedBox(height: 16),
            Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: iconColor)),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () { Navigator.pop(context); onOk(); },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HerAppBar(
        title: 'Tic Tac Toe',
        actions: [
          if (_playerSelected)
            IconButton(onPressed: _clearBoard, icon: const Icon(Icons.refresh_rounded)),
        ],
      ),
      body: _playerSelected ? _buildGame() : _buildSelection(),
    );
  }

  Widget _buildSelection() {
    return BounceInDown(
      child: Center(
        child: Padding(
          padding: AppSpacing.paddingAllLg,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Welcome!', style: GoogleFonts.montserratAlternates(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Select Your Symbol', style: GoogleFonts.lato(fontSize: 18, color: Colors.grey)),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SymbolButton(symbol: 'X', onTap: () => _selectSymbol('X')),
                  const SizedBox(width: 24),
                  _SymbolButton(symbol: 'O', onTap: () => _selectSymbol('O')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectSymbol(String s) => setState(() {
        _playerSymbol = s;
        _opponentSymbol = s == 'X' ? 'O' : 'X';
        _playerSelected = true;
      });

  Widget _buildGame() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // ─── Score Board ────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ScoreCard(label: 'You ($_playerSymbol)', score: _playerSymbol == 'X' ? _scoreX : _scoreO),
              _ScoreCard(label: 'Opponent ($_opponentSymbol)', score: _opponentSymbol == 'X' ? _scoreX : _scoreO),
            ],
          ),
        ),
        // ─── Board ──────────────────────────
        Expanded(
          child: ZoomIn(
            child: GridView.builder(
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemCount: 9,
              itemBuilder: (_, i) => GestureDetector(
                onTap: () => _tap(i),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: isDark ? Colors.white24 : Colors.grey.shade300),
                  ),
                  child: Center(
                    child: Text(
                      _board[i],
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: _board[i] == 'X' ? AppColors.accent : AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        // ─── Turn Indicator ─────────────────
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            _turnOfO ? 'Turn of O' : 'Turn of X',
            style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class _SymbolButton extends StatelessWidget {
  final String symbol;
  final VoidCallback onTap;

  const _SymbolButton({required this.symbol, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        side: BorderSide(color: AppColors.primary),
      ),
      child: Text(symbol, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final String label;
  final int score;

  const _ScoreCard({required this.label, required this.score});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text('$score', style: GoogleFonts.montserrat(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary)),
      ],
    );
  }
}
