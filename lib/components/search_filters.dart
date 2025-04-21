import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monster_compendium/services/active_filters.dart';

import '../locator.dart';

Future filterList(BuildContext context){

  var sizeList = availableSizes.map<DropdownMenuEntry<String?>>((String value) {
    return DropdownMenuEntry<String>(
      value: value,
      label: value,
    );
  }).toList();

var typeList = availableTypes.map<DropdownMenuEntry<String?>>((String value) {
    return DropdownMenuEntry<String>(
      value: value,
      label: value,
    );
  }).toList();

  var alignmentList = availableAlignments.map<DropdownMenuEntry<String?>>((String value) {
    return DropdownMenuEntry<String>(
      value: value,
      label: value,
    );
  }).toList();

  sizeList.insert(0, DropdownMenuEntry(value: null, label: ' - '),);
  typeList.insert(0, DropdownMenuEntry(value: null, label: ' - '),);
  alignmentList.insert(0, DropdownMenuEntry(value: null, label: ' - '),);

  final crController = TextEditingController();
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return SizedBox (
          height: 500,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                spacing: 8,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Text("Filters",style: TextStyle(fontSize: 20.00,fontWeight: FontWeight.bold)),
                    Divider(),
                    Text("Cr",style: TextStyle(fontSize: 20.00,fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownMenu(initialSelection: locator<ActiveFilters>().crmin,label: const Text('Min'),dropdownMenuEntries: crList(),menuHeight: 250,onSelected: (cr){locator<ActiveFilters>().crmin = cr;},width: 175,),
                        Container(width: 8,),
                        DropdownMenu(initialSelection: locator<ActiveFilters>().crmax, label: const Text('Max'),dropdownMenuEntries: crList(),menuHeight: 250,onSelected: (cr){locator<ActiveFilters>().crmax = cr;},width: 175,), //todo show selected on reopen.
                      ],
                    ),

                    Text("Size & Type",style: TextStyle(fontSize: 20.00,fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownMenu(initialSelection: locator<ActiveFilters>().size,
                          label: const Text('Size'),
                          dropdownMenuEntries: sizeList,
                          menuHeight: 250,
                          onSelected: (size){locator<ActiveFilters>().size = size;},
                          width: 175,
                        ),
                        Container(width: 8,),
                        DropdownMenu(initialSelection: locator<ActiveFilters>().type,
                          label: const Text('Type'),
                          dropdownMenuEntries: typeList,
                          menuHeight: 250,
                          onSelected: (type){locator<ActiveFilters>().type = type;},
                          width: 175,
                        )
                      ],
                    ), //todo show selected on reopen.
                    Text("Alignment",style: TextStyle(fontSize: 20.00,fontWeight: FontWeight.bold)),
                    DropdownMenu(initialSelection: locator<ActiveFilters>().alignment,
                      label: const Text('Alignment'),
                      dropdownMenuEntries: alignmentList,
                      menuHeight: 250,
                      onSelected: (alignment){locator<ActiveFilters>().alignment = alignment;},
                      width: 358,
                    ), //todo show selected on reopen.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 16,
                      children: [
                        ElevatedButton(onPressed: () {Navigator.pop(context); resetFilters(crController);}, child: const Text('Reset Filters'),),
                        ElevatedButton(onPressed: () {Navigator.pop(context); saveFilters(crController);}, child: const Text('Save Filters'),),
                      ],
                    )
                  ]
              ),
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
  locator<ActiveFilters>().size = null;
  locator<ActiveFilters>().type = null;
  locator<ActiveFilters>().alignment = null;
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

final List<String> availableSizes = ['Tiny', 'Small', 'Medium', 'Large', 'Huge', 'Gargantuan'];
final List<String> availableTypes = ['Aberration', 'Beast', 'Celestial', 'Construct', 'Dragon', 'Elemental', 'Fey', 'Fiend', 'Giant', 'Humanoid', 'Monstrosity', 'Ooze', 'Plant', 'Undead'];
final List<String> availableAlignments = ['Lawful Good', 'Neutral Good', 'Chaotic Good', 'Lawful Neutral', 'Neutral', 'Chaotic Neutral', 'Lawful Evil', 'Neutral Evil', 'Chaotic Evil', 'Unaligned'];


/* todo WIP filter list to not allow contradicting minimum and maximum values. \/\/\/

DropdownMenu(initialSelection: locator<ActiveFilters>().crmin,label: const Text('Min'),dropdownMenuEntries: crList()
    .where((entry) => (entry.value ?? double.infinity) <= (loadFilters() ?? double.infinity)).toList()
,menuHeight: 250,onSelected: (cr){locator<ActiveFilters>().crmin = cr;setState(){};},),*/
