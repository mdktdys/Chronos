import 'dart:async';
import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zameny_flutter/Services/Data.dart';
import 'package:zameny_flutter/Services/Models/group.dart';
import 'package:zameny_flutter/presentation/Providers/schedule_provider.dart';
import 'package:zameny_flutter/presentation/Providers/search_provider.dart';

class ScheduleTurboSearch extends StatefulWidget {
  const ScheduleTurboSearch({
    super.key,
  });

  @override
  State<ScheduleTurboSearch> createState() => _ScheduleTurboSearchState();
}

class _ScheduleTurboSearchState extends State<ScheduleTurboSearch> {
  late final SearchController searchController;
  List<SearchItem> filteredItems = [];
  Timer? _debounceTimer;
  @override
  void initState() {
    super.initState();
    searchController = SearchController();
  }

  @override
  Widget build(BuildContext context) {
    SearchProvider providerSearch = context.read<SearchProvider>();
    ScheduleProvider providerSchedule = context.watch<ScheduleProvider>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoSearchTextField(
          controller: searchController,
          onSubmitted: (value) {
            FocusScope.of(context).unfocus();
          },
          onChanged: (value) {
            if (value.isEmpty) {
              setState(() {
                filteredItems.clear();
              });
            } else {
              if (_debounceTimer?.isActive ?? false) {
                _debounceTimer!.cancel();
              }

              _debounceTimer = Timer(const Duration(milliseconds: 150), () {
                setState(() {
                  filteredItems = providerSearch.searchItems
                      .where((element) => element
                          .getFiltername()
                          .toLowerCase()
                          .contains(value.toLowerCase().trim()))
                      .toList();
                });
              });
            }
          },
          style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
          placeholder: 'Я ищу...',
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          alignment: Alignment.topCenter,
          curve: Easing.legacy,
          child: ImplicitlyAnimatedList<SearchItem>(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              items: filteredItems,
              areItemsTheSame: (a, b) => a.s == b.s,
              insertDuration: const Duration(milliseconds: 300),
              removeDuration: const Duration(milliseconds: 300),
              // removeItemBuilder: (context, animation, oldItem) {
              //   return FadeTransition(
              //       opacity: animation,
              //       child: ListTile(
              //         key: UniqueKey(),
              //         title: Text(
              //           oldItem.getFiltername(),
              //           style: TextStyle(
              //               fontFamily: 'Ubuntu',
              //               color: Theme.of(context).colorScheme.onSurface),
              //         ),
              //       ));
              // },
              itemBuilder: (context, animation, item, index) {
                return SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: -1,
                  child: SizedBox(
                    height: 50,
                    child: ListTile(
                      key: UniqueKey(),
                      onTap: () {
                        setState(() {
                          searchController.text = '';
                          FocusScope.of(context).unfocus();
                          filteredItems.clear();
                        });
                        if (item is Group) {
                          providerSchedule.groupSelected(item.id, context);
                        }
                        if (item is Cabinet) {
                          providerSchedule.cabinetSelected(item.id, context);
                        }
                        if (item is Teacher) {
                          providerSchedule.teacherSelected(item.id, context);
                        }
                      },
                      title: Text(
                        item.getFiltername(),
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}

abstract class SearchItem {
  int s = 0;
  String getFiltername() {
    if (this is Group) {
      return (this as Group).name;
    }
    if (this is Cabinet) {
      return (this as Cabinet).name;
    }
    if (this is Teacher) {
      return (this as Teacher).name;
    }
    return "";
  }
}
