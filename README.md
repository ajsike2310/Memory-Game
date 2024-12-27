<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Memory Game</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      line-height: 1.6;
      margin: 0;
      padding: 0 20px;
      background-color: #f8f9fa;
    }
    h1, h2, h3 {
      color: #333;
    }
    ul {
      margin: 10px 0;
      padding: 0 20px;
    }
    pre {
      background: #f4f4f4;
      padding: 10px;
      border-left: 3px solid #007bff;
      overflow-x: auto;
    }
    code {
      color: #d63384;
    }
    .screenshot {
      margin-top: 20px;
    }
    .screenshot img {
      max-width: 100%;
      border: 1px solid #ddd;
      border-radius: 4px;
    }
  </style>
</head>
<body>
  <h1>Memory Game</h1>
  <p>A simple and fun Memory Game developed using <strong>Flutter</strong>. This game challenges the player's memory by matching pairs of cards in the fewest moves possible.</p>

  <h2>Features</h2>
  <ul>
    <li>Interactive and user-friendly interface.</li>
    <li>Tracks the number of moves taken by the player.</li>
    <li>Displays congratulatory messages based on the performance.</li>
    <li>Allows players to restart the game at any time.</li>
  </ul>

  <h2>Screenshots</h2>
  <div class="screenshot">
    <!-- Add your screenshots below -->
    <img src="screenshot1.png" alt="Game Screenshot 1">
    <img src="screenshot2.png" alt="Game Screenshot 2">
  </div>

  <h2>Installation and Setup</h2>
  <ol>
    <li>Ensure you have Flutter installed on your system. For installation instructions, refer to the <a href="https://flutter.dev/docs/get-started/install" target="_blank">official Flutter documentation</a>.</li>
    <li>Clone this repository:
      <pre><code>git clone https://github.com/&lt;your-username&gt;/memory_game.git</code></pre>
    </li>
    <li>Navigate to the project directory:
      <pre><code>cd memory_game</code></pre>
    </li>
    <li>Get the required dependencies:
      <pre><code>flutter pub get</code></pre>
    </li>
    <li>Run the app:
      <pre><code>flutter run</code></pre>
    </li>
  </ol>

  <h2>Gameplay</h2>
  <ol>
    <li>The game starts with a shuffled set of cards.</li>
    <li>Tap on a card to reveal it.</li>
    <li>Match pairs of cards by remembering their positions.</li>
    <li>The game tracks the number of moves taken.</li>
    <li>A congratulatory message is shown once all pairs are matched.</li>
  </ol>

  <h2>Code Overview</h2>
  <p>The game logic is implemented in the <code>MemoryGameHome</code> widget, which uses the following key components:</p>
  <ul>
    <li><strong>State Management:</strong> Maintains the revealed state of each card and tracks the number of moves.</li>
    <li><strong>GridView:</strong> Displays the cards in a grid format.</li>
    <li><strong>Dialog:</strong> Shows a congratulatory message upon completing the game.</li>
  </ul>

  <h2>How It Works</h2>
  <ol>
    <li>The cards are shuffled and initialized at the start of the game.</li>
    <li>On tapping a card, it is flipped to reveal its content.</li>
    <li>If two selected cards match, they remain revealed. Otherwise, they are flipped back after a brief delay.</li>
    <li>The game checks for completion and displays an appropriate message.</li>
  </ol>

  <h2>Customization</h2>
  <ul>
    <li><strong>Card Content:</strong> Modify the <code>_cards</code> list to include different pairs or more pairs for increased difficulty.</li>
    <li><strong>Grid Size:</strong> Adjust the <code>crossAxisCount</code> in the <code>GridView.builder</code> to change the number of columns in the grid.</li>
  </ul>

  <h2>Contributing</h2>
  <p>Contributions are welcome! If you have ideas to improve the game or fix bugs, feel free to open a pull request.</p>

  <h2>License</h2>
  <p>This project is licensed under the <a href="LICENSE">MIT License</a>.</p>

  <h2>Acknowledgments</h2>
  <p>Developed using the amazing Flutter framework. Thanks to the Flutter community for their resources and support.</p>
</body>
</html>
