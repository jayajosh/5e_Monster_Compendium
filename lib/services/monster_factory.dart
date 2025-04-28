import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monster_compendium/services/photo_service.dart';

class MonsterStore {
  String? name;
  String? size;
  String? type;
  String? alignment;

  double? cr;
  Map<String, dynamic> ac = {'type': null, 'value': null};
  double? hit_points;
  String? hit_dice = '';
  Map<String?, String?> speed = {};

  Map<String, int?> ability_scores = {
    'strength': null,
    'dexterity': null,
    'constitution': null,
    'intelligence': null,
    'wisdom': null,
    'charisma': null
  };

  Map<String?, double?> saving_throws = {};
  Map<String?, double?> skills = {};
  List<String?> condition_immunities = []; // Added condition immunities
  List<String?> damage_resistances = [];
  List<String?> damage_immunities = [];
  List<String?> damage_vulnerabilities = [];
  Map<String?, String?> senses = {};
  List<String?> languages = [];

  List<Map<String?, String?>> special_abilities = [];

  List<Map<String?, String?>> actions = [];
  List<Map<String?, String?>> legendary_actions = [];

  String? monster_description = null;

  String? image_url = '';
  File? image;

  String? creator_id;
  DateTime? created_at;

  MonsterStore({
    this.name,
    this.size,
    this.type,
    this.alignment,
    this.cr,
    Map<String, dynamic>? ac,
    this.hit_points,
    this.hit_dice,
    Map<String, String?>? speed,
    Map<String, int?>? ability_scores,
    Map<String?, double?>? saving_throws,
    Map<String?, double?>? skills,
    List<String?>? condition_immunities, // Added to constructor
    List<String?>? damage_resistances,
    List<String?>? damage_immunities,
    List<String?>? damage_vulnerabilities,
    Map<String?, String?>? senses,
    List<String?>? languages,
    List<Map<String?, String?>>? special_abilities,
    List<Map<String?, String?>>? actions,
    List<Map<String?, String?>>? legendary_actions,
    this.monster_description,
    this.image_url,
    this.creator_id = '',
    DateTime? createdAt,
  })
      : ac = ac ?? {'type': null, 'value': null},
        speed = speed ?? {},
        ability_scores = ability_scores ?? {
          'strength': null,
          'dexterity': null,
          'constitution': null,
          'intelligence': null,
          'wisdom': null,
          'charisma': null
        },
        saving_throws = saving_throws ?? {},
        skills = skills ?? {},
        condition_immunities =
            condition_immunities ?? [],
  // Initialize in initializer list
        damage_resistances = damage_resistances ?? [],
        damage_immunities = damage_immunities ?? [],
        damage_vulnerabilities = damage_vulnerabilities ?? [],
        senses = senses ?? {},
        languages = languages ?? [],
        special_abilities = special_abilities ?? [],
        actions = actions ?? [],
        legendary_actions = legendary_actions ?? [],
        created_at = createdAt ?? DateTime.now();

  factory MonsterStore.fromMap(Map<String, dynamic> map) {
    // 1. Helper Functions for Type Conversion and Null Handling
    // These are now inside the factory constructor for better encapsulation
    double? _toDouble(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      return double.tryParse(value.toString());
    }

    int? _toInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      return int.tryParse(value.toString());
    }

    String? _toString(dynamic value) {
      if (value == null) return null;
      return value.toString();
    }

    Map<String, String?>? _toStringMap(Map<dynamic, dynamic>? map) {
      if (map == null) return null;
      Map<String, String?> result = {};
      map.forEach((key, value) {
        if (key is String) { // Ensure the key is a String
          result[key] = _toString(value);
        }
        // else, you could log an error, or skip.  I'm skipping for now.
      });
      return result;
    }

    Map<String, int?>? _toIntMap(Map<dynamic, dynamic>? map) {
      if (map == null) return null;
      Map<String, int?> result = {};
      map.forEach((key, value) {
        if (key is String) {
          result[key] = _toInt(value);
        }
      });
      return result;
    }

    Map<String?, double?>? _toDoubleMap(Map<dynamic, dynamic>? map) {
      if (map == null) return null;
      Map<String?, double?> result = {};
      map.forEach((key, value) {
        result[_toString(key)] = _toDouble(value);
      });
      return result;
    }

    List<String?>? _toStringList(List? list) {
      if (list == null) return null;
      return list.map((item) => _toString(item)).toList();
    }

    List<Map<String?, String?>>? _toListOfMaps(List? list) {
      if (list == null) return null;
      List<Map<String?, String?>> result = [];
      for (var item in list) {
        if (item is Map) {
          result.add(_toStringMap(item) ?? {});
        } else {
          result.add({}); // Handle non-map items, important to prevent errors
        }
      }
      return result;
    }

