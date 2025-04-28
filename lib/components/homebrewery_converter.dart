import '../services/monster_factory.dart';
/* import json

with open("saru.json", "r") as json_data:
raw_statblock = json.load(json_data)
#print(raw_statblock)

def abilities_decoder(sbk):
ability_block = f""""""
for item in sbk:
ability_block += '***'+item['name']+'.*** '+item['desc']+'\n'
return ability_block

def extra_stats(sbk):
print(len(raw_statblock[sbk]))
if len(raw_statblock[sbk]) != 0:
print("job done")
return (('\n**'+(sbk).title()+'** :: ' + ', '.join(raw_statblock[sbk])).replace("_", " "))
else:
return ""

def stat(s):
return f"""{raw_statblock[s]} ({"+" if raw_statblock[s] >= 10 else ""}{int(raw_statblock[s]/2)-5})"""

#"{{monster,frame"

block = f"""
## {raw_statblock['name']}
*{raw_statblock['size']}, {raw_statblock['alignment']}*
___
**Armor Class** :: {raw_statblock['armor_class'][0]['value']} (chain mail, shield)
**Hit Points**  :: {raw_statblock['hit_points']}({raw_statblock['hit_points_roll']})
**Speed**  :: """

i = len(raw_statblock['speed'])
for item in raw_statblock['speed']:
print(raw_statblock['speed']['walk'])
i -= 1
if i == len(raw_statblock['speed'])-1:
block += raw_statblock['speed'][item] +", "
elif i !=0:
block += item + ' ' + raw_statblock['speed'][item] +", "
else:
block += item + ' ' + raw_statblock['speed'][item]

block += f"""
___
|  STR  |  DEX  |  CON  |  INT  |  WIS  |  CHA  |
|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|
|{stat('strength')}|{stat('dexterity')}|{stat('constitution')}|{stat('intelligence')}|{stat('wisdom')}|{stat('charisma')}|
___
"""
todo /\/\ done
#block += extra_stats('proficiencies')

block += extra_stats('damage_vulnerabilities')

block += extra_stats('damage_resistances')

block += extra_stats('damage_immunities')

block += extra_stats('condition_immunities')

block += extra_stats('senses') #add numbers

block += '\n**Languages** :: ' + raw_statblock['languages']

block += f"""
**Challenge** :: {raw_statblock['challenge_rating']} ({raw_statblock['xp']} XP) {{bonus **Proficiency Bonus** +3}}
___
"""

block += abilities_decoder(raw_statblock['special_abilities'])

block += '\n### Actions\n'

block += abilities_decoder(raw_statblock['actions'])

print (block) */

speedDecoder(monster){ //todo refactor so only walk gets text skipped
  String block = '';
  var index = monster.speed.length;
  for (var item in monster.speed.keys) {
    index -= 1;
    if (index == monster.speed.length - 1) {
      block += '${monster.speed[item]}, ';
    }
    else if (index !=0) {
      block += '${item} ${monster.speed[item]}, ';
    }
    else{
    block += '$item ${monster.speed[item]}';
        }
    }
  return block;
}

abilitiesDecoder(monsterAbilities){
  String ability_block = '';
  for (var item in monsterAbilities){
    ability_block += '***${item['name']}*** ${item['desc']}\n  ';
  }
  return ability_block;
}

statDecoder(value){
  String modifier;
  value <= 10 ? modifier = ((value-10)/2).truncate().toString():modifier = '+'+((value-10)/2).truncate().toString();
  return '$value ($modifier)';
}

extraStatsNumber(Map extraStat) { //todo fix python uploaded to flutter
  String extra_block = '';
  for (var item in extraStat.keys){
    extra_block += '${extraStat.keys.first} ${extraStat[item]},\n'; //todo check not last
  }
  return extra_block;
}

extraStatsText(extraStat) { //todo fix python uploaded to flutter
  String extra_block = '';
  for (var item in extraStat){
    extra_block += '$item, '; //todo check not last
  }
  return extra_block;
}

homebrewery(MonsterStore monster) {
  final mas = monster.ability_scores;
  String block = '''
{{monster,frame
  ## ${monster.name}
  *${monster.size} ${monster.type}, ${monster.alignment}*
  ___
  **Armor Class** :: ${monster.ac['value']} (${monster.ac['type']})
  **Hit Points** :: ${monster.hit_points}(${monster.hit_dice} todo Convert this to roll)
  **Speed** :: ''';
  block+= speedDecoder(monster);
  block += '''\n
  ___
  |  STR  |  DEX  |  CON  |  INT  |  WIS  |  CHA  |
  |:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|
  |${statDecoder(mas['strength'])}|${statDecoder(mas['dexterity'])}|${statDecoder(mas['constitution'])}|${statDecoder(mas['intelligence'])}|${statDecoder(mas['wisdom'])}|${statDecoder(mas['charisma'])}|
  ___
  ''';

  block += 'Saving Throws: ${extraStatsNumber(monster.saving_throws)} \n  ';

  block += 'Condition Immunities: ${extraStatsText(monster.condition_immunities)} \n  ';

  block += 'Damage Vulnerabilities: ${extraStatsText(monster.damage_vulnerabilities)} \n  ';

  block += 'Damage Resistances: ${extraStatsText(monster.damage_resistances)} \n  ';

  block += 'Damage Immunities: ${extraStatsText(monster.damage_immunities)} \n  ';

  block += '''
**Challenge** :: ${monster.cr} (${monster.calcXP(monster.cr)} XP) {{bonus **Proficiency Bonus** +3}}
  ___
  ''';

  block+= abilitiesDecoder(monster.special_abilities);

  print(block);
}
