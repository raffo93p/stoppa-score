import '../models/playing_card.dart';
import '../models/card_suit.dart';
import '../models/score_result.dart';

class ScoreCalculator {
  /// Calcola il punteggio massimo possibile con le carte date.
  /// Restituisce il punteggio e le carte utilizzate.
  static ScoreResult calculateMaxScore(List<PlayingCard> cards) {
    if (cards.isEmpty) {
      return const ScoreResult(score: 0, usedCards: []);
    }

    // Raggruppa le carte per seme
    final Map<CardSuit, List<PlayingCard>> cardsBySuit = {};
    for (final card in cards) {
      cardsBySuit.putIfAbsent(card.suit, () => []).add(card);
    }

    int maxScore = 0;
    List<PlayingCard> bestCards = [];

    // Per ogni seme, calcola il miglior punteggio possibile
    for (final entry in cardsBySuit.entries) {
      final suitCards = entry.value;

      // Ordina le carte per valore decrescente
      suitCards.sort((a, b) => b.value.compareTo(a.value));

      // Prendi le prime 3 carte (o meno se non ce ne sono abbastanza)
      final cardsToUse = suitCards.take(3).toList();
      final score = cardsToUse.fold<int>(0, (sum, card) => sum + card.value);

      if (score > maxScore) {
        maxScore = score;
        bestCards = cardsToUse;
      }
    }

    return ScoreResult(score: maxScore, usedCards: bestCards);
  }

  /// Calcola il punteggio per un singolo turno (massimo 3 carte)
  static ScoreResult calculateTurnScore(List<PlayingCard> cards) {
    if (cards.length > 3) {
      throw ArgumentError('Un turno può avere al massimo 3 carte');
    }
    return calculateMaxScore(cards);
  }
}
