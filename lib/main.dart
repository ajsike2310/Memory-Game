import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MemoryGame());
}

class MemoryGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MemoryGameHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MemoryGameHome extends StatefulWidget {
  @override
  _MemoryGameHomeState createState() => _MemoryGameHomeState();
}

class _MemoryGameHomeState extends State<MemoryGameHome> {
  final List<String> _cards = ['A', 'A', 'B', 'B', 'C', 'C', 'D', 'D', 'E', 'E', 'F', 'F'];
  List<bool> _revealed = [];
  List<int> _selectedIndexes = [];
  int _moves = 0;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    _cards.shuffle();
    _revealed = List.filled(_cards.length, false);
    _selectedIndexes.clear();
    _moves = 0;
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
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      if (_cards[_selectedIndexes[0]] == _cards[_selectedIndexes[1]]) {
        // Cards stay revealed if matched
      } else {
        _revealed[_selectedIndexes[0]] = false;
        _revealed[_selectedIndexes[1]] = false;
      }
      _selectedIndexes.clear();
      _moves++;
      _isProcessing = false;
    });

    _checkGameCompletion();
  }

  void _checkGameCompletion() {
    if (_revealed.every((revealed) => revealed)) {
      String message;
      if (_moves <= 10) {
        message = 'You nailed it in just $_moves moves!';
      } else if (_moves <= 20) {
        message = 'You completed the game in $_moves moves.';
      } else {
        message = 'You made it in $_moves moves! Keep practising to improve.';
      }

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(
            'CONGRATS!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Icon(
                Icons.emoji_events,
                color: Colors.amber,
                size: 48,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: Text('Play Again'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  void _resetGame() {
    setState(() {
      _initializeGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Game'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Moves: $_moves', style: TextStyle(fontSize: 20)),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Adjust grid size
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _flipCard(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _revealed[index] ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        _revealed[index] ? _cards[index] : '',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _resetGame,
            child: Text('Restart Game'),
          ),
        ],
      ),
    );
  }
}