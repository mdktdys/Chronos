import 'package:flutter/material.dart';
import 'package:zameny_flutter/Services/Data.dart';
import 'package:zameny_flutter/Services/Tools.dart';

class GroupTile extends StatelessWidget {
  final Group group;
  final context;
  final Function(int) onGroupSelected;

  const GroupTile({super.key, required this.group, required this.context,  required this.onGroupSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          onGroupSelected(group.id);
        },
        child: Container(
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 43, 43, 58),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(
                  Icons.code_rounded,
                  color: Colors.white,
                  size: 36,
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.name,
                      style: const TextStyle(
                          fontFamily: 'Ubuntu',
                          fontSize: 20,
                          color: Colors.white),
                    ),
                    Text(
                      getDepartmentById(group.department).name,
                      style: const TextStyle(
                          fontFamily: 'Ubuntu',
                          fontSize: 16,
                          color: Colors.white),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
