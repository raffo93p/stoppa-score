import 'package:flutter/material.dart';
import '../models/card_rank.dart';
import '../models/card_suit.dart';

/// Widget che mostra l'immagine reale di una carta.
/// Le immagini sono in assets/cards/ con formato semenumero.png
/// dove numero: 1=asso, 2-7, 8=fante, 9=cavallo, 10=re
class RealCardImage extends StatelessWidget {
  final CardRank rank;
  final CardSuit suit;
  final double width;
  final double height;
  final bool showScore;

  const RealCardImage({
    super.key,
    required this.rank,
    required this.suit,
    this.width = 60,
    this.height = 90,
    this.showScore = true,
  });

  /// Converte il CardRank nel numero usato nel filename
  int get _rankNumber {
    switch (rank) {
      case CardRank.asso:
        return 1;
      case CardRank.due:
        return 2;
      case CardRank.tre:
        return 3;
      case CardRank.quattro:
        return 4;
      case CardRank.cinque:
        return 5;
      case CardRank.sei:
        return 6;
      case CardRank.sette:
        return 7;
      case CardRank.fante:
        return 8;
      case CardRank.cavallo:
        return 9;
      case CardRank.re:
        return 10;
    }
  }

  /// Converte il CardSuit nel nome usato nel filename
  String get _suitName {
    switch (suit) {
      case CardSuit.bastoni:
        return 'bastoni';
      case CardSuit.coppe:
        return 'coppe';
      case CardSuit.denari:
        return 'denari';
      case CardSuit.spade:
        return 'spade';
    }
  }

  String get _imagePath => 'assets/cards/$_suitName$_rankNumber.png';

  int get _scoreValue => rank.stoppaValue;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              _imagePath,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
              errorBuilder: (context, error, stackTrace) {
                // Fallback se l'immagine non esiste
                return _buildFallback();
              },
            ),
            if (showScore)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.0),
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Text(
                    '$_scoreValue',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallback() {
    Color suitColor;
    switch (suit) {
      case CardSuit.coppe:
        suitColor = const Color(0xFFE74C3C);
        break;
      case CardSuit.denari:
        suitColor = const Color(0xFFF1C40F);
        break;
      case CardSuit.spade:
        suitColor = const Color(0xFF34495E);
        break;
      case CardSuit.bastoni:
        suitColor = const Color(0xFF27AE60);
        break;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [suitColor, suitColor.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(suit.emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 2),
          Text(
            rank.displayName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
