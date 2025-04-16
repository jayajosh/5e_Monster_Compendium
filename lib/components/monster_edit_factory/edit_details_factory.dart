import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monster_compendium/services/monster_storage.dart';

class AddDetailsNumberRow extends StatefulWidget {
  final String field;
  final MonsterStore monsterStore;

  const AddDetailsNumberRow({super.key, required this.field, required this.monsterStore});

  @override
  _AddDetailsNumberRow createState() => _AddDetailsNumberRow();

}

class _AddDetailsNumberRow extends State<AddDetailsNumberRow> {

  @override
  void dispose() {
    super.dispose();
    controllers.forEach((index, controller){
      controller?.dispose();
    }
    );
    numControllers.forEach((index, controller){
      controller?.dispose();
    }
    );
  }

  Map<String,double> getData(){
    Map<String,double> data = {};
    controllers.forEach((index,controller){
      data[controller!.text] = double.tryParse(numControllers[index]!.text)!;
    });
    return data;
  }

  Map<int,TextEditingController?> controllers = {};
  Map<int,TextEditingController?> numControllers = {};


  setControllers(){ //todo fix running when dialog closes
    int index = 0;
    final _field = widget.monsterStore.toMap()[widget.field];
      if(_field.isNotEmpty) {
        _field.keys.forEach((row){
          controllers[index] = new TextEditingController();
          controllers[index]?.text = row;
          numControllers[index] = new TextEditingController();
          numControllers[index]?.text = _field[row].toString();
          index += 1;
        });
      }
    }

  Widget detailNumberRow(key,controller) {
    return Container(
      height: 45,
      child: Center(
        child: Row(
          children: [
            Expanded( // Name
              child: TextField(
                maxLines: 1,
                controller: controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ),
            Container(width: 8),
            Container( // Value
              width: 60,
              child: TextField(
                maxLines: 1,
                controller: numControllers[key],
                keyboardType: TextInputType.number, // Set keyboard type
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly, // Allow only digits
                ],
                decoration: const InputDecoration(
                  prefix: Text('+'),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: InkWell(
                onTap:() {
                  setState(() {
                    controllers.remove(key);
                    numControllers.remove(key);
                  })
                  ;},
                child: Icon(CupertinoIcons.delete,color: Colors.red,),
              ),
            ),
          ],
        ),
      ),
    );
  }

  makeDetailsRow() {
    List<Widget> detailNumberRows = [];

    controllers.forEach((rowIndex, controller) {
      detailNumberRows.add(detailNumberRow(rowIndex,controller));
      detailNumberRows.add(Container(height: 8));
    });

    detailNumberRows.add(
      Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              int newRowIndex = controllers.keys.length;
              controllers[newRowIndex] =
              new TextEditingController();
              numControllers[newRowIndex] =
              new TextEditingController();
            });
          },
          child: Container(
            //width: MediaQuery.of(context).size.width / 1.6, //todo fix widths to match
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.onSurface),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row( //todo make an action
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Add'),
                  Icon(Icons.add_circle_outline),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return detailNumberRows;
  }

  rowName(){ //Todo add to monster view
    List<String> nameList = widget.field.split('_');
    String name = '';
    for (var n in nameList) {
      if (n.isNotEmpty) {
        name += '${n[0].toUpperCase()}${n.substring(1)} ';
      }
    }
    return name.trim();
  }

  @override
  Widget build(BuildContext context) {
    setControllers();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: MediaQuery.of(context).size.width /3.33,
              child: Text(rowName(),style: TextStyle(fontWeight: FontWeight.w900))
          ),
          Container(width: 8),
          Expanded(
            child: Column(
              children: makeDetailsRow(),
            ),
          )
        ],
      ),
    );
  }

}

class AddDetailsTextRow extends StatefulWidget {
  final String field;
  final MonsterStore monsterStore;

  const AddDetailsTextRow({super.key, required this.field, required this.monsterStore});

  @override
  _AddDetailsTextRow createState() => _AddDetailsTextRow();

}

class _AddDetailsTextRow extends State<AddDetailsTextRow> {

  @override
  void dispose() {
    super.dispose();
    controllers.forEach((index, controller){
      controller?.dispose();
    }
    );
  }

