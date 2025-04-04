import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monster_compendium/components/stat_icons.dart';

class EditBorderButton extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget? child;
  final Function()? onTap;

  const EditBorderButton({super.key, this.child, this.onTap, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
          children: [
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.onSurface),
                borderRadius: BorderRadius.circular(5),
              ),
              child: child,
            ),
            Positioned(
              right: -10,
              top: -3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.edit,
                      shadows: <Shadow>[ // todo fix small border pixel
                        Shadow(
                          offset: Offset(7,0),
                          color: Theme.of(context).colorScheme.surfaceContainerLow,
                        ),
                        Shadow(
                          offset: Offset(7, -7),
                          color: Theme.of(context).colorScheme.surfaceContainerLow,
                        ),
                        Shadow(
                          offset: Offset(0, -7),
                          color: Theme.of(context).colorScheme.surfaceContainerLow,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]
      ),
    );
  }
}

class MonsterTextField extends StatelessWidget {
  final TextEditingController controller;

  const MonsterTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context)
  {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width*0.2,
      height: size.height/75,
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(29),
      ),
      child: TextField(controller: controller),
    );
  }
}

class CrDropDown extends StatelessWidget { //todo make width dynamic
  final TextEditingController controller;
  const CrDropDown({super.key, required this.controller});

  List<DropdownMenuEntry<double?>> crList() {
    return [
      DropdownMenuEntry(value: null, label: ' - '),
      DropdownMenuEntry(value: 0, label: ' 0 '),
      DropdownMenuEntry(value: 0.125, label: ' 1/8 '),
      DropdownMenuEntry(value: 0.25, label: ' 1/4 '),
      DropdownMenuEntry(value: 0.5, label: ' 1/2 '),
      DropdownMenuEntry(value: 1, label: ' 1 '),
      for (int i = 2; i <= 30; i++) DropdownMenuEntry(value: i.toDouble(), label: ' $i '),
    ];
  }

  @override
  Widget build(BuildContext context)
  {
    Size size = MediaQuery.of(context).size;
    return DropdownMenu(
        label: const Text('CR'),
        dropdownMenuEntries: crList(),
        menuHeight: 250,
        width: 150,
        onSelected: (cr){print(cr);},// todo fill out storage to be uploaded
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          constraints: BoxConstraints(
            maxHeight: size.height/20,
          ),
        )
    );
    //todo add initialSelection: programmatically??
  }
}

class MonsterIconButton extends StatefulWidget {
  final IconData icon;
  final String text1;
  final String text2;
  const MonsterIconButton({super.key,required this.icon, required this.text1, required this.text2,});

  @override
  _MonsterIconButton createState() => _MonsterIconButton();
}

class _MonsterIconButton extends State<MonsterIconButton>{

  TextEditingController text1Controller = TextEditingController();
  TextEditingController text2Controller = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final result = await showDialog<Map<String, String>>(
            context: context,
            builder: (BuildContext context) {
              return IconDialog(text1: widget.text1,text2: widget.text2,text1Controller: text1Controller,text2Controller: text2Controller);
            },
          );

          if (result != null) {
            setState(() {
              text1Controller.text = result['text1'] == null ? ' ' : result['text1']!;
              text2Controller.text = result['text2'] == null ? ' ' : result['text2']!;
            });
          }
        },
        borderRadius: BorderRadius.circular(5),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.onSurface),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(widget.icon, color: Theme.of(context).colorScheme.secondary, size: 64),
              Column(
                children: [
                  Text(text1Controller.text,style: TextStyle(fontWeight: FontWeight.w900),),
                  Text('(${text2Controller.text})',style: TextStyle(fontWeight: FontWeight.w900),textAlign: TextAlign.center,)
                ],
              ),
            ],
          ),
        ),
      ),
    );
    //todo add initialSelection: programmatically??
  }
}

class IconDialog extends StatefulWidget{
  final String text1;
  final String text2;
  final TextEditingController text1Controller;
  final TextEditingController text2Controller;

  const IconDialog({super.key, required this.text1, required this.text2, required this.text1Controller, required this.text2Controller});

  @override
  _IconDialogState createState() => _IconDialogState();
}

class _IconDialogState extends State<IconDialog>{ //todo change aesthetics => make text field closer to text - bold text
  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      content: Material(
        color: Colors.transparent,
        child: Column(children: [
          Row(children: [
            Expanded(child: Text('${widget.text1}:')),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height / 20,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 3.0),
                  child: TextField(
                    controller: widget.text1Controller, //todo maybe swap to row index
                    keyboardType: TextInputType.number, // Set keyboard type
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly, // Allow only digits
                    ],
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ],),
          Row(children: [
            Expanded(child: Text('${widget.text2}:')),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height / 20,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 3.0),
                  child: TextField(
                    // todo controller: textControllers[rowIndex], // Use controller
                    controller: widget.text2Controller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ],),
        ],),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop({
              'text1': widget.text1Controller.text,
              'text2': widget.text2Controller.text,
            });
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}

