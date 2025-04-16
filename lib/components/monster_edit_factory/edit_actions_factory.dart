import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/monster_storage.dart';

class AddActionsRow extends StatefulWidget {
  final String field;
  final MonsterStore monster;

  const AddActionsRow({super.key, required this.field, required this.monster});

  @override
  _AddActionsRow createState() => _AddActionsRow();

}
class _AddActionsRow extends State<AddActionsRow> {

  @override
  void dispose() {
    super.dispose();
    controllers.forEach((index, controller){
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
    controllers.forEach((index,controller){
      data.add({'name':controller!.text,'desc':descControllers[index]!.text});
    });
    return data;
  }

  Map<int,TextEditingController?> controllers = {};
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
                    decoration: InputDecoration(
                      hintText: '${widget.field} Name',
                      labelText: '${widget.field} Name',
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
                  decoration: InputDecoration(
                    hintText: '${widget.field} Description',
                    labelText: '${widget.field} Description',
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

  setControllers(){ //todo fix running when dialog closes
    int index = 0;
  if(widget.field == 'legendary_actions'){
    if(widget.monster.legendary_actions.isNotEmpty) {
      widget.monster.legendary_actions.forEach((Map action){
        controllers[index] = new TextEditingController();
        controllers[index]?.text = action['name'];
        descControllers[index] = new TextEditingController();
        descControllers[index]?.text = action['name'];
        index += 1;
      });
    }
  }
  else{

      setState(() {
        widget.monster.actions.forEach((Map action){
          controllers[index] = new TextEditingController();
          controllers[index]?.text = action['name'];
          descControllers[index] = new TextEditingController();
          descControllers[index]?.text = action['name'];
          index += 1;
        });
      });

  }}

  makeTraitsRow() {
    List<Widget> traitsRows = [];
    controllers.forEach((rowIndex, controller) {
      traitsRows.add(traitsRow(rowIndex,controller));
      traitsRows.add(Container(height: 8));
    });

    traitsRows.add(
      Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              int newRowIndex = controllers.keys.length;
              controllers[newRowIndex] =
              new TextEditingController();
              descControllers[newRowIndex] =
              new TextEditingController();
            });
          },
          child: Container(
            //width: MediaQuery.of(context).size.width / 1.6, //todo fix widths to match
            decoration: BoxDecoration(
              //border: Border.all(color: Theme.of(context).colorScheme.onSurface),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row( //todo make an action
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Add ${widget.field}'),
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

class AddActions {

  final MonsterStore monster;
  AddActions({required this.monster});

  final GlobalKey<_AddActionsRow> actionsKey = GlobalKey<_AddActionsRow>();
  final GlobalKey<_AddActionsRow> legendaryActionsKey = GlobalKey<_AddActionsRow>();

  updateStorage() {
    monster.actions = actionsKey.currentState!.getData();
    monster.legendary_actions = legendaryActionsKey.currentState!.getData();
  }

  Widget build() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Center(child: Text(
              'Actions', style: TextStyle(fontWeight: FontWeight.w900))),
        ),
        AddActionsRow(field: 'Action',key: actionsKey, monster: monster),
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Center(child: Text('Legendary Actions',
              style: TextStyle(fontWeight: FontWeight.w900))),
        ),
        AddActionsRow(field: 'Legendary Action',key: legendaryActionsKey, monster: monster)
      ],
    );
  }
}