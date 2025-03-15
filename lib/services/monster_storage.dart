class Monster{

  String? name;
  int? cr;

  setName (String? n) {
    name = n;
  }

  setTable (int? c) {
    cr = c;
  }

  String? getMonster () {
    return name;
  }

  int? getCr () {
    return cr;
  }

}