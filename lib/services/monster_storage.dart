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
  String? hit_points;
  String? hit_dice;
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

  String? monster_description;

  String? image_url;
  File? image;

  String creator_id = '';
  DateTime created_at = DateTime.now();

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
  })  : ac = ac ?? {'type': null, 'value': null},
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
            condition_immunities ?? [], // Initialize in initializer list
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
    // Converts firestore to class
    return MonsterStore(
      name: map['name'],
      size: map['size'],
      type: map['type'],
      alignment: map['alignment'],
      cr: map['cr'] is int ? (map['cr'] as int).toDouble() : map['cr'],
      //handles int or double
      ac: map['ac'] is Map ? Map<String, dynamic>.from(map['ac']) : {
        'type': null,
        'value': null
      },
      hit_points: map['hit_points'],
      hit_dice: map['hit_dice'],
      speed: map['speed'] is Map ? Map<String, String?>.from(map['speed']) : {},
      ability_scores: map['ability_scores'] is Map
          ? Map<String, int?>.from(map['ability_scores'])
          : {},
      saving_throws: map['saving_throws'] is Map
          ? Map<String?, double?>.from(map['saving_throws'])
          : {},
      skills: map['skills'] is Map
          ? Map<String?, double?>.from(map['skills'])
          : {},
      condition_immunities: map['condition_immunities'] is List // Added fromMap
          ? List<String?>.from(map['condition_immunities'])
          : [],
      damage_resistances: map['damage_resistances'] is List
          ? List<String?>.from(map['damage_resistances'])
          : [],
      damage_immunities: map['damage_immunities'] is List
          ? List<String?>.from(map['damage_immunities'])
          : [],
      damage_vulnerabilities: map['damage_vulnerabilities'] is List
          ? List<String?>.from(map['damage_vulnerabilities'])
          : [],
      senses: map['senses'] is Map ? Map<String?, String?>.from(map['senses']) : {},
      languages:
      map['languages'] is List ? List<String?>.from(map['languages']) : [],
      special_abilities: map['special_abilities'] is List
          ? (map['special_abilities'] as List)
          .map((item) => Map<String?, String?>.from(item))
          .toList()
          : [],
      actions: map['actions'] is List
          ? (map['actions'] as List)
          .map((item) => Map<String?, String?>.from(item))
          .toList()
          : [],
      legendary_actions: map['legendary_actions'] is List
          ? (map['legendary_actions'] as List)
          .map((item) => Map<String?, String?>.from(item))
          .toList()
          : [],
      monster_description: map['monster_description'],
      image_url: map['image_url'],
      creator_id: map['creator_id'] ?? '',
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
      'xp': calcXP(cr),
      'proficiency_bonus': proficiencyBonus(this.cr!),
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
      'creator_id': FirebaseAuth.instance.currentUser?.uid,
      'created_at': DateTime.now(),
    };
  }

  upload(context) async {
    final db = FirebaseFirestore.instance;
    String id = db.collection('Monsters').doc().id;
    image_url = await storeChild(id,image,context); //todo decide whether to wait or not
    db.collection('Monsters').doc(id).set(toMap())
        .onError((e, _) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Error writing document: $e"),
      duration: const Duration(seconds: 5),
    )));

  }

    int proficiencyBonus(double cr) {
      if (cr == 0) return 2;
      return ((cr - 1) / 4).floor() + 2;
    }
}

calcXP(cr){
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