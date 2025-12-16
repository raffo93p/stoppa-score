import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state.dart';
import '../models/card_rank.dart';
import '../models/card_suit.dart';
import '../widgets/card_selector.dart';
import '../widgets/card_display.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  CardRank? _selectedRank;

  @override
  void initState() {
    super.initState();
  }

  void _onCardRankSelected(CardRank rank) {
    setState(() {
      _selectedRank = rank;
    });
    _showSuitDialog();
  }

  void _showSuitDialog() {
    final gameState = context.read<GameState>();
    final allSelectedCards = [
      ...gameState.allCards,
      ...gameState.currentTurnCards,
    ];

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  const Expanded(
                    child: Text(
                      'Seleziona il seme',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: CardSuit.values.map((suit) {
                  final isDisabled = allSelectedCards.any(
                    (card) => card.rank == _selectedRank && card.suit == suit,
                  );
                  return _buildSuitButton(context, suit, isDisabled, () {
                    if (!isDisabled) {
                      Navigator.pop(context);
                      _onSuitSelected(suit);
                    }
                  });
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuitButton(
    BuildContext context,
    CardSuit suit,
    bool isDisabled,
    VoidCallback onTap,
  ) {
    Color getSuitColor() {
      switch (suit) {
        case CardSuit.coppe:
          return const Color(0xFFE74C3C);
        case CardSuit.denari:
          return const Color(0xFFF1C40F);
        case CardSuit.spade:
          return const Color(0xFF34495E);
        case CardSuit.bastoni:
          return const Color(0xFF27AE60);
      }
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Opacity(
          opacity: isDisabled ? 0.4 : 1.0,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: isDisabled ? Colors.grey : getSuitColor(),
              borderRadius: BorderRadius.circular(12),
              boxShadow: isDisabled
                  ? []
                  : [
                      BoxShadow(
                        color: getSuitColor().withOpacity(0.3),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        suit.emoji,
                        style: const TextStyle(fontSize: 36),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        suit.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                if (isDisabled)
                  Center(
                    child: Icon(
                      Icons.block,
                      color: Colors.white.withOpacity(0.8),
                      size: 40,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFinalScoreDialog() {
    final gameState = context.read<GameState>();
    if (gameState.finalScore == null) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF39C12), Color(0xFFE67E22)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const Icon(Icons.stars, color: Colors.white, size: 48),
                const SizedBox(height: 12),
                const Text(
                  'PUNTEGGIO FINALE',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${gameState.finalScore!.score}',
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE67E22),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (gameState.finalScore!.score == 55)
                  const Text(
                    '🎉 PUNTEGGIO MASSIMO! 🎉',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  '${gameState.finalScore!.usedCards.length} carte utilizzate',
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Carte Vincenti',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: gameState.finalScore!.usedCards.map((card) {
                    return CardDisplay(card: card, isHighlighted: true);
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSuitSelected(CardSuit suit) {
    if (_selectedRank != null) {
      final gameState = context.read<GameState>();
      gameState.addCard(_selectedRank!, suit);
      setState(() {
        _selectedRank = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3498DB), Color(0xFF2C3E50)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildCurrentTurnSection(),
                      const SizedBox(height: 20),
                      _buildCardSelector(),
                      const SizedBox(height: 20),
                      _buildPreviousTurnsSection(),
                    ],
                  ),
                ),
              ),
              _buildBottomButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<GameState>(
      builder: (context, gameState, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '🃏 Stoppa Score',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.refresh,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${gameState.turnNumber}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.style, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${gameState.totalCardsCount}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentTurnSection() {
    return Consumer<GameState>(
      builder: (context, gameState, _) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Carte Turno Corrente',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3498DB).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${gameState.currentTurnCards.length}/3',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3498DB),
                          ),
                        ),
                      ),
                      if (gameState.currentTurnScore != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF39C12).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.emoji_events,
                                color: Color(0xFFF39C12),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${gameState.currentTurnScore!.score}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFF39C12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (gameState.currentTurnCards.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text(
                      'Seleziona le carte per questo turno',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                )
              else
                Wrap(
                  alignment: WrapAlignment.center,
                  children: gameState.currentTurnCards.map((card) {
                    final isHighlighted =
                        gameState.currentTurnScore?.usedCards.contains(card) ??
                        false;
                    return CardDisplay(
                      card: card,
                      isHighlighted: isHighlighted,
                      onRemove: () => gameState.removeCard(card),
                    );
                  }).toList(),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCardSelector() {
    return Consumer<GameState>(
      builder: (context, gameState, _) {
        return Column(
          children: [
            if (!gameState.canAddCard)
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF27AE60), width: 2),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Color(0xFF27AE60),
                      size: 32,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Turno completo! Vai al prossimo turno',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF27AE60),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3498DB), Color(0xFF2980B9)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.touch_app, color: Colors.white, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Seleziona ancora ${3 - gameState.currentTurnCards.length} ${gameState.currentTurnCards.length == 2 ? "carta" : "carte"}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            CardSelector(
              onCardSelected: _onCardRankSelected,
              selectedCards: [
                ...gameState.allCards,
                ...gameState.currentTurnCards,
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildPreviousTurnsSection() {
    return Consumer<GameState>(
      builder: (context, gameState, _) {
        if (gameState.allCards.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.history, color: Color(0xFF8E44AD), size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Carte dei Turni Precedenti',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8E44AD).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${gameState.allCards.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8E44AD),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                children: gameState.allCards.map((card) {
                  final isHighlighted =
                      gameState.finalScore?.usedCards.contains(card) ?? false;
                  return CardDisplay(card: card, isHighlighted: isHighlighted);
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomButtons() {
    return Consumer<GameState>(
      builder: (context, gameState, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    gameState.resetGame();
                    setState(() {
                      _selectedRank = null;
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Nuova'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE74C3C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: gameState.currentTurnCards.isEmpty
                      ? null
                      : () {
                          gameState.nextTurn();
                        },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Turno'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF27AE60),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    disabledBackgroundColor: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed:
                      (gameState.allCards.isEmpty &&
                          gameState.currentTurnCards.isEmpty)
                      ? null
                      : () {
                          gameState.calculateFinalScore();
                          _showFinalScoreDialog();
                        },
                  icon: const Icon(Icons.calculate),
                  label: const Text('Calcola'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF39C12),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    disabledBackgroundColor: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
