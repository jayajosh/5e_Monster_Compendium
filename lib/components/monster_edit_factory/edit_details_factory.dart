import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddDetailsNumberRow extends StatefulWidget {
  final String field;

  const AddDetailsNumberRow({super.key, required this.field});

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

  Map<int,TextEditingController?> controllers = {};
  Map<int,TextEditingController?> numControllers = {};

  Widget detailNumberRow(key,controller) {
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

  const AddDetailsTextRow({super.key, required this.field});

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

  @override
  Widget build(BuildContext context) {
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

  const AddDetailsSensesRow({super.key, required this.field});

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

  @override
  Widget build(BuildContext context) {
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
  const AddDetailsTraitsRow({super.key});

  @override
  _AddDetailsTraitsRow createState() => _AddDetailsTraitsRow();

}

class _AddDetailsTraitsRow extends State<AddDetailsTraitsRow> {

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
            Container( // Value
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
            Divider(thickness: 0.25,)
          ],
        ),
      ),
    );
  }

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
    return traitsRows;
  }

  @override
  Widget build(BuildContext context) {
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

addDetails() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AddDetailsNumberRow(field: 'saving_throws'),
      Divider(thickness: 0.25,),
      AddDetailsNumberRow(field:'skills'),
      Divider(thickness: 0.25,),
      AddDetailsTextRow(field: 'damage_resistances'),
      Divider(thickness: 0.25,),
      AddDetailsTextRow(field: 'damage_immunities'),
      Divider(thickness: 0.25,),
      AddDetailsTextRow(field: 'damage_vulnerabilities'),
      Divider(thickness: 0.25,),
      AddDetailsSensesRow(field:'senses'),
      Divider(thickness: 0.25,),
      AddDetailsTextRow(field: 'languages'),
      Divider(),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Center(child: Text('Traits', style: TextStyle(fontWeight: FontWeight.w900))),
      ),
      AddDetailsTraitsRow()
      //todo add special abilities \/\/
      //if(data.data().containsKey('special_abilities'))for(var i in addDetailsTraitsBlock(data)) i,
    ],
  );
}