  List<String> getData(){
    List<String> data = [];
    controllers.forEach((index,controller){
      data.add(controller!.text);
    });
    return data;
  }

  Map<int,TextEditingController?> controllers = {};

  Widget detailTextRow(key,controller) {
    //final size = MediaQuery.of(context).size;

    return Container(
      height: 45,
      child: Center(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                maxLines: 1,
                controller: controller,
                decoration: const InputDecoration(  // <-- Add InputDecoration here
                  border: OutlineInputBorder(),       // <-- This is the key:  Outline border
                  // You can also use other border types, e.g.,
                  // border: UnderlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8), //optional
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: InkWell(
                onTap:() {
                  setState(() {
                    controllers.remove(key);
                  })
                  ;},
                child: Icon(CupertinoIcons.delete,color: Colors.red,),
              ),
            ),
          ],
        ),
      ),
    );
  }

  makeDetailsRow() {
    List<Widget> detailTextRows = [];

    controllers.forEach((rowIndex, controller) {
      detailTextRows.add(detailTextRow(rowIndex,controller));
      detailTextRows.add(Container(height: 8));
    });

    detailTextRows.add(
      Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              int newRowIndex = controllers.keys.length;
              controllers[newRowIndex] =
              new TextEditingController();
            });
          },
          child: Container(
            //width: MediaQuery.of(context).size.width / 1.6, //todo fix widths to match
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.onSurface),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row( //todo make an action
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Add'),
                  Icon(Icons.add_circle_outline),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return detailTextRows;
  }

  rowName(){ //Todo add to monster view
    List<String> nameList = widget.field.split('_');
    String name = '';
    for (var n in nameList) {
      if (n.isNotEmpty) {
        name += '${n[0].toUpperCase()}${n.substring(1)} ';
      }
    }
    return name.trim();
  }

  setControllers(){ //todo fix running when dialog closes
    int index = 0;
    final _field = widget.monsterStore.toMap()[widget.field];
    if(_field.isNotEmpty) {
      _field.forEach((row){
        controllers[index] = new TextEditingController();
        controllers[index]?.text = row;
        index += 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    setControllers();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: MediaQuery.of(context).size.width /3.33,
              child: Text(rowName(),style: TextStyle(fontWeight: FontWeight.w900))
          ),
          Container(width: 8),
          Expanded(
            child: Column(
              children: makeDetailsRow(),
            ),
          )
        ],
      ),
    );
  }

}

class AddDetailsSensesRow extends StatefulWidget {
  final String field;
  final MonsterStore monsterStore;

  const AddDetailsSensesRow({super.key, required this.field, required this.monsterStore});

  @override
  _AddDetailsSensesRow createState() => _AddDetailsSensesRow();

}

class _AddDetailsSensesRow extends State<AddDetailsSensesRow> {

  @override
  void dispose() {
    super.dispose();
    controllers.forEach((index, controller){
      controller?.dispose();
    }
    );
    numControllers.forEach((index, controller){
      controller?.dispose();
    }
    );
  }

  Map<String,String> getData(){
    Map<String,String> data = {};
    controllers.forEach((index,controller){
      data[controller!.text] = numControllers[index]!.text;
    });
    return data;
  }

  Map<int,TextEditingController?> controllers = {};
  Map<int,TextEditingController?> numControllers = {};

