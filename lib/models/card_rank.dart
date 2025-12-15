enum CardRank {
  asso,
  due,
  tre,
  quattro,
  cinque,
  sei,
  sette,
  fante,
  cavallo,
  re;

  String get displayName {
    switch (this) {
      case CardRank.asso:
        return 'Asso';
      case CardRank.due:
        return '2';
      case CardRank.tre:
        return '3';
      case CardRank.quattro:
        return '4';
      case CardRank.cinque:
        return '5';
      case CardRank.sei:
        return '6';
      case CardRank.sette:
        return '7';
      case CardRank.fante:
        return 'Fante';
      case CardRank.cavallo:
        return 'Cavallo';
      case CardRank.re:
        return 'Re';
    }
  }

  int get numericValue {
    switch (this) {
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

  // Calcola il punteggio secondo le regole di Stoppa
  int get stoppaValue {
    switch (this) {
      case CardRank.asso:
        return 16;
      case CardRank.due:
        return 12;
      case CardRank.tre:
        return 13;
      case CardRank.quattro:
        return 14;
      case CardRank.cinque:
        return 15;
      case CardRank.sei:
        return 18;
      case CardRank.sette:
        return 21;
      case CardRank.fante:
      case CardRank.cavallo:
      case CardRank.re:
        return 10;
    }
  }
}
