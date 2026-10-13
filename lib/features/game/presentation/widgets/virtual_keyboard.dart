import 'package:flutter/material.dart';

import '../../../../core/enums/letter_state.dart';

/// Teclado virtual interativo em grade alfabética de A a Z.
///
/// Atende ao RF05 e RF06:
/// - Disponibiliza exclusivamente letras de 'A' a 'Z';
/// - Cada tecla reflete seu estado visual através do [LetterState] (unused, correct, incorrect);
/// - Teclas já utilizadas são desabilitadas para impedir novas tentativas.
class VirtualKeyboard extends StatelessWidget {
  const VirtualKeyboard({
    super.key,
    required this.onLetterPressed,
    required this.getLetterState,
  });

  /// Callback acionado quando uma letra válida e ainda não utilizada é pressionada.
  final ValueChanged<String> onLetterPressed;

  /// Função que fornece o [LetterState] atual de uma letra fornecida.
  final LetterState Function(String letter) getLetterState;

  // Letras do alfabeto organizadas em 4 linhas ergonômicas
  static const List<List<String>> _keyboardRows = [
    ['A', 'B', 'C', 'D', 'E', 'F', 'G'],
    ['H', 'I', 'J', 'K', 'L', 'M', 'N'],
    ['O', 'P', 'Q', 'R', 'S', 'T', 'U'],
    ['V', 'W', 'X', 'Y', 'Z'],
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _keyboardRows
            .map((row) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: row
                      .map((letter) {
                        final state = getLetterState(letter);
                        return _KeyButton(
                          letter: letter,
                          state: state,
                          onPressed: state == LetterState.unused
                              ? () => onLetterPressed(letter)
                              : null,
                        );
                      })
                      .toList(growable: false),
                ),
              );
            })
            .toList(growable: false),
      ),
    );
  }
}

class _KeyButton extends StatelessWidget {
  const _KeyButton({
    required this.letter,
    required this.state,
    required this.onPressed,
  });

  final String letter;
  final LetterState state;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    // Definição de cores conforme o estado da letra
    final (bgColor, borderColor, textColor, textDecoration) = switch (state) {
      LetterState.unused => (
        const Color(0xFFFFFFFF),
        const Color(0xFFBDC3C7),
        const Color(0xFF2C3E50),
        TextDecoration.none,
      ),
      LetterState.correct => (
        const Color(0xFFE8F8F5),
        const Color(0xFF27AE60),
        const Color(0xFF27AE60),
        TextDecoration.none,
      ),
      LetterState.incorrect => (
        const Color(0xFFFDEDEC),
        const Color(0xFFE74C3C),
        const Color(0xFF95A5A6),
        TextDecoration.lineThrough,
      ),
    };

    return Container(
      width: 42,
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 2.5),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.0),
        elevation: state == LetterState.unused ? 1.5 : 0.0,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: borderColor,
                width: state == LetterState.unused ? 1.2 : 1.8,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              letter,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
                decoration: textDecoration,
                decorationColor: const Color(0xFFE74C3C),
                decorationThickness: 2.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
