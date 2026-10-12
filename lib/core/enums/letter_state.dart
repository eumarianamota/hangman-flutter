/// Representa os possíveis estados visuais de uma tecla do teclado virtual.
enum LetterState {
  /// Letra disponível para tentativa; ainda não foi acionada pelo jogador.
  unused,

  /// Letra já tentada e que pertence à palavra secreta (acerto).
  correct,

  /// Letra já tentada e que não pertence à palavra secreta (erro).
  incorrect;

  /// Retorna `true` se a letra já tiver sido utilizada nesta rodada.
  bool get isUsed => this != LetterState.unused;
}
