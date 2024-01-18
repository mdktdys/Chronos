import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:zameny_flutter/Services/Api.dart';
import 'package:zameny_flutter/Services/Data.dart';
import 'package:zameny_flutter/presentation/Providers/bloc/load_bloc_bloc.dart';
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
    if (dat.groups.isNotEmpty) {
      List<Group> list =
          dat.groups.where((element) => element.id == dat.seekGroup).toList();
      if (list.isNotEmpty) {
        group =
            dat.groups.where((element) => element.id == dat.seekGroup).first;
      }
    }

    return GestureDetector(
      onTap: () async {
        final data = GetIt.I.get<Data>();
        List<Group> groups = data.groups;
        groups.sort((a, b) => a.name.compareTo(b.name));
        await ShowGroupChooserBottomSheet(context: context, onGroupSelected: this.widget.onGroupSelected);
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
                    group != null ? group.name : GetIt.I.get<Data>().seekGroup.toString(),
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

  Future<dynamic> ShowGroupChooserBottomSheet(
      {required BuildContext context, required Function(int) onGroupSelected}) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return ModalGroupsBottomSheet(
            onGroupSelected: onGroupSelected,
          );
        });
  }
}

class ModalGroupsBottomSheet extends StatefulWidget {
  final Function(int) onGroupSelected;
  const ModalGroupsBottomSheet({super.key, required this.onGroupSelected});

  @override
  State<ModalGroupsBottomSheet> createState() => _ModalGroupsBottomSheetState();
}

class _ModalGroupsBottomSheetState extends State<ModalGroupsBottomSheet> {
  late List<Group> groups;
  late final LoadBloc loadBloc;

  @override
  void initState() {
    super.initState();
    loadBloc = LoadBloc();
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
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 18, 21, 37),
          ),
          width: double.infinity,
          height: double.infinity,
          child: BlocBuilder<LoadBloc, LoadBlocState>(
            bloc: loadBloc,
            builder: (context, state) {
              if (state is LoadBlocLoaded) {
                return GroupList(groups: groups, widget: widget);
              }
              if (state is LoadBlocLoading){
                return CircularProgressIndicator();
              }
              return Text("err");
            },
          )),
    );
    ;
  }
}

class GroupList extends StatelessWidget {
  const GroupList({
    super.key,
    required this.groups,
    required this.widget,
  });

  final List<Group> groups;
  final ModalGroupsBottomSheet widget;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: groups
              .map((e) => GroupTile(
                    group: e,
                    context: context,
                    onGroupSelected: widget.onGroupSelected,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
