import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monster_compendium/services/active_filters.dart';

import '../locator.dart';

Future filterList(BuildContext context) {

  //final crList =
  final crController = TextEditingController();
  print(Theme.of(context));
  print(Theme.of(context).colorScheme.primary);
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return SizedBox (
          height: 400,
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Text("Cr",style: TextStyle(fontSize: 20.00,fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownMenu(dropdownMenuEntries: crList(),menuHeight: 250,onSelected: (cr){locator<ActiveFilters>().cr = cr;},),
                      DropdownMenu(dropdownMenuEntries: crList(),menuHeight: 250,onSelected: (cr){locator<ActiveFilters>().cr = cr;},), //todo show selected on reopen.
                    ],
                  ), //todo show selected on reopen.
                  //ElevatedButton(onPressed: () {activeFilters.cr = 1;}, child: const Text('Enable cr'),),
                  ElevatedButton(onPressed: () {Navigator.pop(context); saveFilters(crController);}, child: const Text('Close BottomSheet'),)
                ]
            ),
          )
      );
      },
  );
}

saveFilters(TextEditingController cr){
  //cr.text.isEmpty ? activeFilters.cr = null : activeFilters.cr = double.parse(cr.text);
  //activeFilters.cr = double.parse(cr.text);
  locator<ActiveFilters>().on = true;
  locator<ActiveFilters>().updateFilters();
}


List<DropdownMenuEntry<double?>> crList(){
  return <DropdownMenuEntry<double?>>[
    DropdownMenuEntry(value:  null , label: ' - '),
    DropdownMenuEntry(value:  0 , label: ' 0 '),
    DropdownMenuEntry(value:  0.125 , label: ' 1/8 '),
    DropdownMenuEntry(value:  0.25 , label: ' 1/4 '),
    DropdownMenuEntry(value:  0.5 , label: ' 1/2 '),
    DropdownMenuEntry(value:  1 , label: ' 1 '),
    DropdownMenuEntry(value:  2 , label: ' 2 '),
    DropdownMenuEntry(value:  3 , label: ' 3 '),
    DropdownMenuEntry(value:  4 , label: ' 4 '),
    DropdownMenuEntry(value:  5 , label: ' 5 '),
    DropdownMenuEntry(value:  6 , label: ' 6 '),
    DropdownMenuEntry(value:  7 , label: ' 7 '),
    DropdownMenuEntry(value:  8 , label: ' 8 '),
    DropdownMenuEntry(value:  9 , label: ' 9 '),
    DropdownMenuEntry(value:  10 , label: ' 10 '),
    DropdownMenuEntry(value:  11 , label: ' 11 '),
    DropdownMenuEntry(value:  12 , label: ' 12 '),
    DropdownMenuEntry(value:  13 , label: ' 13 '),
    DropdownMenuEntry(value:  14 , label: ' 14 '),
    DropdownMenuEntry(value:  15 , label: ' 15 '),
    DropdownMenuEntry(value:  16 , label: ' 16 '),
    DropdownMenuEntry(value:  17 , label: ' 17 '),
    DropdownMenuEntry(value:  18 , label: ' 18 '),
    DropdownMenuEntry(value:  19 , label: ' 19 '),
    DropdownMenuEntry(value:  20 , label: ' 20 '),
    DropdownMenuEntry(value:  21 , label: ' 21 '),
    DropdownMenuEntry(value:  22 , label: ' 22 '),
    DropdownMenuEntry(value:  23 , label: ' 23 '),
    DropdownMenuEntry(value:  24 , label: ' 24 '),
    DropdownMenuEntry(value:  25 , label: ' 25 '),
    DropdownMenuEntry(value:  26 , label: ' 26 '),
    DropdownMenuEntry(value:  27 , label: ' 27 '),
    DropdownMenuEntry(value:  28 , label: ' 28 '),
    DropdownMenuEntry(value:  29 , label: ' 29 '),
    DropdownMenuEntry(value:  30 , label: ' 30 ')];
}

/*
TextField(
controller: crController,
decoration: new InputDecoration(labelText: "Enter your number"),
keyboardType: TextInputType.number,
inputFormatters: <TextInputFormatter>[
FilteringTextInputFormatter.digitsOnly
],
),*/