class MoveSpeedButton extends StatefulWidget{
  const MoveSpeedButton({super.key});


  @override
  _MoveSpeedButtonState createState() => _MoveSpeedButtonState();

}

class _MoveSpeedButtonState extends State<MoveSpeedButton> {
  Map<String, String> speeds = {};

  @override
  Widget build(BuildContext context) {
    return EditBorderButton(
      width: 150,
      height: 50,
      onTap: () {
        showDialog<Map<String, String>>(
          context: context,
          builder: (BuildContext context) {
            return MoveSpeedDialog(
              speeds: speeds,
              onSpeedsChanged: (Map<String, String> updatedSpeeds) {
                speeds = updatedSpeeds;
              },
            );
          },
        ).then((updatedSpeeds) {
          if (updatedSpeeds != null) {
            setState(() {
              speeds = updatedSpeeds;
            });
          }
        });
      },
      child: Text.rich(
        TextSpan(
          text: '',
          children: [
            TextSpan(text: 'Speed ', style: TextStyle(fontWeight: FontWeight.bold)),
            if (speeds['walk'] != null) TextSpan(text: speeds['walk']),
            if (speeds['burrow'] != null) TextSpan(text: ', Burrow ${speeds['burrow']!}'),
            if (speeds['climb'] != null) TextSpan(text: ', Climb ${speeds['climb']!}'),
            if (speeds['fly'] != null) TextSpan(text: ', Fly ${speeds['fly']!}'),
            if (speeds['swim'] != null) TextSpan(text: ', Swim ${speeds['swim']!}'),
          ],
        ),
      ),
    );
  }
}

class MoveSpeedDialog extends StatefulWidget { //todo move to save even without ok being clicked
  final Function(Map<String, String>) onSpeedsChanged;
  final Map<String, String>? speeds;

  const MoveSpeedDialog({super.key, required this.onSpeedsChanged, this.speeds});

  @override
  _MoveSpeedDialogState createState() => _MoveSpeedDialogState();
}

class _MoveSpeedDialogState extends State<MoveSpeedDialog> {
  Map<String, String> speeds = {};
  Map<String, bool> speedKeys = {
    'walk': false,
    'burrow': false,
    'climb': false,
    'fly': false,
    'swim': false,
  };
  Map<int, String?> selectedValues = {};
  List<String> availableKeys = ['walk', 'burrow', 'climb', 'fly', 'swim'];
  Map<int, TextEditingController> textControllers = {};

  @override
  void initState() {
    super.initState();
    if(widget.speeds != null) {
      speeds = Map.from(widget.speeds!); // Initialize speeds from widget.speeds
      int index = 0;
      speeds.forEach((key, value) {
        if (availableKeys.contains(key)) {
          selectedValues[index] = key;
          availableKeys.remove(key);
          textControllers[index] =
              TextEditingController(text: value.replaceAll(" ft.", ""));
          index++;
        }
      });
    }
  }


  Material speedRow(int rowIndex, BuildContext context) {
    List<DropdownMenuEntry<String>> speedList = availableKeys
        .map((key) => DropdownMenuEntry<String>(value: key, label: key))
        .toList();

    final String? currentSelection = selectedValues[rowIndex];

    if (currentSelection != null && !speedList.any((entry) => entry.value == currentSelection)) {
      speedList.insert(
        0,
        DropdownMenuEntry<String>(value: currentSelection, label: currentSelection),
      );
    }

    // Initialize controller for current row if it doesn't exist
    textControllers[rowIndex] ??= TextEditingController();

    return Material(
      child: Container(
        decoration: BoxDecoration(
          color: CupertinoColors.systemFill, //todo work out colours for this as it will not theme match on android
          borderRadius: BorderRadius.circular(5.0),
        ),
        padding: EdgeInsets.all(4),
        child: Row(
          spacing: 8,
          children: [
            DropdownMenu<String>(
              dropdownMenuEntries: speedList,
              initialSelection: selectedValues[rowIndex],
              onSelected: (String? selected) {
                setState(() {
                  String? old = selectedValues[rowIndex];
                  if (old != null) {
                    availableKeys.add(old);
                  }
                  if (selected != null) {
                    availableKeys.remove(selected);
                  }
                  selectedValues[rowIndex] = selected;
                });
              },
              width: 125,
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 20,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height / 20,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 3.0),
                  child: TextField(
                    controller: textControllers[rowIndex], // Use controller
                    onChanged: (value) {
                      speeds[selectedValues[rowIndex] ?? ''] = '$value ft.'; // Update speeds map
                    },
                    keyboardType: TextInputType.number, // Set keyboard type
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly, // Allow only digits
                    ],
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixText: 'ft.',
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  String? removedKey = selectedValues[rowIndex];
                  if (removedKey != null) {
                    availableKeys.add(removedKey);
                  }
                  selectedValues.remove(rowIndex);
                  speeds.removeWhere((key, value) => key == removedKey);
                });
              },
              child: Icon(CupertinoIcons.delete,color: Colors.red,),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> makeSpeedsColumn(BuildContext context) {
    List<Widget> speedsColumn = [];

    // Create initial rows based on selectedValues map
    selectedValues.forEach((rowIndex, selectedValue) {
      speedsColumn.add(speedRow(rowIndex, context));
    });

    // Add a row to add new dropdowns
    if (selectedValues.length < 5) {
      speedsColumn.add(
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                int newRowIndex = selectedValues.keys.length;
                selectedValues[newRowIndex] =
                null;
              });
            },
            child: Row( //todo make an action
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Add Speed'),
                Icon(Icons.add_circle_outline),
              ],
            ),
          ),
        ),
      );
    }
    return speedsColumn;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text('Speed'),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Column(
              spacing: 4,
              children: makeSpeedsColumn(context),
            ),
          );
        },
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            widget.onSpeedsChanged(speeds);
            Navigator.of(context).pop(speeds);
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}

