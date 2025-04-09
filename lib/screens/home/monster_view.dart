import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monster_compendium/components/photo_border.dart';
import 'package:monster_compendium/screens/home/monster_view(backup).dart';
import 'package:monster_compendium/services/monster_storage.dart';
import '../../components/monster_view_factory/actions_factory.dart';
import '../../components/monster_view_factory/details_factory.dart';
import '../../components/loading_shimmer.dart';
import '../../components/stat_icons.dart';

ValueNotifier<int> indexNotifier = ValueNotifier<int>(0);
Widget noData = Center(child: Text("Data does not exist")); //todo column center and maybe add icon


class MonsterView extends StatefulWidget {
  @override
  _MonsterView createState() => _MonsterView();
}

class _MonsterView extends State<MonsterView> {

  getArgs<DocumentReference>() {
    List? args = ModalRoute
        .of(context)!
        .settings
        .arguments as List?;

    return args;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('Monsters').doc( //todo get doc from args
            getArgs()?[0])
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text("Something went wrong")); //todo Use theme colour
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Scaffold(
                appBar: AppBar(
                  leading: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                    ),
                  ),
                ),
                body: Center(child: Text("Data does not exist"))
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            var statblock = snapshot.data!;
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
                                    Row( //todo center better
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Center(child: Text('Challenge ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                        Center(child: Text(statblock.get('cr').toString())),
                                      ],
                                    ),
                                    Center(child: Text('('+statblock.get('xp').toString()+'; PB +'+snapshot.data!.get('proficiency_bonus').toString()+')')),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: Stack(
                                              alignment: AlignmentDirectional
                                                  .center,
                                              children: [
                                                Icon(Icons.shield_outlined,
                                                    color: Theme
                                                        .of(context)
                                                        .colorScheme
                                                        .secondary, size: 64),
                                                Column(
                                                  children: [
                                                    Text(statblock.get('ac')['value'].toString(), style: TextStyle(
                                                        fontWeight: FontWeight
                                                            .bold)),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Stack(
                                              alignment: AlignmentDirectional
                                                  .center,
                                              children: [
                                                //todo orrrr add brackets underneath
                                                Icon(Icons.favorite_outline, //todo inkwell w/ ontop => swap to hit_dice or hit_points_roll
                                                    color: Theme
                                                        .of(context)
                                                        .colorScheme
                                                        .secondary, size: 64),
                                                Text(statblock.get('hit_points').toString(), style: TextStyle(
                                                    fontWeight: FontWeight.bold))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text.rich(
                                        TextSpan(text: '',
                                            children: [
                                              TextSpan(text:'Speed ',style: TextStyle(fontWeight: FontWeight.bold)),
                                              //TextSpan(text: statblock.get('speed')['walk']),
                                              //todo function this??? \/\/\/
                                              if(statblock.get('speed')['walk'] != null)TextSpan(text: snapshot.data!.get('speed')['walk']),
                                              if(statblock.get('speed')['burrow'] != null)TextSpan(text:', Burrow '+snapshot.data!.get('speed')['burrow']),
                                              if(statblock.get('speed')['climb'] != null)TextSpan(text:', Climb '+snapshot.data!.get('speed')['climb']),
                                              if(statblock.get('speed')['fly'] != null)TextSpan(text:', Fly '+snapshot.data!.get('speed')['fly']),
                                              if(statblock.get('speed')['swim'] != null)TextSpan(text:', Swim '+snapshot.data!.get('speed')['swim']),
                                            ]
                                        )
                                    ),
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
                          scoreBlock(context, 'strength', statblock),
                          scoreBlock(context, 'dexterity', statblock),
                          scoreBlock(context, 'constitution', statblock),
                          scoreBlock(context, 'intelligence', statblock),
                          scoreBlock(context, 'wisdom', statblock),
                          scoreBlock(context, 'charisma', statblock),
                        ],
                      ),
                      // todo add a 'bottom nav bar' for like, bookmark and comment?? or add to app bar
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
                                      child: getMonsterSection(index,statblock),
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
                    title: Text(statblock.get('name')),
                    bottom: PreferredSize(preferredSize: Size.zero,
                        child: Text(statblock.get('size')+' '+statblock.get('type')+', '+statblock.get('alignment'))),
                    centerTitle: true,
                    leading: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                      ),
                    ),
                    actions: [
                      Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child:editButton(statblock,context))
                    ]
                )
            );
          };
          return loading(context);
        }
    );
  }
}

statCheck(int? value){
  if(value == null){return '';}
  else {
    return value.toString();
  }
}

modifier(int? value){
  if(value == null){return '';}
  else {
    String modifier;
    value <= 10
        ? modifier = ((value - 10) / 2).truncate().toString()
        : modifier = '+${((value - 10) / 2).truncate()}';
    return modifier;
  }
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
                    child: Text(statCheck(data.get('ability_scores')[stat]),style: TextStyle(fontWeight: FontWeight.w900)),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0,0,0,2),
                    child: Text(modifier(data.get('ability_scores')[stat]),style: TextStyle(fontWeight: FontWeight.w900),),
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
        //todo get name as arg for title
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

editButton(statblock,context){
  if(statblock.get('creator_id') == FirebaseAuth.instance.currentUser?.uid) {
    MonsterStore ms = MonsterStore.fromMap(statblock.data());
    return InkWell(
      onTap: () {
      Navigator.pushNamed(context, '/Home/MonsterView/EditMonster',arguments: [ms]);
    },
      child: Icon(
        Icons.edit,
      ),);
  }
}