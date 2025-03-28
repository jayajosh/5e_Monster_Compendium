import 'package:flutter/material.dart';

actionRow(data){
  List<Widget> actionsBlock = [];
  if (data.isNotEmpty) {
    for(var i in data) {
      actionsBlock.add(Text.rich(TextSpan(children: [TextSpan(text: i['name']+'. ', style: TextStyle(fontWeight: FontWeight.w900)),TextSpan(text: i['desc'])])));
      if(i != data.last){actionsBlock.add(Text(''));}
    }
  }
  return actionsBlock;
}

actions(data) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if(data['actions'].isNotEmpty)Center(child: Text('Actions', style: TextStyle(fontWeight: FontWeight.w900))),
      for(var i in actionRow(data['actions'])) i,
      if(data.data().containsKey('legendary_actions') && data['legendary_actions'].isNotEmpty && data['actions'].isNotEmpty)Divider(),
      if(data.data().containsKey('legendary_actions') && data['legendary_actions'].isNotEmpty)Center(child: Text('Legendary Actions', style: TextStyle(fontWeight: FontWeight.w900))),
      if(data.data().containsKey('legendary_actions'))for(var i in actionRow(data['legendary_actions'])) i,
    ],
  );
}