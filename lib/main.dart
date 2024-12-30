import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MemoryGame());
}

class MemoryGame extends StatelessWidget {
  const MemoryGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MemoryGameHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MemoryGameHome extends StatefulWidget {
  const MemoryGameHome({super.key});

  @override
  _MemoryGameHomeState createState() => _MemoryGameHomeState();
}

class _MemoryGameHomeState extends State<MemoryGameHome> {
  final List<String> _cards = [
    'image1.jpg', 'image1.jpg',
    'image2.jpg', 'image2.jpg',
    'image3.jpg', 'image3.jpg',
    'image4.jpg', 'image4.jpg',
    'image5.jpg', 'image5.jpg',
    'image6.jpg', 'image6.jpg',
  ];

  late List<bool> _revealed = List.filled(_cards.length, false);
  final List<int> _selectedIndexes = [];
  int _moves = 0;
  bool _isProcessing = false;
  String _playerName = '';
  late SharedPreferences _prefs;
  Map<String, int> _leaderboard = {};

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    _prefs = await SharedPreferences.getInstance();
    _leaderboard = Map<String, int>.from(
      _prefs.getKeys().fold<Map<String, int>>({}, (map, key) {
        if (key.startsWith('highScore_')) {
          map[key.substring(10)] = _prefs.getInt(key)!;
        }
        return map;
      }),
    );
    _askPlayerName();
  }

  void _startGame() {
    setState(() {
      _cards.shuffle();
      _revealed = List.filled(_cards.length, true);
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _revealed = List.filled(_cards.length, false);
      });
    });
  }

  void _flipCard(int index) {
    if (_isProcessing || _revealed[index] || _selectedIndexes.length >= 2) {
      return;
    }

    setState(() {
      _revealed[index] = true;
      _selectedIndexes.add(index);
    });

    if (_selectedIndexes.length == 2) {
      _checkMatch();
    }
  }

  void _checkMatch() async {
    _isProcessing = true;
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      if (_cards[_selectedIndexes[0]] == _cards[_selectedIndexes[1]]) {
        // Match found, leave cards revealed
      } else {
        _revealed[_selectedIndexes[0]] = false;
        _revealed[_selectedIndexes[1]] = false;
      }
      _selectedIndexes.clear();
      _moves++;
      _isProcessing = false;
    });

    if (_revealed.every((element) => element)) {
      _gameOver();
    }
  }

  void _gameOver() async {
    if (!_prefs.containsKey('highScore$_playerName') ||
        _moves < _prefs.getInt('highScore$_playerName')!) {
      await _prefs.setInt('highScore$_playerName', _moves);
      setState(() {
        _leaderboard[_playerName] = _moves;
      });
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('You completed the game in $_moves moves!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _restartGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  void _restartGame() {
    setState(() {
      _moves = 0;
      _selectedIndexes.clear();
      _revealed = List.filled(_cards.length, false);
    });
    _askPlayerName();
  }

  void _askPlayerName() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Enter Your Name'),
        content: TextField(
          onChanged: (value) {
            _playerName = value;
          },
          decoration: const InputDecoration(hintText: 'Name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_playerName.isNotEmpty) {
                Navigator.of(context).pop();
                _startGame();
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Error'),
                    content: const Text('Name cannot be blank!'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }

  void _clearLeaderboard() async {
    for (String key in _prefs.getKeys().where((key) => key.startsWith('highScore'))) {
      await _prefs.remove(key);
    }

    setState(() {
      _leaderboard.clear();
    });
  }

  List<MapEntry<String, int>> _sortedLeaderboard() {
    List<MapEntry<String, int>> sortedList = _leaderboard.entries.toList();
    sortedList.sort((a, b) => a.value.compareTo(b.value));
    return sortedList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Game'),
        centerTitle: true,
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('Player: $_playerName', style: const TextStyle(fontSize: 20)),
                        Text('Moves: $_moves', style: const TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                  Container(
                    width: 300,
                    height: 400,
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: _cards.length,
                      itemBuilder: (context, index) {
                        return FlipCard(
                          isRevealed: _revealed[index],
                          onTap: () => _flipCard(index),
                          imagePath: 'assets/images/${_cards[index]}',
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _restartGame,
                    child: const Text('Restart Game'),
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(width: 1, color: Colors.grey),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Leaderboard', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: ListView(
                    children: _sortedLeaderboard()
                        .map((entry) => ListTile(
                              title: Text(entry.key),
                              trailing: Text('${entry.value} moves'),
                            ))
                        .toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _clearLeaderboard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Clear Leaderboard'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FlipCard extends StatelessWidget {
  final bool isRevealed;
  final VoidCallback onTap;
  final String imagePath;

  const FlipCard({
    super.key,
    required this.isRevealed,
    required this.onTap,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isRevealed ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isRevealed ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: isRevealed
            ? Image.asset(
                imagePath,
                fit: BoxFit.cover,
              )
            : null,
      ),
    );
  }
}