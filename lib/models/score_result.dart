import 'playing_card.dart';

class ScoreResult {
  final int score;
  final List<PlayingCard> usedCards;

  const ScoreResult({required this.score, required this.usedCards});
}
