import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:monster_compendium/components/photo_border.dart';
import '../../../components/monster_fields.dart';
import '../../../components/monster_view_factory/actions_factory.dart';
import '../../../components/monster_view_factory/details_factory.dart';
import '../../../components/loading_shimmer.dart';
import '../../../components/stat_icons.dart';

ValueNotifier<int> indexNotifier = ValueNotifier<int>(0);
Widget noData = Center(child: Text("Data does not exist")); //todo column center and maybe add icon
//todo maybe refactor delete out /\/\/\


class AddMonster extends StatefulWidget {
  @override
  _AddMonster createState() => _AddMonster();
}

class _AddMonster extends State<AddMonster> {


  TextEditingController nameController = new TextEditingController();
  TextEditingController sizeController = new TextEditingController();
  TextEditingController typeController = new TextEditingController();
  TextEditingController alignmentController = new TextEditingController();
  TextEditingController crController = new TextEditingController();
  TextEditingController acController = new TextEditingController();
  TextEditingController hpController = new TextEditingController();
  TextEditingController pbController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: photoBorder(const Image(
                      image: NetworkImage(
                          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                    ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme
                              .of(context)
                              .colorScheme
                              .surfaceContainerLow,
                          borderRadius: BorderRadius.circular(
                              12), // Rounded corners
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Center(child: CrDropDown(controller: crController)),
                              ],
                            ),
                            Center(child: Row(
                              children: [
                                //todo make a drop down auto fill xp
                                //MonsterTextField(controller: pbController)
                              ],
                            )),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: MonsterIconButton(controller: acController,icon: Icons.shield_outlined,),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: MonsterIconButton(controller: acController,icon: Icons.favorite_outline,),
                                  ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(child:MoveSpeedButton()),
                            /*Text.rich(
                                TextSpan(text: '',
                                    children: [
                                      TextSpan(text:'Speed ',style: TextStyle(fontWeight: FontWeight.bold)),
                                      *//*TextSpan(text: statblock.get('speed')['walk']),
                                      if(statblock.get('speed')['burrow'] != null)TextSpan(text:', Burrow '+snapshot.data!.get('speed')['burrow']),
                                      if(statblock.get('speed')['climb'] != null)TextSpan(text:', Climb '+snapshot.data!.get('speed')['climb']),
                                      if(statblock.get('speed')['fly'] != null)TextSpan(text:', Fly '+snapshot.data!.get('speed')['fly']),
                                      if(statblock.get('speed')['swim'] != null)TextSpan(text:', Swim '+snapshot.data!.get('speed')['swim']),
                                    *//*]
                                )
                            ),*/
                          ],
                        )
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .colorScheme
                    .surfaceContainerLow,
                borderRadius: BorderRadius.circular(
                    12), // Rounded corners
              ),
              child: Row(
                children: [
                  /*scoreBlock(context, 'strength', statblock),
                  scoreBlock(context, 'dexterity', statblock),
                  scoreBlock(context, 'constitution', statblock),
                  scoreBlock(context, 'intelligence', statblock),
                  scoreBlock(context, 'wisdom', statblock),
                  scoreBlock(context, 'charisma', statblock),*/
                ],
              ),
            ),
            Expanded(child: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                margin: EdgeInsets.fromLTRB(8, 10, 8, 32),
                // todo fix all margins
                decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .surfaceContainerLow,
                  borderRadius: BorderRadius.circular(
                      12), // Rounded corners
                ),
                child: Column(
                  children: [
                    ValueListenableBuilder<int>(
                      valueListenable: indexNotifier,
                      builder: (context, index, child) {
                        return Row(
                          children: [
                            infoButton(
                                context, Icons.list_alt, 'Details', 0),
                            infoButton(
                                context, Icons.star, 'Actions', 1),
                            infoButton(
                                context, Icons.menu_book_outlined,
                                'Description', 2),
                          ],
                        );
                      },),
                    Divider(),
                    Expanded( // Add this to allow scrolling inside
                      child: SingleChildScrollView(
                        child: ValueListenableBuilder<int>(
                          valueListenable: indexNotifier,
                          builder: (context, index, child) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: MonsterTextField(controller: crController)
                            ); // Call function instead of using a class
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
          title: MonsterTextField(controller: nameController),
          /*bottom: PreferredSize(preferredSize: Size.zero,
              child: Row(
                children: [
                  MonsterTextField(controller: sizeController),
                  MonsterTextField(controller: typeController),
                  MonsterTextField(controller: alignmentController)
                ],
              )),*/
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.close,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: InkWell(
                onTap: (){},//todo submit
                child:
                  Icon(
                    Icons.save //todo find different icon or button ??
                  )
              ),
            )
          ],
        )
    );
  }
}

modifier(int value){
  String modifier;
  value <= 10 ? modifier = ((value-10)/2).truncate().toString():modifier = '+'+((value-10)/2).truncate().toString();
  return modifier;
}

scoreBlock(context,String stat,data) {
  String statText = stat.substring(0,3).toUpperCase();
  return Flexible(
    child: Column(
        mainAxisSize: MainAxisSize.min,
        children:[
          Flexible(child: Center(child: Text(statText,style: TextStyle(fontWeight: FontWeight.bold)))),
          Flexible(child:
          Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Icon(Stat.stat,size: 60),
                Column(children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0,0,0,8),
                    child: Text(data.get('ability_scores')[stat].toString(),style: TextStyle(fontWeight: FontWeight.w900)),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0,0,0,2),
                    child: Text(modifier(data.get('ability_scores')[stat]),style: TextStyle(color: Theme.of(context).colorScheme.onSecondary,fontWeight: FontWeight.w900),), //todo update text colour or fix frame
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

checkIfSectionEmpty(Column func){
  if(func.children.isEmpty){return noData;}
  return func;
}

Widget getMonsterSection(int index, data) {
  if (index == 0) {
    return checkIfSectionEmpty(details(data));
  } else if (index == 1) {
    return checkIfSectionEmpty(actions(data));
  } else {
    if(data['monster_description'] == ''){return noData;}
    else{return Align(alignment: Alignment.topLeft, child: Text(data['monster_description']));}
  }
}


Widget loading(context){
  return Scaffold(
      body: Shimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: ShimmerLoading(
                      child: photoBorder( const Image(
                        image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'), //todo placeholder image and photoborder needs constraints
                      ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ShimmerLoading(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12), // Rounded corners
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            ShimmerLoading(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                margin: EdgeInsets.symmetric( horizontal: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                child: Row(
                  children: [
                    Column(children:[
                      Text('STR',style: TextStyle(fontWeight: FontWeight.bold)),
                      Icon(Stat.stat,size: 60),
                    ]),
                  ],
                ),
              ),
            ),
            Expanded(child: ShimmerLoading(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                margin: EdgeInsets.fromLTRB(8,10,8,32), // todo fix all margins
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
              ),
            ),
            )
          ],
        ),
      ),
      appBar: AppBar(
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
