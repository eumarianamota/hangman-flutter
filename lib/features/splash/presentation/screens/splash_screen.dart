import 'package:flutter/material.dart';

import '../../../game/data/repositories/asset_answer_repository.dart';
import '../../../game/domain/entities/answer_entry.dart';

/// Tela de abertura assíncrona responsável por carregar os dados das palavras
/// a partir do arquivo JSON nos assets antes de liberar a navegação para o jogo.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.repository, this.onLoaded});

  /// Repositório de dados injetável para flexibilidade ou testes.
  final AssetAnswerRepository? repository;

  /// Callback opcional de navegação executado após o carregamento bem-sucedido.
  final void Function(BuildContext context, List<AnswerEntry> answers)?
  onLoaded;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final AssetAnswerRepository _repository;
  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? AssetAnswerRepository();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final answers = await _repository.loadAnswers();

      if (!mounted) return;

      if (widget.onLoaded != null) {
        widget.onLoaded!(context, answers);
      } else {
        // Redireciona para a rota padrão da HomeScreen conforme o fluxo do PRD
        Navigator.of(context).pushReplacementNamed('/home', arguments: answers);
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Não foi possível carregar as palavras do jogo.\n${error.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Paleta de cores temática inspirada no papel/caderno analógico (PRD RNF01)
    const paperBackground = Color(0xFFF9F6F0);
    const inkColor = Color(0xFF2C3E50);
    const accentLineColor = Color(0xFFE0D7C6);

    return Scaffold(
      backgroundColor: paperBackground,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ilustração / Ícone temático no estilo analógico
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: inkColor, width: 3),
                    boxShadow: const [
                      BoxShadow(
                        color: accentLineColor,
                        offset: Offset(4, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.edit_note_rounded,
                    size: 56,
                    color: inkColor,
                  ),
                ),
                const SizedBox(height: 28),

                // Título em estilo de marcador / escrita manual
                const Text(
                  'JOGO DA FORCA',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3.0,
                    color: inkColor,
                  ),
                ),
                const SizedBox(height: 8),

                const Text(
                  'UESPI • Programação Móvel',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 1.2,
                    color: Color(0xFF7F8C8D),
                  ),
                ),
                const SizedBox(height: 48),

                // Estado de carregamento ou exibição de erro
                if (_isLoading) ...[
                  const CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(inkColor),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Carregando palavras...',
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: inkColor,
                    ),
                  ),
                ] else if (_errorMessage != null) ...[
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFFC0392B),
                    ),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: _loadData,
                    icon: const Icon(Icons.refresh, color: inkColor),
                    label: const Text(
                      'Tentar Novamente',
                      style: TextStyle(
                        color: inkColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: inkColor, width: 2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
