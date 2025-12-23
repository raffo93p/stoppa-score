import 'package:flutter/material.dart';
import '../models/playing_card.dart';
import '../models/card_rank.dart';
import '../models/card_suit.dart';
import '../models/score_result.dart';
import '../services/score_calculator.dart';

class GameState extends ChangeNotifier {
  List<PlayingCard> _currentTurnCards = [];
  List<PlayingCard> _allCards = [];
  int _turnNumber = 1;
  ScoreResult? _currentTurnScore;
  ScoreResult? _finalScore;
  bool _showingFinalScore = false;
  bool _useRealCards = false;

  List<PlayingCard> get currentTurnCards => _currentTurnCards;
  List<PlayingCard> get allCards => _allCards;
  int get turnNumber => _turnNumber;
  ScoreResult? get currentTurnScore => _currentTurnScore;
  ScoreResult? get finalScore => _finalScore;
  bool get showingFinalScore => _showingFinalScore;
  bool get useRealCards => _useRealCards;
  bool get canAddCard => _currentTurnCards.length < 3;

  void toggleRealCards(bool value) {
    _useRealCards = value;
    notifyListeners();
  }

  void addCard(CardRank rank, CardSuit suit) {
    if (_currentTurnCards.length >= 3) {
      return;
    }

    final card = PlayingCard(
      rank: rank,
      suit: suit,
      id: '${rank.name}_${suit.name}_${DateTime.now().millisecondsSinceEpoch}',
    );

    _currentTurnCards.add(card);
    _calculateCurrentTurnScore();
    notifyListeners();
  }

  void removeCard(PlayingCard card) {
    _currentTurnCards.remove(card);
    _calculateCurrentTurnScore();
    notifyListeners();
  }

  void _calculateCurrentTurnScore() {
    if (_currentTurnCards.isEmpty) {
      _currentTurnScore = null;
    } else {
      _currentTurnScore = ScoreCalculator.calculateTurnScore(_currentTurnCards);
    }
  }

  void nextTurn() {
    if (_currentTurnCards.isEmpty) {
      return;
    }

    // Aggiungi le carte del turno corrente a tutte le carte
    _allCards.addAll(_currentTurnCards);

    // Pulisci il turno corrente
    _currentTurnCards = [];
    _currentTurnScore = null;
    _turnNumber++;
    _showingFinalScore = false;
    _finalScore = null;

    notifyListeners();
  }

  void calculateFinalScore() {
    if (_allCards.isEmpty && _currentTurnCards.isEmpty) {
      return;
    }

    // Combina tutte le carte
    final allCardsForCalculation = [..._allCards, ..._currentTurnCards];
    _finalScore = ScoreCalculator.calculateMaxScore(allCardsForCalculation);
    _showingFinalScore = true;
    notifyListeners();
  }

  void resetGame() {
    _currentTurnCards = [];
    _allCards = [];
    _turnNumber = 1;
    _currentTurnScore = null;
    _finalScore = null;
    _showingFinalScore = false;
    notifyListeners();
  }

  int get totalCardsCount => _allCards.length + _currentTurnCards.length;
}
