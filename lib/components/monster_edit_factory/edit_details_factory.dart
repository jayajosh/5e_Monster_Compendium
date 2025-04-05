import 'package:flutter/material.dart';

addDetailsNumberRow(data,String field) {
  if (data[field].isNotEmpty) {
    var rowString = '';
    for (var i in data[field].keys) {
      var rowLine = '';
      rowLine = '$i +${data[field][i]}';
      if (i != data[field].keys.last) {
        rowLine += ', ';
      }
      rowLine = (rowLine[0].toUpperCase() + rowLine.substring(1));
      rowString += rowLine;
    }
    return Text.rich(
        TextSpan(
            children: [
              TextSpan(text: '${field[0].toUpperCase()}${field.substring(1)} ',
                style: TextStyle(fontWeight: FontWeight.w900),),
              TextSpan(text: rowString)
            ])
    );
  }
  return SizedBox.shrink();
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

  Widget detailTextRow(controller) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: 45,
      width: size.width / 2, //todo fix widths to match
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
        child: Center(
          child: TextField(
            maxLines: 1,
            controller: controller,
            decoration: const InputDecoration(  // <-- Add InputDecoration here
              border: OutlineInputBorder(),       // <-- This is the key:  Outline border
              // You can also use other border types, e.g.,
              // border: UnderlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10), //optional
            ),
          ),
        ),
      ),
    );
    }

  makeDetailsRow() {
    List<Widget> detailTextRows = [];

    controllers.forEach((rowIndex, controller) {
      detailTextRows.add(detailTextRow(controller));
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
            width: MediaQuery.of(context).size.width / 2.075, //todo fix widths to match
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

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width /2.4,
            child: Text(widget.field)
        ),
        Container(width: 8),
        Column(
          children: makeDetailsRow(),
        )
      ],
    );
  }

}

addDetailsSensesRow(data, field){
  if (data[field].isNotEmpty) {
    var rowString = '';
    for (var i in data[field].keys) {
      var rowLine = '';
      rowLine = '$i ${data[field][i].toString()}';
      if (i != data[field].keys.last) {
        rowLine += ', ';
      }
      rowLine = (rowLine[0].toUpperCase() + rowLine.substring(1));
      rowString += rowLine;
    }
    return Text.rich(
        TextSpan(
            children: [
              TextSpan(text: field[0].toUpperCase() + field.substring(1) + ' ',
                style: TextStyle(fontWeight: FontWeight.w900),),
              TextSpan(text: rowString)
            ])
    );
  }
  return SizedBox.shrink();
}

addDetailsTraitsBlock(data){
  List<Widget> traitsBlock = [];
  if (data['special_abilities'].isNotEmpty) {
    traitsBlock.add(otherDetailsCheck(data,Divider()));
    traitsBlock.add(Center(child: Text('Traits', style: TextStyle(fontWeight: FontWeight.w900))));
    for(var i in data['special_abilities']){
      traitsBlock.add(Text.rich(TextSpan(children: [TextSpan(text: i['name']+' ', style: TextStyle(fontWeight: FontWeight.w900)),TextSpan(text: i['desc'])])));
      if(i != data['special_abilities'].last){traitsBlock.add(Text(''));}
    }
  }
  return traitsBlock;
}

otherDetailsCheck(data,returnWidget){
  if(data['saving_throws'].isEmpty && data['skills'].isEmpty && data['damage_resistances'].isEmpty && data['damage_immunities'].isEmpty && data['damage_vulnerabilities'].isEmpty && data['senses'].isEmpty && data['languages'].isEmpty){
    return SizedBox.shrink();
  }
  return returnWidget;
}

addDetails() {
  TextEditingController resistances = new TextEditingController();
  TextEditingController immunities = new TextEditingController();
  TextEditingController vulnerabilities = new TextEditingController();
  TextEditingController languages = new TextEditingController();


  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      //otherDetailsCheck(data,Center(child: Text('Other Details', style: TextStyle(fontWeight: FontWeight.w900)))),
      //addDetailsNumberRow(data,'saving_throws'),
      //Divider(thickness: 0.25,),
      //addDetailsNumberRow(data,'skills'),
      //Divider(thickness: 0.25,),
      AddDetailsTextRow(field: 'damage_resistances'),
      Divider(thickness: 0.25,),
      AddDetailsTextRow(field: 'damage_immunities'),
      Divider(thickness: 0.25,),
      AddDetailsTextRow(field: 'damage_vulnerabilities'),
      Divider(thickness: 0.25,),
      //addDetailsSensesRow(data,'senses'),
      AddDetailsTextRow(field: 'languages'),
      Divider(),

      //if(data.data().containsKey('special_abilities'))for(var i in addDetailsTraitsBlock(data)) i,
    ],
  );
}