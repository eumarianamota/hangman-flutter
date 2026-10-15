enum GameStatus {
  playing,
  won,
  lost;

  bool get isGameOver => this != GameStatus.playing;
}
