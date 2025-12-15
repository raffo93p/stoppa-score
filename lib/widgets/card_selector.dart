import 'package:flutter/material.dart';
import '../models/card_rank.dart';
import '../models/card_suit.dart';
import '../models/playing_card.dart';

class CardSelector extends StatelessWidget {
  final Function(CardRank) onCardSelected;
  final List<PlayingCard> selectedCards;

  const CardSelector({
    super.key,
    required this.onCardSelected,
    this.selectedCards = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Seleziona una carta',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: CardRank.values.map((rank) {
              // Una carta è disabilitata solo se TUTTI i 4 semi sono stati usati
              final usedSuitsForRank = selectedCards
                  .where((card) => card.rank == rank)
                  .map((card) => card.suit)
                  .toSet();
              final isDisabled = usedSuitsForRank.length >= 4;
              return _CardButton(
                rank: rank,
                onTap: isDisabled ? null : () => onCardSelected(rank),
                isDisabled: isDisabled,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _CardButton extends StatelessWidget {
  final CardRank rank;
  final VoidCallback? onTap;
  final bool isDisabled;

  const _CardButton({
    required this.rank,
    required this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Opacity(
        opacity: isDisabled ? 0.4 : 1.0,
        child: Container(
          width: 60,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDisabled
                  ? [Colors.grey.shade400, Colors.grey.shade500]
                  : [const Color(0xFFF39C12), const Color(0xFFE67E22)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: isDisabled
                ? []
                : [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  rank.displayName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              if (isDisabled)
                Center(
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.white.withOpacity(0.8),
                    size: 24,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SuitSelector extends StatelessWidget {
  final CardRank selectedRank;
  final List<PlayingCard> alreadySelectedCards;
  final Function(CardSuit) onSuitSelected;

  const SuitSelector({
    super.key,
    required this.selectedRank,
    required this.alreadySelectedCards,
    required this.onSuitSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Seleziona il seme',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: CardSuit.values.map((suit) {
              // Controlla se questa combinazione rank+suit è già stata usata
              final isDisabled = alreadySelectedCards.any(
                (card) => card.rank == selectedRank && card.suit == suit,
              );
              return _SuitButton(
                suit: suit,
                onTap: isDisabled ? null : () => onSuitSelected(suit),
                isDisabled: isDisabled,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _SuitButton extends StatelessWidget {
  final CardSuit suit;
  final VoidCallback? onTap;
  final bool isDisabled;

  const _SuitButton({
    required this.suit,
    required this.onTap,
    this.isDisabled = false,
  });

  Color get _suitColor {
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Opacity(
        opacity: isDisabled ? 0.4 : 1.0,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: isDisabled ? Colors.grey : _suitColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isDisabled
                ? []
                : [
                    BoxShadow(
                      color: _suitColor.withOpacity(0.3),
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
    );
  }
}
