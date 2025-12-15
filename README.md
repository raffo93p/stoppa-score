# 🃏 Stoppa Score - Contatore Punti

Un'app Flutter elegante e intuitiva per calcolare i punti nel gioco di carte napoletane **Stoppa**.

## 📖 Come si gioca

Stoppa è un gioco di carte napoletane che si gioca in 4-5 persone:

### Meccanica di gioco
1. **Turni**: Ogni turno vengono distribuite 3 carte a testa
2. **Puntata**: Ogni giocatore fa una puntata basata sul punteggio delle proprie carte
3. **Fine partita**: Dopo tutti i turni, si calcola il punteggio con tutte le carte

### Sistema di punteggio

⚠️ **Regola principale**: Valgono solo le carte dello **stesso seme**, massimo 3 carte.

#### Valori delle carte
- **2, 3, 4, 5**: Valore carta + 10 → *(12, 13, 14, 15)*
- **Asso**: 16 punti
- **6**: 18 punti
- **7**: 21 punti
- **Fante, Cavallo, Re**: 10 punti

#### Punteggio massimo
🏆 **55 punti** → Asso + 6 + 7 dello stesso seme

## 🎮 Come usare l'app

### 1️⃣ Selezionare le carte
- Clicca su una carta tra quelle disponibili (Asso, 2, 3, 4, 5, 6, 7, Fante, Cavallo, Re)
- Seleziona il seme: **Coppe** 🏆, **Denari** 💰, **Spade** ⚔️, **Bastoni** 🪵
- La carta apparirà nella sezione "Carte Turno Corrente"

### 2️⃣ Durante il turno
- Puoi selezionare fino a **3 carte** per turno
- Il punteggio del turno viene **calcolato automaticamente**
- Le carte che contribuiscono al punteggio vengono **evidenziate in giallo**
- Se hai sbagliato, clicca sulla ❌ sulla carta per rimuoverla

### 3️⃣ Gestire i turni
- **Nuovo Turno**: Passa al turno successivo (le carte vengono salvate)
- Le carte dei turni precedenti vengono mostrate nella sezione storico

### 4️⃣ Calcolare il punteggio finale
- **Calcola**: Combina tutte le carte di tutti i turni
- L'app trova automaticamente la **combinazione migliore**
- Le 3 carte utilizzate vengono evidenziate

### 5️⃣ Ricominciare
- **Nuova Giocata**: Reset completo dell'app

## 🎨 Caratteristiche

✨ **Interfaccia moderna** con gradiente blu e design Material 3
🎯 **Calcolo automatico** del punteggio migliore
🌈 **Colori distintivi** per ogni seme
⭐ **Animazioni fluide** per un'esperienza piacevole
📊 **Evidenziazione** delle carte vincenti
🔄 **Gestione turni** intuitiva
❌ **Rimozione facile** delle carte sbagliate

## 🛠️ Tecnologie utilizzate

- **Flutter** 3.10.4+
- **Provider** per la gestione dello stato
- **Equatable** per il confronto degli oggetti
- **Material Design 3** per l'UI moderna

## 🚀 Installazione

```bash
# Clona il repository
git clone [repository-url]

# Entra nella directory
cd stoppa-score

# Installa le dipendenze
flutter pub get

# Avvia l'app
flutter run
```

## 📱 Piattaforme supportate

- ✅ macOS
- ✅ iOS
- ✅ Android
- ✅ Web
- ✅ Windows
- ✅ Linux

## 🎯 Esempi di punteggio

### Esempio 1: Punteggio massimo
Asso di Coppe (16) + 6 di Coppe (18) + 7 di Coppe (21) = **55 punti** 🎉

### Esempio 2: Punteggio buono
7 di Spade (21) + 6 di Spade (18) + Asso di Spade (16) = **55 punti** 🎉

### Esempio 3: Figure
Re di Denari (10) + Cavallo di Denari (10) + Fante di Denari (10) = **30 punti**

### Esempio 4: Carte miste
Anche se hai 7 di Coppe (21), Asso di Spade (16), 6 di Bastoni (18):
- Punteggio = **21** (solo il 7 di Coppe conta, perché le altre sono di semi diversi)

## 📝 Note

L'app calcola sempre il punteggio **ottimale** considerando:
1. Quali carte dello stesso seme danno il punteggio più alto
2. Massimo 3 carte possono essere usate
3. Solo un seme alla volta

---

Buon divertimento! 🎴✨