  Widget detailSensesRow(key,controller) {
    //final size = MediaQuery.of(context).size;

    return Container(
      height: 45,
      child: Center(
        child: Row(
          children: [
            Expanded( // Name
              child: TextField(
                maxLines: 1,
                controller: controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ),
            Container(width: 8),
            Container( // Value
              width: 60,
              child: TextField(
                maxLines: 1,
                controller: numControllers[key],
                keyboardType: TextInputType.number, // Set keyboard type
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly, // Allow only digits
                ],
                decoration: const InputDecoration(
                  suffix: Text('ft.'),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: InkWell(
                onTap:() {
                  setState(() {
                    controllers.remove(key);
                    numControllers.remove(key);
                  })
                  ;},
                child: Icon(CupertinoIcons.delete,color: Colors.red,),
              ),
            ),
          ],
        ),
      ),
    );
  }

  makeDetailsRow() {
    List<Widget> detailSensesRows = [];

    controllers.forEach((rowIndex, controller) {
      detailSensesRows.add(detailSensesRow(rowIndex,controller));
      detailSensesRows.add(Container(height: 8));
    });

    detailSensesRows.add(
      Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              int newRowIndex = controllers.keys.length;
              controllers[newRowIndex] =
              new TextEditingController();
              numControllers[newRowIndex] =
              new TextEditingController();
            });
          },
          child: Container(
            //width: MediaQuery.of(context).size.width / 1.6, //todo fix widths to match
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.onSurface),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row( //todo make an action
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Add'),
                  Icon(Icons.add_circle_outline),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return detailSensesRows;
  }

  rowName(){ //Todo add to monster view
    List<String> nameList = widget.field.split('_');
    String name = '';
    for (var n in nameList) {
      if (n.isNotEmpty) {
        name += '${n[0].toUpperCase()}${n.substring(1)} ';
      }
    }
    return name.trim();
  }

  setControllers(){ //todo fix running when dialog closes
    int index = 0;
    final _field = widget.monsterStore.toMap()[widget.field];
    if(_field.isNotEmpty) {
      _field.keys.forEach((row){
        controllers[index] = new TextEditingController();
        controllers[index]?.text = row;
        numControllers[index] = new TextEditingController();
        numControllers[index]?.text = _field[row].replaceAll(' ft.', '');
        index += 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    setControllers();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: MediaQuery.of(context).size.width /3.33,
              child: Text(rowName(),style: TextStyle(fontWeight: FontWeight.w900))
          ),
          Container(width: 8),
          Expanded(
            child: Column(
              children: makeDetailsRow(),
            ),
          )
        ],
      ),
    );
  }

}

class AddDetailsTraitsRow extends StatefulWidget {
  final MonsterStore monster;

  const AddDetailsTraitsRow({super.key, required this.monster});

  @override
  _AddDetailsTraitsRow createState() => _AddDetailsTraitsRow();

}

class _AddDetailsTraitsRow extends State<AddDetailsTraitsRow> {

  @override
  void dispose() {
    super.dispose();
    traitControllers.forEach((index, controller){
      controller?.dispose();
    }
    );
    descControllers.forEach((index, controller){
      controller?.dispose();
    }
    );
  }

  List<Map<String,String>> getData(){
    List<Map<String,String>> data = [];
    traitControllers.forEach((index,controller){
      data.add({'name':controller!.text,'desc':descControllers[index]!.text});
    });
    return data;
  }

  Map<int,TextEditingController?> traitControllers = {};
  Map<int,TextEditingController?> descControllers = {};

  Widget traitsRow(key,controller) {
    //final size = MediaQuery.of(context).size;
    return Container(
      //height: 45,
      child: Center(
        child: Column(
          children: [
            Row(
              children: [
                Expanded( // Name
                  child: TextField(
                    maxLines: 1,
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Trait Name',
                      labelText: 'Trait Name',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: InkWell(
                    onTap:() {
                      setState(() {
                        traitControllers.remove(key);
                        descControllers.remove(key);
                      })
                      ;},
                    child: Icon(CupertinoIcons.delete,color: Colors.red,),
                  ),
                ),
              ],
            ),
            Container(height: 8),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Container( // Value
                child: TextField(
                  maxLines: null,
                  controller: descControllers[key],
                  decoration: const InputDecoration(
                    hintText: 'Trait Description',
                    labelText: 'Trait Description',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ),
            ),
            Divider(thickness: 0.25,)
          ],
        ),
      ),
    );
  }

  makeTraitsRow() {
    List<Widget> traitsRows = [];

    traitControllers.forEach((rowIndex, controller) {
      traitsRows.add(traitsRow(rowIndex,controller));
      traitsRows.add(Container(height: 8));
    });

    traitsRows.add(
      Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              int newRowIndex = traitControllers.keys.length;
              traitControllers[newRowIndex] =
              new TextEditingController();
              descControllers[newRowIndex] =
              new TextEditingController();
            });
          },
          child: Container(
            //width: MediaQuery.of(context).size.width / 1.6, //todo fix widths to match
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.onSurface),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row( //todo make an action
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Add Trait'),
                  Icon(Icons.add_circle_outline),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return traitsRows;
  }

  setControllers() {//todo fix running when dialog closes
    int index = 0;
    final _field = widget.monster.toMap()['special_abilities'];
    if (_field.isNotEmpty) {
      _field.forEach((row) {
          traitControllers[index] = new TextEditingController();
          traitControllers[index]?.text = row['name'];
          descControllers[index] = new TextEditingController();
          descControllers[index]?.text = row['desc'];
          index += 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    setControllers();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: makeTraitsRow(),
            ),
          )
        ],
      ),
    );
  }

}