/*
class ScoreButton extends StatefulWidget{
  final String stat;
  const ScoreButton({super.key, required this.stat});

  @override
  _ScoreButton createState() => _ScoreButton();
}

class _ScoreButton extends State<ScoreButton> {
  TextEditingController statController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String statText = widget.stat.substring(0,3).toUpperCase();
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child:  InkWell(
          onTap: () {
            print('Dialog Moment');
          },
          child: Stack(
            children: [
              Positioned(
                right: -10,
                top: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(Icons.edit,
                        shadows: <Shadow>[ // todo fix small border pixel
                          Shadow(
                            offset: Offset(7,0),
                            color: Theme.of(context).colorScheme.surfaceContainerLow,
                          ),
                          Shadow(
                            offset: Offset(7, -7),
                            color: Theme.of(context).colorScheme.surfaceContainerLow,
                          ),
                          Shadow(
                            offset: Offset(0, -7),
                            color: Theme.of(context).colorScheme.surfaceContainerLow,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                  mainAxisSize: MainAxisSize.min,
                  children:[
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(statText,style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Flexible(child:
                    Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Icon(Stat.stat,size: 60),
                          Column(children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0,0,0,8),
                              child: Text(statController.text,style: TextStyle(fontWeight: FontWeight.w900)),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0,0,0,2),
                              child: Text(statController.text,style: TextStyle(color: Theme.of(context).colorScheme.onSecondary,fontWeight: FontWeight.w900),), //todo update text colour or fix frame
                            )
                          ])
                        ])),
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}

*/

class ScoreButton extends StatefulWidget{
  final String stat;
  const ScoreButton({super.key, required this.stat});

  @override
  _ScoreButton createState() => _ScoreButton();
}

class _ScoreButton extends State<ScoreButton> {
  modifier(String value){ //todo check
    if (value.isNotEmpty) {
      int? intValue = int.tryParse(value);
      if (intValue != null) {
        String modifier;
        intValue <= 10
            ? modifier = ((intValue - 10.1) / 2).round().toString()
            : modifier = '+' + ((intValue - 10) / 2).truncate().toString();
        return modifier;
      }
      else {return 0;}
    }
    else{return 0;}
  }

  TextEditingController statController = TextEditingController();

  @override
  void initState() {
    super.initState();
    statController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    statController.removeListener(_onTextChanged); // Remove the listener.
    statController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    // This function will be called whenever the text changes.
    setState(() {
      //todo add to monster
    });
    // You can perform any actions based on the new text here.
  }

  @override
  Widget build(BuildContext context) {
    String statText = widget.stat.substring(0,3).toUpperCase();
    return Flexible(
      child: InkWell(
        onTap: () {
          print('Dialog Moment '+widget.stat);
        },
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
                        padding: const EdgeInsetsDirectional.fromSTEB(0,0,0,2),
                        child: SizedBox(height: 36,width:32,child: TextField(
                          controller: statController,
                          style: TextStyle(fontWeight: FontWeight.w900),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number, // Set keyboard type
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly, // Allow only digits
                          ],
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0,0,0,2),
                        child: Text(modifier(statController.text).toString(),style: TextStyle(fontWeight: FontWeight.w900),),
                      )
                    ])
                  ])),
            ]),
      ),
    );
  }
}