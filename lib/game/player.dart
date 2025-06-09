class Player {

  final String name;
  int _score = 0;

  Player({required this.name});

  int get score => _score;

  void increaseScore() {
    _score += 100;
  }

  void resetScore() => _score = 0;
}