class Monster{

  String? name;
  double? cr;

  setName (String? n) {
    name = n;
  }

  setTable (double? c) {
    cr = c;
  }

  String? getMonster () {
    return name;
  }

  double? getCr () {
    return cr;
  }

}