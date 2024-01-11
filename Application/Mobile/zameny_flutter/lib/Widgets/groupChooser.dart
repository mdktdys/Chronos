import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zameny_flutter/Services/Data.dart';
import 'package:zameny_flutter/Widgets/GroupTile.dart';

class GroupChooser extends StatelessWidget {
  final Function(int) onGroupSelected;
  const GroupChooser({super.key, required this.onGroupSelected});

  Future<dynamic> ShowGroupChooserBottomSheet(
      {required BuildContext context, required List<Group> groups}) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Container(
                decoration: const BoxDecoration(
                    backgroundBlendMode: BlendMode.screen,
                    color: Color.fromARGB(255, 18, 21, 37),
                    border: Border(top: BorderSide(color: Colors.amber))),
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: groups
                          .map((e) => GroupTile(
                                group: e,
                                context: context,
                                onGroupSelected: onGroupSelected,
                              ))
                          .toList(),
                    ),
                  ),
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Data dat = GetIt.I.get<Data>();
    Group? group = null;
    if (dat.groups.isNotEmpty) {
      group = dat.groups.where((element) => element.id == dat.seekGroup).first;
    }

    return GestureDetector(
      onTap: () async {
        final data = GetIt.I.get<Data>();
        List<Group> groups = data.groups;
        groups.sort((a,b) => a.name.compareTo(b.name) );
        await ShowGroupChooserBottomSheet(context: context, groups: groups);
      },
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Color.fromARGB(255, 59, 64, 82),
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(255, 43, 43, 58),
                  blurStyle: BlurStyle.outer,
                  blurRadius: 12)
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                const Icon(
                  Icons.person_search_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text(
                    "Selected study group",
                    style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 16,
                        color: Colors.white),
                  ),
                  Text(
                    group != null ? group.name : "No found",
                    style: const TextStyle(
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18),
                  )
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
