import 'package:flutter/material.dart';

import '../../../../core/enums/letter_state.dart';
import '../../../../core/utils/text_normalizer.dart';
import '../../domain/engine/game_engine.dart';
import '../../domain/entities/answer_entry.dart';
import '../widgets/hangman_display.dart';
import '../widgets/virtual_keyboard.dart';
import '../widgets/word_display.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.answer,
    this.engine,
    this.onGameFinished,
    this.onForfeit,
  });

  final AnswerEntry answer;
  final GameEngine? engine;
  final void Function(BuildContext context, GameEngine engine)? onGameFinished;
  final VoidCallback? onForfeit;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameEngine _engine;

  @override
  void initState() {
    super.initState();
    _engine = widget.engine ?? GameEngine(currentAnswer: widget.answer);
  }

  void _onLetterPressed(String letter) {
    if (_engine.isGameOver) return;

    setState(() {
      _engine.guessLetter(letter);
    });

    if (_engine.isGameOver && widget.onGameFinished != null) {
      widget.onGameFinished!(context, _engine);
    }
  }

  LetterState _getLetterState(String letter) {
    final normalized = TextNormalizer.normalizeChar(letter);
    if (!_engine.guessedLetters.contains(normalized)) {
      return LetterState.unused;
    }
    if (_engine.currentAnswer.normalizedAnswer.contains(normalized)) {
      return LetterState.correct;
    }
    return LetterState.incorrect;
  }

  Future<void> _showHintDialog() async {
    final hint = _engine.requestHint();
    setState(() {}); // Atualiza o estado da dica se necessário

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFDFBF7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: const BorderSide(color: Color(0xFFE0D7C6), width: 2.0),
          ),
          title: const Row(
            children: [
              Icon(Icons.lightbulb_rounded, color: Color(0xFFF39C12)),
              SizedBox(width: 8),
              Text(
                'Dica da Rodada',
                style: TextStyle(
                  color: Color(0xFF2C3E50),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            hint ?? 'Nenhuma dica disponível para esta resposta.',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF34495E),
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Entendido',
                style: TextStyle(
                  color: Color(0xFF2C3E50),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showForfeitDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFDFBF7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: const BorderSide(color: Color(0xFFE74C3C), width: 1.5),
          ),
          title: const Text(
            'Desistir da Partida?',
            style: TextStyle(
              color: Color(0xFF2C3E50),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Se você sair agora, a partida será contabilizada como derrota nas estatísticas da sessão.',
            style: TextStyle(color: Color(0xFF34495E), height: 1.3),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Continuar Jogando'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE74C3C),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirmar Desistência'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<void> _handleBackPress() async {
    if (_engine.isGameOver) {
      Navigator.of(context).pop();
      return;
    }
    await _handlePop();
  }

  Future<void> _handlePop() async {
    final confirmed = await _showForfeitDialog();
    if (!mounted) return;
    if (confirmed) {
      _engine.forfeit();
      widget.onForfeit?.call();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    const paperBackground = Color(0xFFF9F6F0);
    const inkColor = Color(0xFF2C3E50);

    return PopScope(
      canPop: _engine.isGameOver,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handlePop();
      },
      child: Scaffold(
        backgroundColor: paperBackground,
        appBar: AppBar(
          backgroundColor: paperBackground,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: inkColor),
            onPressed: _handleBackPress,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.answer.category.displayName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: inkColor,
                ),
              ),
              Text(
                'Nível: ${widget.answer.difficulty.displayName}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF7F8C8D)),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                _engine.hintUsed
                    ? Icons.lightbulb_rounded
                    : Icons.lightbulb_outline_rounded,
                color: _engine.hintUsed
                    ? const Color(0xFFF39C12)
                    : const Color(0xFF7F8C8D),
              ),
              tooltip: 'Consultar Dica',
              onPressed: _showHintDialog,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: _engine.errorCount > 0
                        ? const Color(0xFFFDEDEC)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _engine.errorCount > 0
                          ? const Color(0xFFE74C3C)
                          : const Color(0xFFBDC3C7),
                    ),
                  ),
                  child: Text(
                    'Erros: ${_engine.errorCount}/${_engine.maxErrors}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: _engine.errorCount > 0
                          ? const Color(0xFFE74C3C)
                          : inkColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: Center(
                  child: HangmanDisplay(errorCount: _engine.errorCount),
                ),
              ),

              Expanded(
                flex: 3,
                child: Center(
                  child: SingleChildScrollView(
                    child: WordDisplay(engine: _engine),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: VirtualKeyboard(
                  onLetterPressed: _onLetterPressed,
                  getLetterState: _getLetterState,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
