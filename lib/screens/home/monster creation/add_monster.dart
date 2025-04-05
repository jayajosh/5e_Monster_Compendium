import 'package:flutter/material.dart';
import 'package:monster_compendium/components/monster_edit_factory/edit_details_factory.dart';
import 'package:monster_compendium/components/photo_border.dart';
import '../../../components/monster_edit_factory/monster_fields_factory.dart';
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

  TextEditingController bottomController = new TextEditingController();

  //TextEditingController nameController = new TextEditingController();
  //TextEditingController sizeController = new TextEditingController();
  //TextEditingController typeController = new TextEditingController();
  //TextEditingController alignmentController = new TextEditingController();
  TextEditingController crController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  //TextEditingController acController = new TextEditingController();
  //TextEditingController hpController = new TextEditingController();
  //TextEditingController pbController = new TextEditingController();

  //List<String?> acStrings = [];

  void _updateBottomText(String newText) {
    setState(() {
      bottomController.text = newText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height, //todo move the scroll view or adjust to not allow scroll but auto scroll
              child: Column(
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
                                            child: MonsterIconButton(icon: Icons.shield_outlined,text1: 'AC',text2: 'Type',)
                                            ),
                                          ),
                                        Expanded(
                                          child: Center(
                                            child: MonsterIconButton(icon: Icons.favorite_outline,text1: 'HP',text2: 'HitDice',),
                                        ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(child:MoveSpeedButton()),
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
                        ScoreEdit(stat: 'strength'),
                        ScoreEdit(stat: 'dexterity'),
                        ScoreEdit(stat: 'constitution'),
                        ScoreEdit(stat: 'intelligence'),
                        ScoreEdit(stat: 'wisdom'),
                        ScoreEdit(stat: 'charisma'),
                      ],
                    ),
                  ),
                  Flexible(fit: FlexFit.loose, child: Container(
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
                            child: SingleChildScrollView( //todo needs a height can be flexible through a column
                              child: ValueListenableBuilder<int>(
                                valueListenable: indexNotifier,
                                builder: (context, index, child) {
                                  return getMonsterSection(index,descriptionController); // Call function instead of using a class
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
            ),
          ),
        ),
        appBar: AppBar(
          elevation: 0.0,
          title: GeneralDetailsButton(bottomController:bottomController,onTextChanged: _updateBottomText,),

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

Widget getMonsterSection(int index, descriptionController) {
  if (index == 0) {
    return addDetails(); //todo dont dispose on change, maybe create on init and call from there
  } else if (index == 1) {
    return addDetails();
  } else {
    //if(data['monster_description'] == ''){return noData;}
    return TextField(
      maxLines: null,
      controller: descriptionController,
      decoration: const InputDecoration(
        hintText: 'Trait Description',
        labelText: 'Trait Description',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
      ),
    );
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
