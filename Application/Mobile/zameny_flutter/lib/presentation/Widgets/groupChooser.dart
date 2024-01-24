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
            context: context, onGroupSelected: widget.onGroupSelected);
      },
      child: Container(
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
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 16,
                        color: Colors.white),
                  ),
                  BlocBuilder<ScheduleBloc, ScheduleState>(
                    builder: (context, state) {
                      if (state is ScheduleInitial) {
                        return const Text("Wait for loading",
                            style: TextStyle(
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18));
                      }
                      if (state is ScheduleFailedLoading) {
                        return const Text("Failed loading",
                            style: TextStyle(
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
                        return const Text("Loading...",
                            style: TextStyle(
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18));
                      }
                      return const Text("");
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
        backgroundColor: Theme.of(context).colorScheme.background,
        builder: (_) {
          return DraggableScrollableSheet(
              shouldCloseOnMinExtent: true,
              snap: false,
              expand: false,
              maxChildSize: 0.8,
              builder: (BuildContext context, ScrollController controller) {
                return ModalGroupsBottomSheet(
                    onGroupSelected: onGroupSelected, controller: controller);
              });
        });
  }
}

class ModalGroupsBottomSheet extends StatefulWidget {
  final Function(int) onGroupSelected;
  final ScrollController controller;
  const ModalGroupsBottomSheet(
      {super.key, required this.onGroupSelected, required this.controller});

  @override
  State<ModalGroupsBottomSheet> createState() => _ModalGroupsBottomSheetState();
}

class _ModalGroupsBottomSheetState extends State<ModalGroupsBottomSheet> {
  late List<Group> groups;
  late final LoadBloc loadBloc;
  late final TextEditingController _searchController;
  late final int _searchIndex;

  @override
  void initState() {
    super.initState();
    loadBloc = LoadBloc();
    _searchController = TextEditingController();
    _searchIndex = 0;
    _loadGroups();
  }

  _loadGroups() async {
    loadBloc.emit(LoadBlocLoading());
    await Api().loadDepartments();
    await Api().loadGroups();
    groups = GetIt.I.get<Data>().groups;
    loadBloc.emit(LoadBlocLoaded());
  }

  _switchedSearch(int index) {
    setState(() {
      _searchIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          controller: this.widget.controller,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              CupertinoSearchTextField(
                autocorrect: false,
                enableIMEPersonalizedLearning: false,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
                controller: _searchController,
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 35,
                child: CupertinoSegmentedControl(
                  groupValue: _searchIndex,
                  selectedColor: Theme.of(context).colorScheme.primary,
                  borderColor: Colors.white,
                  unselectedColor: Colors.transparent,
                  onValueChanged: (index) {
                    _switchedSearch(index);
                  },
                  children: {
                    1: Text("Groups"),
                    2: Text("Teachers"),
                    3: Text("Cabinets"),
                  },
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              BlocBuilder<LoadBloc, LoadBlocState>(
                bloc: loadBloc,
                builder: (context, state) {
                  if (state is LoadBlocLoaded) {
                    return GroupList(
                        groups: groups,
                        widget: widget,
                        filter: _searchController.text, searchIndex: _searchIndex);
                  }
                  if (state is LoadBlocLoading) {
                    return const CircularProgressIndicator();
                  }
                  return const Text("err");
                },
              ),
            ]),
          ),
        ));
  }
}

class GroupList extends StatelessWidget {
  final String filter;
  final List<Group> groups;
  final ModalGroupsBottomSheet widget;
  final int searchIndex;

  const GroupList(
      {super.key,
      required this.groups,
      required this.widget,
      required this.filter,
      required this.searchIndex});

  @override
  Widget build(BuildContext context) {
    List<Group> filtered = groups;

    // if(searchIndex == 0){
    //   filtered = filtered.where((element) => element.)
    // }
    // else if (searchIndex == 1){

    // }
    // else if (searchIndex == 2){

    // }

    filtered = groups
        .where((element) =>
            element.name.toLowerCase().contains(filter.toLowerCase()))
        .toList();
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
