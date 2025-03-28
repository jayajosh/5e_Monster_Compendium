import 'package:flutter/material.dart';

detailsNumberRow(data,String field)
{
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

detailsTextRow(data,String field)
{
  if (data[field].isNotEmpty) {
    var rowString = '';
    for (var i in data[field]) {
      var rowLine = '';
      rowLine = (i + '');
      if (i != data[field].last) {
        rowLine += ', ';
      }
      rowLine = (rowLine[0].toUpperCase() + rowLine.substring(1));
      rowString += rowLine;
    }
    return Text.rich(
        TextSpan(
            children: [
              TextSpan(text: '${field[0].toUpperCase()}${field.substring(1)}',
                style: TextStyle(fontWeight: FontWeight.w900),),
              TextSpan(text: rowString)
            ])
    );
  }
  return SizedBox.shrink();
}

detailsSensesRow(data, field){
  if (data[field].isNotEmpty) {
    var rowString = '';
    for (var i in data[field].keys) {
      var rowLine = '';
      //rowLine = (i + ' ' + data[field][i].toString());
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

detailsTraitsBlock(data){
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

details(data) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      otherDetailsCheck(data,Center(child: Text('Other Details', style: TextStyle(fontWeight: FontWeight.w900)))),
      detailsNumberRow(data,'saving_throws'),
      detailsNumberRow(data,'skills'),
      detailsTextRow(data,'damage_resistances'),
      detailsTextRow(data,'damage_immunities'),
      detailsTextRow(data,'damage_vulnerabilities'),
      detailsSensesRow(data,'senses'),
      detailsTextRow(data,'languages'),

      if(data.data().containsKey('special_abilities'))for(var i in detailsTraitsBlock(data)) i,
    ],
  );
}