    // 2. Extract and Convert Data
    // Now using the helper functions defined above
    return MonsterStore(
      name: _toString(map['name']),
      size: _toString(map['size']),
      type: _toString(map['type']),
      alignment: _toString(map['alignment']),
      cr: _toDouble(map['cr']),
      ac: map['ac'] is Map ? Map<String, dynamic>.from(map['ac']) : null,
      //keep original structure
      hit_points: _toDouble(map['hit_points']),
      hit_dice: _toString(map['hit_dice']),
      speed: _toStringMap(map['speed']),
      ability_scores: _toIntMap(map['ability_scores']),
      saving_throws: _toDoubleMap(map['saving_throws']),
      skills: _toDoubleMap(map['skills']),
      condition_immunities: _toStringList(map['condition_immunities']),
      damage_resistances: _toStringList(map['damage_resistances']),
      damage_immunities: _toStringList(map['damage_immunities']),
      damage_vulnerabilities: _toStringList(map['damage_vulnerabilities']),
      senses: _toStringMap(map['senses']),
      languages: _toStringList(map['languages']),
      special_abilities: _toListOfMaps(map['special_abilities']),
      actions: _toListOfMaps(map['actions']),
      //todo fix descriptions
      legendary_actions: _toListOfMaps(map['legendary_actions']),
      //todo fix descriptions & check not a dupe of actions
      monster_description: _toString(map['monster_description']),
      image_url: map['image_url'] ?? null,
      creator_id: map['creator_id'] ?? FirebaseAuth.instance.currentUser?.uid,
      createdAt: map['created_at'] is String
          ? DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now()
          : (map['created_at'] as Timestamp?)?.toDate() ??
          DateTime.now(), //handles String and Timestamp
    );
  }

  Map<String, dynamic> toMap() {
    //Converts to a map for firestore upload
    return {
      'name': name,
      'size': size,
      'type': type,
      'alignment': alignment,
      'cr': cr,
      'xp': cr != null ? calcXP(cr) : null,
      'proficiency_bonus': cr != null ? proficiencyBonus(this.cr!) : null,
      'ac': ac,
      'hit_points': hit_points,
      'hit_dice': hit_dice,
      'speed': speed,
      'ability_scores': ability_scores,
      'saving_throws': saving_throws,
      'skills': skills,
      'condition_immunities': condition_immunities, // Added to toMap
      'damage_resistances': damage_resistances,
      'damage_immunities': damage_immunities,
      'damage_vulnerabilities': damage_vulnerabilities,
      'senses': senses,
      'languages': languages,
      'special_abilities': special_abilities,
      'actions': actions,
      'legendary_actions': legendary_actions,
      'monster_description': monster_description,
      'image_url': image_url,
      'creator_id': creator_id ?? FirebaseAuth.instance.currentUser?.uid,
      'created_at': created_at ?? DateTime.now(),
    };
  }

  upload(context, monsterMap) async {
    final db = FirebaseFirestore.instance;
    String id = db
        .collection('Monsters')
        .doc()
        .id;
    if (image != null) {
      image_url = await storeChild(id, image, context);
    } //todo decide whether to wait or not
    db.collection('Monsters').doc(id).set(monsterMap)
        .onError((e, _) =>
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error writing document: $e"),
          duration: const Duration(seconds: 5),
        )));
  }

  static Future<bool> doesDocumentExist(String collectionPath,
      String documentId) async {
    try {
      DocumentReference docRef = FirebaseFirestore.instance.collection(
          collectionPath).doc(documentId);
      DocumentSnapshot docSnapshot = await docRef.get();
      return docSnapshot.exists;
    } catch (e) {
      print("Error checking document existence: $e"); //todo logcat it
      return false; //  Return false on error, or rethrow as needed.
    }
  }

  update(context, Map monsterMap, id) async {
    final db = FirebaseFirestore.instance;
    if (image != null) {
      image_url = await storeChild(id, image, context);
    } //todo decide whether to wait or not
    monsterMap.remove(created_at);
    monsterMap.remove(creator_id);
    var uploadMonsterMap = monsterMap.cast<Object, Object?>();
    db.collection('Monsters').doc(id).update(uploadMonsterMap)
        .onError((e, _) =>
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error writing document: $e"),
          duration: const Duration(seconds: 5),
        )));
  }

  int proficiencyBonus(double cr) {
    if (cr == 0) return 2;
    return ((cr - 1) / 4).floor() + 2;
  }

  validate(context, bool newMonster, id) {
    Map monsterMap = toMap();
    final validation = [
      'name',
      'size',
      'type',
      'alignment',
      'ac',
      'hit_points',
      'cr'
    ];
    String missing = '';
    for (var field in validation) {
      if (field == 'ac' && monsterMap['ac']['value'] == null) {
        missing += '$field, ';
      }
      if (monsterMap[field] == null) {
        missing += '$field, ';
      }
    }
    //Map<String,dynamic> scores = monsterMap['ability_scores'];
    for (var stat in monsterMap['ability_scores'].keys) {
      if (monsterMap['ability_scores'][stat] == null) {
        missing += '${stat.substring(0, 3)}, ';
      }
    }
    if (missing == '') {
      if (newMonster == false) {
        update(context, monsterMap, id);
      }
      else {
        upload(context, monsterMap);
      }
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Missing fields: ${missing.substring(0, missing.length - 2)}")));
    }
  }

  calcXP(cr) {
    final Map<double, int> crToXp = {
      0: 10,
      0.125: 25,
      0.25: 50,
      0.5: 100,
      1: 200,
      2: 450,
      3: 700,
      4: 1100,
      5: 1800,
      6: 2300,
      7: 2900,
      8: 3900,
      9: 5000,
      10: 5900,
      11: 7200,
      12: 8400,
      13: 10000,
      14: 11500,
      15: 13000,
      16: 15000,
      17: 18000,
      18: 20000,
      19: 22000,
      20: 25000,
      21: 33000,
      22: 41000,
      23: 50000,
      24: 62000,
      25: 75000,
      26: 90000,
      27: 105000,
      28: 120000,
      29: 135000,
      30: 155000,
    };
    return crToXp[cr];
  }
}