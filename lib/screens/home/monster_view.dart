import 'package:flutter/material.dart';
import 'package:monster_compendium/components/photo_border.dart';
import '../../components/stat_icons.dart';

ValueNotifier<int> indexNotifier = ValueNotifier<int>(0);

class MonsterView extends StatefulWidget {
  @override
  _MonsterView createState() => _MonsterView();
}

class _MonsterView extends State<MonsterView>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: photoBorder( const Image(
                      image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.symmetric( horizontal: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                      ),
                      child: Column(
                        children: [
                          Row( //todo center better
                            children: [
                              Center(child: Text('Challenge',style: TextStyle(fontWeight: FontWeight.bold))),
                              Center(child: Text('12')),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      Icon(Icons.shield_outlined,color: Theme.of(context).colorScheme.secondary,size:64),
                                      Column(
                                        children: [
                                          Text('12',style: TextStyle(fontWeight: FontWeight.bold)),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      Icon(Icons.favorite_outline,color: Theme.of(context).colorScheme.secondary,size:64),
                                      Text('12',style: TextStyle(fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text('Speed 30ft.,\nswim 30ft.,\nfly n/a.'), //todo bold Speed
                        ],
                      )
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              margin: EdgeInsets.symmetric( horizontal: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              child: Row(
                children: [
                  statBlock(context,'STR',12,'+10'),
                  statBlock(context,'DEX',12,'+1'),
                  statBlock(context,'CON',12,'+1'),
                  statBlock(context,'INT',12,'+1'),
                  statBlock(context,'WIS',12,'+1'),
                  statBlock(context,'CHA',12,'+1'),
                ],
              ),
             // todo add a 'bottom nav bar' for like, bookmark and comment?? or add to app bar
            ),
            Expanded(child: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                margin: EdgeInsets.fromLTRB(8,10,8,32), // todo fix all margins
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                child: Column(
                  children: [
                    ValueListenableBuilder<int>(
                      valueListenable: indexNotifier,
                      builder: (context, index, child) {
                        return Row(
                          children: [
                            infoButton(context,Icons.list_alt,'Details',0),
                            infoButton(context,Icons.star,'Actions',1),
                            infoButton(context,Icons.menu_book_outlined,'Description',2),
                          ],
                        );
                      },),
                    Divider(),
                    Expanded( // Add this to allow scrolling inside
                      child: SingleChildScrollView(
                        child: ValueListenableBuilder<int>(
                          valueListenable: indexNotifier,
                          builder: (context, index, child) {
                            return choser(index); // Call function instead of using a class
                          },
                        ),
                      ),
                    )
                  ],
                )
            ),
            )
          ],
        ),
        appBar: AppBar(
          elevation: 0.0,
          titleSpacing: 10.0,
          title: Text('Monster Name'),
          bottom: PreferredSize(preferredSize: Size.zero,
              child: Text('Size Type, Alignment')),
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
            ),
          ),
        )
    );
  }
}

statBlock(context,stat,value,modifier) { // todo modifier code based //todo stat full length, trunc to 3 and capitalise
  return Flexible(
    child: Column(
        mainAxisSize: MainAxisSize.min,
        children:[
          Flexible(child: Center(child: Text(stat,style: TextStyle(fontWeight: FontWeight.bold)))),
          Flexible(child:
          Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Icon(Stat.stat,size: 60),
                Column(children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0,0,0,8),
                    child: Text(value.toString(),style: TextStyle(fontWeight: FontWeight.w900)),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0,0,0,2),
                    child: Text(modifier,style: TextStyle(color: Theme.of(context).colorScheme.onSecondary,fontWeight: FontWeight.w900),), //todo update text colour or fix frame
                  )
                ])
              ])),
        ]),
  );
}

infoButton(context,IconData icon,String name,int i) { //todo rename
  var selectedColor = Theme.of(context).colorScheme.onSurface;
  if(indexNotifier.value == i){selectedColor = Theme.of(context).colorScheme.secondary;}
  return Expanded(
    child: InkWell(
      child: Column(
        children: [
          Icon(icon,color: selectedColor,),
          Text(name, style: TextStyle(color: selectedColor),),
        ],
      ),
      onTap: (){indexNotifier.value = i;},
    ),
  );
}

details() {
  return Column(
    children: [
      Text('Skills: Perception +3'),
      Text('Resistances: Necrotic'),
      Text('Resistances: Necrotic'),
      Text('Resistances: Necrotic'),
      Text('Resistances: Necrotic'),
      Text('Languages: Necrotic'),

      Text('Traits', style: TextStyle(fontWeight: FontWeight.w900)),
      Divider(),
      Text('''Legendary Resistance (3/Day). If the tarrasque fails a saving throw, it can choose to succeed instead.
\n
          Magic Resistance. The tarrasque has advantage on saving throws against spells and other magical effects.
\n
          Reflective Carapace. Any time the tarrasque is targeted by a magic missile spell, a line spell, or a spell that requires a ranged attack roll, roll a d6. On a 1 to 5, the tarrasque is unaffected. On a 6, the tarrasque is unaffected, and the effect is reflected back at the caster as though it originated from the tarrasque, turning the caster into the target.
\n
          Siege Monster. The tarrasque deals double damage to objects and structures.''')

    ],
  );
}

Widget choser(int index) {
  if (index == 0) {
    return details();
  } else if (index == 1) {
    return Text('aahhh');
  } else {
    return Text('bbhhh');
  }
}
