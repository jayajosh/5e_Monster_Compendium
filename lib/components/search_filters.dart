import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monster_compendium/services/active_filters.dart';

import '../locator.dart';

Future filterList(BuildContext context){
  final crController = TextEditingController();
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
                      DropdownMenu(initialSelection: locator<ActiveFilters>().crmin,label: const Text('Min'),dropdownMenuEntries: crList(),menuHeight: 250,onSelected: (cr){locator<ActiveFilters>().crmin = cr;},),
                      DropdownMenu(initialSelection: locator<ActiveFilters>().crmax, label: const Text('Max'),dropdownMenuEntries: crList(),menuHeight: 250,onSelected: (cr){locator<ActiveFilters>().crmax = cr;},), //todo show selected on reopen.
                    ],
                  ), //todo show selected on reopen.
                  //ElevatedButton(onPressed: () {activeFilters.cr = 1;}, child: const Text('Enable cr'),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 15,
                    children: [
                      ElevatedButton(onPressed: () {Navigator.pop(context); resetFilters(crController);}, child: const Text('Reset Filters'),),
                      ElevatedButton(onPressed: () {Navigator.pop(context); saveFilters(crController);}, child: const Text('Save Filters'),),
                      ],
                  )
                ]
            ),
          )
      );
      },
  );
}

loadFilters(){
  return locator<ActiveFilters>().crmax;
}

saveFilters(TextEditingController cr){
  //cr.text.isEmpty ? activeFilters.cr = null : activeFilters.cr = double.parse(cr.text);
  //activeFilters.cr = double.parse(cr.text);
  locator<ActiveFilters>().on = true;
  locator<ActiveFilters>().updateFilters();
}

resetFilters(TextEditingController cr){
  //cr.text.isEmpty ? activeFilters.cr = null : activeFilters.cr = double.parse(cr.text);
  //activeFilters.cr = double.parse(cr.text);
  locator<ActiveFilters>().on = false;
  locator<ActiveFilters>().crmin = null;
  locator<ActiveFilters>().crmax = null;
  locator<ActiveFilters>().updateFilters();
}


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


/*
TextField(
controller: crController,
decoration: new InputDecoration(labelText: "Enter your number"),
keyboardType: TextInputType.number,
inputFormatters: <TextInputFormatter>[
FilteringTextInputFormatter.digitsOnly
],
),*/

/* todo WIP filter list to not allow contradicting minimum and maximum values. \/\/\/

DropdownMenu(initialSelection: locator<ActiveFilters>().crmin,label: const Text('Min'),dropdownMenuEntries: crList()
    .where((entry) => (entry.value ?? double.infinity) <= (loadFilters() ?? double.infinity)).toList()
,menuHeight: 250,onSelected: (cr){locator<ActiveFilters>().crmin = cr;setState(){};},),*/
