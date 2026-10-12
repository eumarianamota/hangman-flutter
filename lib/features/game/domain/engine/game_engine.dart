import '../../../../core/enums/game_status.dart';
import '../../../../core/utils/text_normalizer.dart';
import '../entities/answer_entry.dart';

/// Motor central de regras de negócio do Jogo da Forca em Dart puro.
///
/// Encapsula a máquina de estados da partida, controle de tentativas de letras,
/// contagem de falhas, consumo de dicas, validação de vitória e derrota,
/// e suporte a expressões com múltiplas palavras e caracteres estruturais.
class GameEngine {
  /// Cria uma nova instância de [GameEngine] para a resposta fornecida.
  GameEngine({required this.currentAnswer, this.maxErrors = 6})
    : assert(maxErrors > 0, 'maxErrors deve ser maior que zero.'),
      _guessedLetters = <String>{},
      _errorCount = 0,
      _hintUsed = false,
      _status = GameStatus.playing;

  /// A resposta da partida atual.
  final AnswerEntry currentAnswer;

  /// Limite máximo de erros permitidos antes da derrota (padrão: 6).
  final int maxErrors;

  final Set<String> _guessedLetters;
  int _errorCount;
  bool _hintUsed;
  GameStatus _status;

  /// Conjunto imutável de letras já tentadas pelo jogador (normalizadas em caixa alta).
  Set<String> get guessedLetters => Set.unmodifiable(_guessedLetters);

  /// Quantidade atual de erros cometidos na rodada.
  int get errorCount => _errorCount;

  /// Indica se a dica foi consultada durante a rodada.
  bool get hintUsed => _hintUsed;

  /// Estado atual da partida ([GameStatus.playing], [GameStatus.won], [GameStatus.lost]).
  GameStatus get status => _status;

  /// Quantidade de erros restantes antes da derrota.
  int get remainingErrors => maxErrors - _errorCount;

  /// Indica se o jogador venceu a rodada.
  bool get isWon => _status == GameStatus.won;

  /// Indica se o jogador foi derrotado.
  bool get isLost => _status == GameStatus.lost;

  /// Indica se a rodada atual já terminou.
  bool get isGameOver => _status.isGameOver;

  /// Realiza uma tentativa com a [letter] escolhida pelo jogador.
  ///
  /// Regras de negócio atendidas:
  /// - Se a partida já estiver encerrada, ignora e retorna `false`.
  /// - Apenas letras alfabéticas (A-Z) constituem tentativas válidas (RF05).
  /// - A comparação ignora acentuação (RF06).
  /// - Letras repetidas não geram novos erros nem alteram o estado (RF05).
  /// - Letra correta revela todas as ocorrências na expressão completa (RF05).
  /// - Letra incorreta contabiliza exatamente 1 erro (RF05, RF07).
  /// - Atingir [maxErrors] transiciona o status para [GameStatus.lost] (RF11).
  /// - Revelar todas as letras alfabéticas transiciona o status para [GameStatus.won] (RF10).
  ///
  /// Retorna `true` se a tentativa foi um acerto, ou `false` se foi erro/inválida.
  bool guessLetter(String letter) {
    if (isGameOver) return false;
    if (!TextNormalizer.isLetter(letter)) return false;

    final normalized = TextNormalizer.normalizeChar(letter);

    // Letra já utilizada anteriormente: não gera novo erro nem duplica
    if (_guessedLetters.contains(normalized)) {
      return false;
    }

    _guessedLetters.add(normalized);

    final isCorrect = currentAnswer.normalizedAnswer.contains(normalized);

    if (isCorrect) {
      if (_checkVictoryCondition()) {
        _status = GameStatus.won;
      }
      return true;
    } else {
      _errorCount++;
      if (_errorCount >= maxErrors) {
        _status = GameStatus.lost;
      }
      return false;
    }
  }

  /// Registra o uso da dica e retorna o texto da primeira dica disponível.
  ///
  /// O uso é computado apenas uma vez por rodada nas estatísticas da sessão (RF09).
  String? requestHint() {
    _hintUsed = true;
    if (currentAnswer.hints.isEmpty) return null;
    return currentAnswer.hints.first;
  }

  /// Força a desistência da partida em andamento (RF15).
  ///
  /// Se a partida estiver em andamento, define o status como [GameStatus.lost].
  void forfeit() {
    if (_status == GameStatus.playing) {
      _status = GameStatus.lost;
    }
  }

  /// Verifica se um caractere específico da resposta deve ser revelado na interface.
  ///
  /// - Espaços, hífens e pontuações retornam sempre `true` desde o início (RF03, RF06).
  /// - Letras retornam `true` se já tiverem sido adivinhadas pelo jogador.
  bool isCharRevealed(String char) {
    if (!TextNormalizer.isLetter(char)) {
      return true;
    }
    return _guessedLetters.contains(TextNormalizer.normalizeChar(char));
  }

  /// Retorna a representação textual formatada da palavra para exibição simples.
  ///
  /// Caracteres não revelados aparecem como `_`, enquanto espaços, hífens e letras
  /// descobertas mantêm sua grafia original com acento (RF06).
  String get displayWord {
    final buffer = StringBuffer();
    for (var i = 0; i < currentAnswer.rawAnswer.length; i++) {
      final char = currentAnswer.rawAnswer[i];
      if (isCharRevealed(char)) {
        buffer.write(char);
      } else {
        buffer.write('_');
      }
    }
    return buffer.toString();
  }

  /// Verifica se todas as letras alfabéticas da resposta já foram adivinhadas.
  bool _checkVictoryCondition() {
    for (var i = 0; i < currentAnswer.rawAnswer.length; i++) {
      final char = currentAnswer.rawAnswer[i];
      if (TextNormalizer.isLetter(char)) {
        final normalized = TextNormalizer.normalizeChar(char);
        if (!_guessedLetters.contains(normalized)) {
          return false;
        }
      }
    }
    return true;
  }
}
