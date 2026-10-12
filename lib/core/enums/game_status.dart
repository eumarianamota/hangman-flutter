/// Representa os estados mutuamente exclusivos de uma rodada do jogo da forca.
enum GameStatus {
  /// Rodada em andamento; o jogador ainda possui tentativas e letras restantes.
  playing,

  /// O jogador venceu ao descobrir todas as letras antes do limite de erros.
  won,

  /// O jogador foi derrotado ao atingir o limite máximo de erros ou por desistência.
  lost;

  /// Indica se a rodada atual já foi encerrada (vitória ou derrota).
  bool get isGameOver => this != GameStatus.playing;
}
