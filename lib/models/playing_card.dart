import 'package:equatable/equatable.dart';
import 'card_rank.dart';
import 'card_suit.dart';

class PlayingCard extends Equatable {
  final CardRank rank;
  final CardSuit suit;
  final String id; // ID unico per distinguere carte duplicate

  const PlayingCard({required this.rank, required this.suit, required this.id});

  int get value => rank.stoppaValue;

  @override
  List<Object?> get props => [rank, suit, id];

  @override
  String toString() => '${rank.displayName} di ${suit.name}';
}
