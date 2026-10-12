import 'package:flutter_test/flutter_test.dart';
import 'package:hangman_flutter/core/utils/text_normalizer.dart';

void main() {
  group('TextNormalizer', () {
    test(
      'deve remover diacríticos e converter para maiúsculas corretamente',
      () {
        expect(TextNormalizer.normalize('Coração'), equals('CORACAO'));
        expect(TextNormalizer.normalize('pulmão'), equals('PULMAO'));
        expect(TextNormalizer.normalize('estômago'), equals('ESTOMAGO'));
        expect(
          TextNormalizer.normalize('QUATI SUL-AMERICANO'),
          equals('QUATI SUL-AMERICANO'),
        );
        expect(
          TextNormalizer.normalize('ÁÉÍÓÚàéíóúçãõ'),
          equals('AEIOUAEIOUCAO'),
        );
      },
    );

    test(
      'deve identificar corretamente se um caractere é uma letra alfabética',
      () {
        expect(TextNormalizer.isLetter('A'), isTrue);
        expect(TextNormalizer.isLetter('z'), isTrue);
        expect(TextNormalizer.isLetter('ç'), isTrue);
        expect(TextNormalizer.isLetter('Ã'), isTrue);
        expect(TextNormalizer.isLetter('é'), isTrue);

        expect(TextNormalizer.isLetter(' '), isFalse);
        expect(TextNormalizer.isLetter('-'), isFalse);
        expect(TextNormalizer.isLetter('_'), isFalse);
        expect(TextNormalizer.isLetter('1'), isFalse);
        expect(TextNormalizer.isLetter('!'), isFalse);
        expect(TextNormalizer.isLetter(''), isFalse);
      },
    );

    test(
      'deve verificar correspondência ignorando acentos e caixa alta/baixa',
      () {
        expect(TextNormalizer.matches('a', 'Á'), isTrue);
        expect(TextNormalizer.matches('A', 'ã'), isTrue);
        expect(TextNormalizer.matches('c', 'Ç'), isTrue);
        expect(TextNormalizer.matches('E', 'é'), isTrue);
        expect(TextNormalizer.matches('b', 'a'), isFalse);
        expect(TextNormalizer.matches('', 'a'), isFalse);
      },
    );
  });
}
