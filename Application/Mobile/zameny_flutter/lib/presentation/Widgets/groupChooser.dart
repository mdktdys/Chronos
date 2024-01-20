import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:zameny_flutter/Services/Api.dart';
import 'package:zameny_flutter/Services/Data.dart';
import 'package:zameny_flutter/Services/Models/group.dart';
import 'package:zameny_flutter/presentation/Providers/bloc/load_bloc_bloc.dart';
import 'package:zameny_flutter/presentation/Providers/bloc/schedule_bloc.dart';
import 'package:zameny_flutter/presentation/Widgets/GroupTile.dart';

class GroupChooser extends StatefulWidget {
  final Function(int) onGroupSelected;
  const GroupChooser({super.key, required this.onGroupSelected});

  @override
  State<GroupChooser> createState() => _GroupChooserState();
}

class _GroupChooserState extends State<GroupChooser> {
  @override
  Widget build(BuildContext context) {
    Data dat = GetIt.I.get<Data>();
    Group? group;

    _setGroup() {
      if (dat.groups.isNotEmpty) {
        List<Group> list =
            dat.groups.where((element) => element.id == dat.seekGroup).toList();
        if (list.isNotEmpty) {
          group =
              dat.groups.where((element) => element.id == dat.seekGroup).first;
        }
      }
    }

    return GestureDetector(
      onTap: () async {
        final data = GetIt.I.get<Data>();
        List<Group> groups = data.groups;
        groups.sort((a, b) => a.name.compareTo(b.name));
        await ShowGroupChooserBottomSheet(
            context: context, onGroupSelected: this.widget.onGroupSelected);
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
                  BlocBuilder<ScheduleBloc, ScheduleState>(
                    builder: (context, state) {
                      if (state is ScheduleInitial) {
                        return Text("Wait for loading",
                            style: const TextStyle(
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18));
                      }
                      if (state is ScheduleFailedLoading) {
                        return Text("Failed loading",
                            style: const TextStyle(
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18));
                      }
                      if (state is ScheduleLoaded) {
                        _setGroup();
                        return Text(
                          group != null
                              ? group!.name
                              : GetIt.I.get<Data>().seekGroup.toString(),
                          style: const TextStyle(
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18),
                        );
                      }
                      if (state is ScheduleLoading) {
                        return Text("Loading...",
                            style: const TextStyle(
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18));
                      }
                      return Text("");
                    },
                  )
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }

  ShowGroupChooserBottomSheet(
      {required BuildContext context, required Function(int) onGroupSelected}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) {
          return DraggableScrollableSheet(
            shouldCloseOnMinExtent: true,
            snap: false,
            expand: false,
            maxChildSize: 0.8,
              builder: (BuildContext context, ScrollController controller) {
            return ModalGroupsBottomSheet(onGroupSelected: onGroupSelected,controller : controller);
          });
        });
  }
}

class ModalGroupsBottomSheet extends StatefulWidget {
  final Function(int) onGroupSelected;
  final ScrollController controller;
  const ModalGroupsBottomSheet({super.key, required this.onGroupSelected, required this.controller});

  @override
  State<ModalGroupsBottomSheet> createState() => _ModalGroupsBottomSheetState();
}

class _ModalGroupsBottomSheetState extends State<ModalGroupsBottomSheet> {
  late List<Group> groups;
  late final LoadBloc loadBloc;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    loadBloc = LoadBloc();
    _searchController = TextEditingController();
    _loadGroups();
  }

  _loadGroups() async {
    loadBloc.emit(LoadBlocLoading());
    await Api().loadDepartments();
    await Api().loadGroups();
    groups = GetIt.I.get<Data>().groups;
    loadBloc.emit(LoadBlocLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 18, 21, 37),
            ),
        padding: const EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          controller: this.widget.controller,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CupertinoSearchTextField(
                  autocorrect: false,
                  enableIMEPersonalizedLearning: false,
                  style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      
                    });
                  },
                ),
                SizedBox(height: 5,),
                BlocBuilder<LoadBloc, LoadBlocState>(
                  bloc: loadBloc,
                  builder: (context, state) {
                    if (state is LoadBlocLoaded) {
                      return GroupList(
                          groups: groups,
                          widget: widget,
                          filter: _searchController.text);
                    }
                    if (state is LoadBlocLoading) {
                      return CircularProgressIndicator();
                    }
                    return Text("err");
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

class GroupList extends StatelessWidget {
  final String filter;
  final List<Group> groups;
  final ModalGroupsBottomSheet widget;

  const GroupList(
      {super.key,
      required this.groups,
      required this.widget,
      required this.filter});


  @override
  Widget build(BuildContext context) {
    List<Group> filtered = groups.where((element) => element.name.toLowerCase().contains(filter.toLowerCase())).toList();
    return Column(
      children: filtered
          .map((e) => GroupTile(
                group: e,
                context: context,
                onGroupSelected: widget.onGroupSelected,
              ))
          .toList(),
    );
  }
}
