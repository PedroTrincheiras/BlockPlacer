import 'dart:math';
import 'package:blockplacer/Management/config.dart';
import 'package:blockplacer/Management/pieces.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Gestor with ChangeNotifier {

  Gestor(int hs) {
    hightScore = hs;
  }

  Future<SharedPreferences> _hightScoreEver = SharedPreferences.getInstance();
  int hightScore = 0;
  int score = 0;
  bool gameOver = false;
  bool newRecord = false;
  int draging = 0;
  int plays = 0;
  bool party = false;
  List<MyPiece> actual = _generate();


  List<List<bool>> table = [
      [false, false, false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false, false, false],
    ];

  static List<MyPiece> _generate() {
    List<MyPiece> newList = List();
    for(int i = 0 ; i != 3 ; i++){
      newList.add(MyPiece(pieces[Random().nextInt(pieces.length)]));
    }
    return newList;
  }

  void accept(MyPiece p, int x, int y) {
    List<List<bool>> struct = p.content;
    for (int i = 0; i != struct.length; i++) {
      for (int j = 0; j != struct[0].length; j++) {
        if (struct[i][j] == true) {
          table[x + i][y + j] = true;
          _incrementScore(pointpersquare);
        }
      }
    }
    actual.remove(p);
    notifyListeners();
    check();
    remove();

    if (actual.length == 0) {
      actual = _generate();
      notifyListeners();
    }

    if (!existPossibleMove()) {
      gameOver = true;
      plays++;
      print("Game Over");
      if (newRecord) {
        notifyListeners();
        _saveHightScore();
      }
      notifyListeners();
    }
  }

  int bonus = 0;

  List<int> linhas = new List();
  List<int> colunas = new List();
  List<int> setor = new List();

  void check() {
    for (int i = 0; i != 9; i++) {
      bool l = true;
      bool c = true;
      bool s = true;
      for (int j = 0; j != 9; j++) {
        if (table[i][j] == false) {
          l = false;
        }
        if (table[j][i] == false) {
          c = false;
        }
        if (table[(((j - (j % 3)) / 3).round() + (i - (i % 3)))]
                [((j % 3 + i * 3) % 9)] ==
            false) {
          s = false;
        }
      }
      if (c) {
        bonus++;
        colunas.add(i);
      }
      if (l) {
        bonus++;
        linhas.add(i);
      }
      if (s) {
        bonus++;
        setor.add(i);
      }
    }
  }

  void remove() {
    _incrementScore(pointperbonus * bonus * bonus);

    for (int i = 0; i != 9; i++) {
      if (linhas.contains(i)) {
        for (int j = 0; j != 9; j++) {
          table[i][j] = false;
        }
      }
      if (colunas.contains(i)) {
        for (int j = 0; j != 9; j++) {
          table[j][i] = false;
        }
      }
      if (setor.contains(i)) {
        for (int j = 0; j != 9; j++) {
          table[(((j - (j % 3)) / 3).round() + (i - (i % 3)))]
              [((j % 3 + i * 3) % 9)] = false;
        }
      }
    }

    notifyListeners();

    bonus = 0;
    linhas.clear();
    colunas.clear();
    setor.clear();
  }

  bool canAccept(MyPiece p, int x, int y) {
    if (p == null || x == null || y == null) {
      return false;
    }
    List<List<bool>> struct = p.content;
    if (x + struct.length > 9 || y + struct[0].length > 9) {
      return false;
    }
    for (int i = 0; i != struct.length; i++) {
      for (int j = 0; j != struct[0].length; j++) {
        if (struct[i][j] == true && table[x + i][y + j] == true) {
          return false;
        }
      }
    }
    return true;
  }

  bool existPossibleMove() {
    for (MyPiece p in actual) {
      if (isPossibleToPlace(p)) {
        return true;
      }
    }
    return false;
  }

  bool isPossibleToPlace(MyPiece p) {
    for (int i = 0; i != 9 - p.content.length + 1; i++) {
      for (int j = 0; j != 9 - p.content[0].length + 1; j++) {
        if (canAccept(p, i, j)) {
          return true;
        }
      }
    }
    return false;
  }

  bool getVal(int x, int y) {
    return table[x][y];
  }

  bool _doParty = false;

  void _incrementScore(int i) {
    score += i;
    if (score > hightScore) {
      newRecord = true;
      hightScore = score;
      if(!_doParty){
        party = true;
        _doParty = true;
      }
    }
    notifyListeners();
  }

  void reset(){
    gameOver = false;
    newRecord = false;
    party = false;
    score = 0;
    _doParty = false;
    table = [
      [false, false, false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false, false, false],
    ];
    actual = _generate();
    notifyListeners();
  }

  _saveHightScore() async {
    final SharedPreferences prefs = await _hightScoreEver;
    prefs.setInt("hightScore", score);
  }
}
