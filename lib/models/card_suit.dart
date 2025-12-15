enum CardSuit {
  coppe,
  denari,
  spade,
  bastoni;

  String get name {
    switch (this) {
      case CardSuit.coppe:
        return 'Coppe';
      case CardSuit.denari:
        return 'Denari';
      case CardSuit.spade:
        return 'Spade';
      case CardSuit.bastoni:
        return 'Bastoni';
    }
  }

  String get emoji {
    switch (this) {
      case CardSuit.coppe:
        return '🏆';
      case CardSuit.denari:
        return '💰';
      case CardSuit.spade:
        return '⚔️';
      case CardSuit.bastoni:
        return '🪵';
    }
  }
}
