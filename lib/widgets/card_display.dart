import 'package:flutter/material.dart';
import '../models/playing_card.dart';
import '../models/card_suit.dart';
import 'real_card_image.dart';

class CardDisplay extends StatelessWidget {
  final PlayingCard card;
  final bool isHighlighted;
  final VoidCallback? onRemove;
  final bool useRealCards;

  const CardDisplay({
    super.key,
    required this.card,
    this.isHighlighted = false,
    this.onRemove,
    this.useRealCards = false,
  });

  Color get _suitColor {
    switch (card.suit) {
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
    Widget cardWidget = Stack(
      clipBehavior: Clip.none,
      children: [
        if (useRealCards) _buildRealCard() else _buildStylizedCard(),
        if (onRemove != null)
          Positioned(
            top: -4,
            right: -4,
            child: GestureDetector(
              onTap: onRemove,
              behavior: HitTestBehavior.opaque,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(Icons.close, color: Colors.white, size: 14),
              ),
            ),
          ),
      ],
    );

    // Se onRemove è presente, rendi l'intera carta cliccabile
    if (onRemove != null) {
      return GestureDetector(onTap: onRemove, child: cardWidget);
    }

    return cardWidget;
  }

  Widget _buildRealCard() {
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isHighlighted ? Colors.amber.shade700 : Colors.grey.shade300,
          width: isHighlighted ? 3 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isHighlighted
                ? Colors.amber.withOpacity(0.5)
                : Colors.black.withOpacity(0.15),
            blurRadius: isHighlighted ? 8 : 4,
            offset: Offset(0, isHighlighted ? 3 : 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: RealCardImage(
          rank: card.rank,
          suit: card.suit,
          width: 70,
          height: 100,
          showScore: true,
        ),
      ),
    );
  }

  Widget _buildStylizedCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: 70,
      height: 100,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.amber.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isHighlighted ? Colors.amber.shade700 : _suitColor,
          width: isHighlighted ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isHighlighted
                ? Colors.amber.withOpacity(0.5)
                : Colors.black.withOpacity(0.1),
            blurRadius: isHighlighted ? 8 : 4,
            offset: Offset(0, isHighlighted ? 3 : 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(card.suit.emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 2),
          Text(
            card.rank.displayName,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _suitColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: _suitColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${card.value}',
              style: TextStyle(
                color: _suitColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
