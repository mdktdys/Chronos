import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zameny_flutter/Services/Data.dart';

class ScheduleTurboSearch extends StatefulWidget {
  const ScheduleTurboSearch({super.key});

  @override
  State<ScheduleTurboSearch> createState() => _ScheduleTurboSearchState();
}

class _ScheduleTurboSearchState extends State<ScheduleTurboSearch> {
  late final SearchController searchController;
  List<SearchItem> searchItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.searchController = SearchController();
  }

  _updateSearch(String filter) {
    searchItems.addAll(GetIt.I.get<Data>().groups.where((element) => element.name.contains(filter)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoSearchTextField(
          controller: searchController,
          onChanged: (value) {
            _updateSearch(value);
          },
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          placeholder: 'Turbo search',
        ),
        ListView.builder(
          shrinkWrap: true,
          itemBuilder: ((context, index) {
          return ListTile(
            title: Text("asd"),
          );
        }))
      ],
    );
  }
}

abstract class SearchItem {}
