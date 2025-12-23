import 'package:flutter/material.dart';
import '../models/card_rank.dart';
import '../models/card_suit.dart';
import '../models/playing_card.dart';

class SuitFirstCardSelector extends StatefulWidget {
  final Function(CardRank, CardSuit) onCardSelected;
  final List<PlayingCard> selectedCards;

  const SuitFirstCardSelector({
    super.key,
    required this.onCardSelected,
    this.selectedCards = const [],
  });

  @override
  State<SuitFirstCardSelector> createState() => SuitFirstCardSelectorState();
}

class SuitFirstCardSelectorState extends State<SuitFirstCardSelector> {
  CardSuit? _selectedSuit;

  void resetSelection() {
    setState(() {
      _selectedSuit = null;
    });
  }

  Color _getSuitColor(CardSuit suit) {
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

  bool _isCardDisabled(CardRank rank, CardSuit suit) {
    return widget.selectedCards.any(
      (card) => card.rank == rank && card.suit == suit,
    );
  }

  void _onSuitTap(CardSuit suit) {
    setState(() {
      if (_selectedSuit == suit) {
        _selectedSuit = null;
      } else {
        _selectedSuit = suit;
      }
    });
  }

  void _onCardTap(CardRank rank) {
    if (_selectedSuit != null) {
      widget.onCardSelected(rank, _selectedSuit!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
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
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 8),
          _buildSuitRow(),
          if (_selectedSuit != null) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${_selectedSuit!.emoji} Carte ${_selectedSuit!.name}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _getSuitColor(_selectedSuit!),
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => setState(() => _selectedSuit = null),
                  icon: const Icon(Icons.close, size: 16),
                  label: const Text('Cambia seme'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[600],
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildCardGrid(),
          ],
        ],
      ),
    );
  }

  Widget _buildSuitRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: CardSuit.values.map((suit) {
        final isSelected = _selectedSuit == suit;
        return _buildSuitButton(suit, isSelected);
      }).toList(),
    );
  }

  Widget _buildSuitButton(CardSuit suit, bool isSelected) {
    final color = _getSuitColor(suit);

    return GestureDetector(
      onTap: () => _onSuitTap(suit),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: isSelected ? 3 : 2),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(suit.emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 2),
            Text(
              suit.name,
              style: TextStyle(
                color: isSelected ? Colors.white : color,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardGrid() {
    final cards = CardRank.values.map((rank) {
      final isDisabled = _isCardDisabled(rank, _selectedSuit!);
      return _buildCardButton(rank, isDisabled);
    }).toList();

    // Prima riga: 5 carte, seconda riga: 5 carte
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: cards.sublist(0, 5),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: cards.sublist(5, 10),
        ),
      ],
    );
  }

  Widget _buildCardButton(CardRank rank, bool isDisabled) {
    final suitColor = _getSuitColor(_selectedSuit!);

    return GestureDetector(
      onTap: isDisabled ? null : () => _onCardTap(rank),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isDisabled ? 0.4 : 1.0,
        child: Container(
          width: 56,
          height: 72,
          decoration: BoxDecoration(
            gradient: isDisabled
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.grey.shade400, Colors.grey.shade500],
                  )
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [suitColor, suitColor.withOpacity(0.8)],
                  ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: isDisabled
                ? []
                : [
                    BoxShadow(
                      color: suitColor.withOpacity(0.3),
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
                  Text(
                    _selectedSuit!.emoji,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  Center(
                    child: Text(
                      rank.displayName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              if (isDisabled)
                Center(
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.white.withOpacity(0.8),
                    size: 20,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
