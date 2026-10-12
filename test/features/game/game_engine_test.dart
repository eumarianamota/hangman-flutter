import 'package:flutter_test/flutter_test.dart';
import 'package:hangman_flutter/core/enums/answer_category.dart';
import 'package:hangman_flutter/core/enums/difficulty.dart';
import 'package:hangman_flutter/core/enums/game_status.dart';
import 'package:hangman_flutter/features/game/domain/engine/game_engine.dart';
import 'package:hangman_flutter/features/game/domain/entities/answer_entry.dart';

void main() {
  group('GameEngine', () {
    late AnswerEntry singleWordAnswer;
    late AnswerEntry multiWordAnswer;
    late AnswerEntry hyphenAnswer;

    setUp(() {
      singleWordAnswer = const AnswerEntry(
        rawAnswer: 'CORAÇÃO',
        normalizedAnswer: 'CORACAO',
        category: AnswerCategory.humanBody,
        difficulty: Difficulty.easy,
        hints: ['Órgão que bombeia sangue.'],
      );

      multiWordAnswer = const AnswerEntry(
        rawAnswer: 'COLUNA VERTEBRAL',
        normalizedAnswer: 'COLUNA VERTEBRAL',
        category: AnswerCategory.humanBody,
        difficulty: Difficulty.medium,
        hints: ['Estrutura óssea que sustenta o tronco.'],
      );

      hyphenAnswer = const AnswerEntry(
        rawAnswer: 'QUATI SUL-AMERICANO',
        normalizedAnswer: 'QUATI SUL-AMERICANO',
        category: AnswerCategory.animals,
        difficulty: Difficulty.hard,
        hints: ['Pequeno mamífero das Américas.'],
      );
    });

    test('deve inicializar com valores padrão corretos', () {
      final engine = GameEngine(currentAnswer: singleWordAnswer);

      expect(engine.status, equals(GameStatus.playing));
      expect(engine.errorCount, equals(0));
      expect(engine.maxErrors, equals(6));
      expect(engine.remainingErrors, equals(6));
      expect(engine.hintUsed, isFalse);
      expect(engine.guessedLetters, isEmpty);
      expect(engine.isGameOver, isFalse);
    });

    test('deve revelar espaços e hífens automaticamente desde o início (RF03, RF06)', () {
      final engine = GameEngine(currentAnswer: hyphenAnswer);

      expect(engine.isCharRevealed(' '), isTrue);
      expect(engine.isCharRevealed('-'), isTrue);
      expect(engine.isCharRevealed('Q'), isFalse);
      expect(engine.isCharRevealed('A'), isFalse);

      // displayWord deve exibir os caracteres estruturais sem chutes do jogador
      expect(engine.displayWord, contains(' '));
      expect(engine.displayWord, contains('-'));
    });

    test('tentativa correta deve revelar todas as ocorrências e não gerar erro (RF05)', () {
      final engine = GameEngine(currentAnswer: multiWordAnswer);

      // 'A' ocorre em COLUNA e VERTEBRAL
      final result = engine.guessLetter('A');

      expect(result, isTrue);
      expect(engine.errorCount, equals(0));
      expect(engine.guessedLetters, contains('A'));
      expect(engine.isCharRevealed('A'), isTrue);
    });

    test('tentativa incorreta deve incrementar erro em 1 (RF05, RF07)', () {
      final engine = GameEngine(currentAnswer: singleWordAnswer);

      final result = engine.guessLetter('Z');

      expect(result, isFalse);
      expect(engine.errorCount, equals(1));
      expect(engine.remainingErrors, equals(5));
      expect(engine.guessedLetters, contains('Z'));
    });

    test(
      'tentativa repetida de letra já usada não deve gerar novo erro (RF05)',
      () {
        final engine = GameEngine(currentAnswer: singleWordAnswer);

        // Primeiro erro com 'Z'
        engine.guessLetter('Z');
        expect(engine.errorCount, equals(1));

        // Segundo chute com a mesma letra 'Z'
        final secondTry = engine.guessLetter('Z');
        expect(secondTry, isFalse);
        expect(engine.errorCount, equals(1)); // Erro permanece inalterado

        // Chute repetido de acerto com 'C'
        engine.guessLetter('C');
        expect(engine.errorCount, equals(1));
        final repeatedCorrect = engine.guessLetter('C');
        expect(repeatedCorrect, isFalse);
        expect(engine.errorCount, equals(1));
      },
    );

    test('deve ignorar acentuação na tentativa e preservar grafia original na exibição (RF06)', () {
      final engine = GameEngine(currentAnswer: singleWordAnswer); // 'CORAÇÃO'

      // Chutar 'A' sem acento deve acertar o 'Ã'
      final hitA = engine.guessLetter('a');
      expect(hitA, isTrue);
      expect(engine.isCharRevealed('Ã'), isTrue);

      // Chutar 'C' deve acertar tanto 'C' quanto 'Ç'
      final hitC = engine.guessLetter('c');
      expect(hitC, isTrue);
      expect(engine.isCharRevealed('Ç'), isTrue);

      // Na exibição original, o acento deve aparecer
      expect(engine.displayWord, contains('C'));
      expect(engine.displayWord, contains('Ç'));
      expect(engine.displayWord, contains('Ã'));
    });

    test(
      'deve atingir vitória quando todas as letras forem descobertas (RF10)',
      () {
        final engine = GameEngine(
          currentAnswer: singleWordAnswer,
        ); // 'CORAÇÃO' (letras: C, O, R, A)

        engine.guessLetter('C');
        engine.guessLetter('O');
        engine.guessLetter('R');
        engine.guessLetter('A');

        expect(engine.status, equals(GameStatus.won));
        expect(engine.isWon, isTrue);
        expect(engine.isGameOver, isTrue);
        expect(engine.displayWord, equals('CORAÇÃO'));
      },
    );

    test(
      'deve atingir derrota ao alcançar o limite máximo de 6 erros (RF11)',
      () {
        final engine = GameEngine(currentAnswer: singleWordAnswer); // 'CORAÇÃO'

        final wrongLetters = ['B', 'D', 'E', 'F', 'G', 'H'];
        for (final letter in wrongLetters) {
          engine.guessLetter(letter);
        }

        expect(engine.errorCount, equals(6));
        expect(engine.status, equals(GameStatus.lost));
        expect(engine.isLost, isTrue);
        expect(engine.isGameOver, isTrue);
      },
    );

    test('não deve aceitar tentativas após o encerramento da rodada', () {
      final engine = GameEngine(currentAnswer: singleWordAnswer);

      // Esgota tentativas
      for (final letter in ['B', 'D', 'E', 'F', 'G', 'H']) {
        engine.guessLetter(letter);
      }
      expect(engine.isLost, isTrue);

      // Tentativa de letra correta após derrota
      final tryAfterLost = engine.guessLetter('C');
      expect(tryAfterLost, isFalse);
      expect(engine.guessedLetters, isNot(contains('C')));
    });

    test('deve registrar uso de dica corretamente (RF09)', () {
      final engine = GameEngine(currentAnswer: singleWordAnswer);

      expect(engine.hintUsed, isFalse);
      final hint = engine.requestHint();

      expect(hint, equals('Órgão que bombeia sangue.'));
      expect(engine.hintUsed, isTrue);

      // Consulta repetida não desfaz nem altera
      final secondHint = engine.requestHint();
      expect(secondHint, equals('Órgão que bombeia sangue.'));
      expect(engine.hintUsed, isTrue);
    });

    test('deve permitir desistência através de forfeit() (RF15)', () {
      final engine = GameEngine(currentAnswer: singleWordAnswer);

      engine.forfeit();

      expect(engine.status, equals(GameStatus.lost));
      expect(engine.isLost, isTrue);
      expect(engine.isGameOver, isTrue);
    });
  });
}