class AddDetails {

  final MonsterStore monster;
  AddDetails({required this.monster});

  //late AddDetailsNumberRow Saving;// = AddDetailsNumberRow(field: 'saving_throws', monsterStore: monster);
  final GlobalKey<_AddDetailsNumberRow> savingKey = GlobalKey<_AddDetailsNumberRow>();
  final GlobalKey<_AddDetailsNumberRow> skillsKey = GlobalKey<_AddDetailsNumberRow>();
  final GlobalKey<_AddDetailsTextRow> conditionKey = GlobalKey<_AddDetailsTextRow>();
  final GlobalKey<_AddDetailsTextRow> resistancesKey = GlobalKey<_AddDetailsTextRow>();
  final GlobalKey<_AddDetailsTextRow> immunitiesKey = GlobalKey<_AddDetailsTextRow>();
  final GlobalKey<_AddDetailsTextRow> vulnerabilitiesKey = GlobalKey<_AddDetailsTextRow>();
  final GlobalKey<_AddDetailsSensesRow> sensesKey = GlobalKey<_AddDetailsSensesRow>();
  final GlobalKey<_AddDetailsTextRow> languagesKey = GlobalKey<_AddDetailsTextRow>();
  final GlobalKey<_AddDetailsTraitsRow> traitsKey = GlobalKey<_AddDetailsTraitsRow>();

  updateStorage(){
    final savingData = savingKey.currentState!.getData();
    monster.saving_throws = savingData;

    final skillsData = skillsKey.currentState!.getData();
    monster.skills = skillsData;

    final conditionData = conditionKey.currentState!.getData();
    monster.condition_immunities = conditionData;

    final resistancesData = resistancesKey.currentState!.getData();
    monster.damage_resistances = resistancesData;

    final immunitiesData = immunitiesKey.currentState!.getData();
    monster.damage_immunities = immunitiesData;

    final vulnerabilitiesData = vulnerabilitiesKey.currentState!.getData();
    monster.damage_vulnerabilities = vulnerabilitiesData;

    final sensesData = sensesKey.currentState!.getData();
    monster.senses = sensesData;

    final languagesData = languagesKey.currentState!.getData();
    monster.languages = languagesData;

    final traitsData = traitsKey.currentState!.getData();
    monster.special_abilities = traitsData;

  }

  Widget build() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddDetailsNumberRow(field: 'saving_throws', monsterStore: monster, key: savingKey),
        Divider(thickness: 0.25,),
        AddDetailsNumberRow(field: 'skills', monsterStore: monster, key: skillsKey),
        Divider(thickness: 0.25,),
        AddDetailsTextRow(field: 'condition_immunities', monsterStore: monster, key: conditionKey),
        Divider(thickness: 0.25,),
        AddDetailsTextRow(field: 'damage_resistances', monsterStore: monster, key: resistancesKey),
        Divider(thickness: 0.25,),
        AddDetailsTextRow(field: 'damage_immunities', monsterStore: monster, key: immunitiesKey),
        Divider(thickness: 0.25,),
        AddDetailsTextRow(
            field: 'damage_vulnerabilities', monsterStore: monster, key: vulnerabilitiesKey),
        Divider(thickness: 0.25,),
        AddDetailsSensesRow(field: 'senses', monsterStore: monster, key: sensesKey),
        Divider(thickness: 0.25,),
        AddDetailsTextRow(field: 'languages', monsterStore: monster, key: languagesKey),
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Center(child: Text(
              'Traits', style: TextStyle(fontWeight: FontWeight.w900))),
        ),
        AddDetailsTraitsRow(monster: monster, key: traitsKey)
      ],
    );
  }
}