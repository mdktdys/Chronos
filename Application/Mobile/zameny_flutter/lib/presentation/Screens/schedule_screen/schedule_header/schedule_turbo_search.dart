import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScheduleTurboSearch extends StatefulWidget {
  const ScheduleTurboSearch({super.key});

  @override
  State<ScheduleTurboSearch> createState() => _ScheduleTurboSearchState();
}

class _ScheduleTurboSearchState extends State<ScheduleTurboSearch> {
  late final SearchController searchController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.searchController = SearchController();
  }

  _updateSearch(String filter) {}

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
