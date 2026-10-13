import 'package:flutter/material.dart';

import '../../../../core/enums/answer_category.dart';
import '../../../../core/enums/difficulty.dart';
import '../../../about/presentation/screens/about_screen.dart';
import '../../../game/domain/engine/game_engine.dart';
import '../../../game/domain/entities/answer_entry.dart';
import '../../../game/presentation/dialogs/category_exhausted_dialog.dart';
import '../../../game/presentation/dialogs/game_over_dialog.dart';
import '../../../game/presentation/screens/game_screen.dart';
import '../../../session/data/session_repository.dart';
import '../../../session/presentation/dialogs/statistics_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.answers});

  final List<AnswerEntry> answers;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AnswerCategory _selectedCategory;
  late Difficulty _selectedDifficulty;

  @override
  void initState() {
    super.initState();
    _selectedCategory = AnswerCategory.animals;
    _selectedDifficulty = Difficulty.easy;
  }

  void _startGame() {
    final session = SessionRepository.instance;
    final answer = session.getRandomAvailableAnswer(
      widget.answers,
      _selectedCategory,
      _selectedDifficulty,
    );

    if (answer == null) {
      _showExhaustedDialog();
      return;
    }

    _navigateToGame(answer);
  }

  void _navigateToGame(AnswerEntry answer) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GameScreen(
          answer: answer,
          onGameFinished: (gameContext, engine) {
            _handleGameFinished(gameContext, engine);
          },
          onForfeit: () {
            // Derrota já registrada via forfeit
            SessionRepository.instance.recordRoundResult(
              isWon: false,
              errors: 6,
              hintUsed: false,
            );
            setState(() {});
          },
        ),
      ),
    );
  }

  void _handleGameFinished(BuildContext gameContext, GameEngine engine) {
    SessionRepository.instance.recordRoundResult(
      isWon: engine.isWon,
      errors: engine.errorCount,
      hintUsed: engine.hintUsed,
    );

    setState(() {}); 

    GameOverDialog.show(
      gameContext,
      isWon: engine.isWon,
      answer: engine.currentAnswer,
      errors: engine.errorCount,
      hintUsed: engine.hintUsed,
      onNextWord: () {
        Navigator.of(gameContext).pop(); 
        _startNextWord();
      },
      onExitToMenu: () {
        Navigator.of(gameContext).pop(); 
      },
    );
  }

  void _startNextWord() {
    final session = SessionRepository.instance;
    final nextAnswer = session.getRandomAvailableAnswer(
      widget.answers,
      _selectedCategory,
      _selectedDifficulty,
    );

    if (nextAnswer == null) {
      _showExhaustedDialog();
    } else {
      _navigateToGame(nextAnswer);
    }
  }

  void _showExhaustedDialog() {
    CategoryExhaustedDialog.show(
      context,
      category: _selectedCategory,
      difficulty: _selectedDifficulty,
      onSwitchSelection: () {  
      },
      onResetCategoryWords: () {
        SessionRepository.instance.resetPlayedAnswersForCategory(
          _selectedCategory,
          _selectedDifficulty,
          widget.answers,
        );
        _startGame();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const paperBackground = Color(0xFFF9F6F0);
    const cardBackground = Color(0xFFFDFBF7);
    const inkColor = Color(0xFF2C3E50);
    const borderColor = Color(0xFFE0D7C6);

    return Scaffold(
      backgroundColor: paperBackground,
      appBar: AppBar(
        backgroundColor: paperBackground,
        elevation: 0,
        iconTheme: const IconThemeData(color: inkColor),
        title: const Text(
          'Jogo da Forca',
          style: TextStyle(color: inkColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            tooltip: 'Estatísticas',
            onPressed: () => StatisticsDialog.show(context),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: paperBackground,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFFEDE6D6)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit_note_rounded, size: 48, color: inkColor),
                  SizedBox(height: 10),
                  Text(
                    'JOGO DA FORCA',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: inkColor,
                    ),
                  ),
                  Text(
                    'UESPI • Programação Móvel',
                    style: TextStyle(fontSize: 12, color: Color(0xFF7F8C8D)),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart_rounded, color: inkColor),
              title: const Text(
                'Estatísticas da Sessão',
                style: TextStyle(fontWeight: FontWeight.w600, color: inkColor),
              ),
              onTap: () {
                Navigator.of(context).pop();
                StatisticsDialog.show(context);
              },
            ),
            const Divider(color: borderColor),
            ListTile(
              leading: const Icon(Icons.info_outline_rounded, color: inkColor),
              title: const Text(
                'Sobre a Equipe',
                style: TextStyle(fontWeight: FontWeight.w600, color: inkColor),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Banner do Tema
              Container(
                padding: const EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                  color: cardBackground,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: borderColor, width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: const Column(
                  children: [
                    Text(
                      'Configuração da Rodada',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: inkColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Escolha uma categoria e um nível de dificuldade para começar:',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Color(0xFF7F8C8D)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 1. Seleção de Categoria
              const Text(
                'Categoria:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: inkColor,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<AnswerCategory>(
                    value: _selectedCategory,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: inkColor,
                    ),
                    items: AnswerCategory.values
                        .map((category) {
                          return DropdownMenuItem<AnswerCategory>(
                            value: category,
                            child: Text(
                              category.displayName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: inkColor,
                              ),
                            ),
                          );
                        })
                        .toList(growable: false),
                    onChanged: (newCategory) {
                      if (newCategory != null) {
                        setState(() {
                          _selectedCategory = newCategory;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 2. Seleção de Dificuldade
              const Text(
                'Dificuldade:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: inkColor,
                ),
              ),
              const SizedBox(height: 8),
              SegmentedButton<Difficulty>(
                segments: Difficulty.values
                    .map((difficulty) {
                      return ButtonSegment<Difficulty>(
                        value: difficulty,
                        label: Text(
                          difficulty.displayName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      );
                    })
                    .toList(growable: false),
                selected: {_selectedDifficulty},
                onSelectionChanged: (newSelection) {
                  setState(() {
                    _selectedDifficulty = newSelection.first;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>((
                    states,
                  ) {
                    if (states.contains(WidgetState.selected)) {
                      return inkColor;
                    }
                    return Colors.white;
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith<Color>((
                    states,
                  ) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.white;
                    }
                    return inkColor;
                  }),
                  side: WidgetStateProperty.all(
                    const BorderSide(color: borderColor, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Botão Iniciar Partida
              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: inkColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 2,
                  ),
                  icon: const Icon(Icons.play_arrow_rounded, size: 28),
                  label: const Text(
                    'Iniciar Partida',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  onPressed: _startGame,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
