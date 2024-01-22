import 'dart:async';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zameny_flutter/Services/Data.dart';
import 'package:zameny_flutter/Services/Models/group.dart';

class ScheduleTurboSearch extends StatefulWidget {
  final Function(int) groupSelected;
  final Function(int) teacherSelected;
  final Function(int) cabinetSelected;
  const ScheduleTurboSearch({super.key, required this.groupSelected, required this.cabinetSelected, required this.teacherSelected});

  @override
  State<ScheduleTurboSearch> createState() => _ScheduleTurboSearchState();
}

class _ScheduleTurboSearchState extends State<ScheduleTurboSearch> {
  late final SearchController searchController;
  List<SearchItem> searchItems = [];
  List<SearchItem> filteredItems = [];
  Timer? _debounceTimer;
  @override
  void initState() {
    super.initState();
    searchController = SearchController();
  }

  static void filterSearchItems(List<dynamic> args) {

    var sendPort = args[0] as SendPort;
    (args[1] as List<SearchItem>).where((element) => element.getFiltername().toLowerCase().contains(args[2].toLowerCase())).toList();
    Isolate.exit(sendPort, args);
}

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoSearchTextField(
          controller: searchController,
          onTap: () {
            searchItems.clear();
            searchItems.addAll(GetIt.I.get<Data>().groups);
            searchItems.addAll(GetIt.I.get<Data>().cabinets);
            searchItems.addAll(GetIt.I.get<Data>().teachers);
          },
          onChanged: (value) {
  if (value.isEmpty) {
    filteredItems.clear();
    setState(() {});
  } else {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(Duration(milliseconds: 300), () {
      filteredItems = searchItems
          .where((element) =>
              element.getFiltername().toLowerCase().contains(value.toLowerCase()))
          .toList();

      setState(() {});
    });
  }
},
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          placeholder: 'Turbo search',
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredItems.length,
          itemBuilder: ((context, index) {
          SearchItem item = filteredItems[index];
          return ListTile(
            onTap: (){
              if(item is Group){
                widget.groupSelected.call(item.id);
              }
              if(item is Cabinet){
                widget.cabinetSelected.call(item.id);
              }
              if(item is Teacher){
                widget.teacherSelected.call(item.id);
              }
              setState(() {
                searchController.text ='';
                filteredItems.clear();
              });
            },
            title: Text(item.getFiltername(),style: TextStyle(fontFamily: 'Ubuntu'),),
          );
        }))
      ],
    );
  }
}

abstract class SearchItem {
  String getFiltername() {
    if(this is Group){

      return (this as Group).name;
    }
    if(this is Cabinet){
      return (this as Cabinet).name;
    }
    if(this is Teacher){
      return (this as Teacher).name;
    }
    return "";
  }
}
