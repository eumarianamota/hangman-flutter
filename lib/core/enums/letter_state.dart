enum LetterState {
  unused,
  correct,
  incorrect;

  bool get isUsed => this != LetterState.unused;
}
