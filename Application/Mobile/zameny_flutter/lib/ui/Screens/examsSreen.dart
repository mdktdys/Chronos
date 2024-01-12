import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zameny_flutter/Services/Data.dart';
import 'package:zameny_flutter/ui/Widgets/groupChooser.dart';
import 'package:zameny_flutter/theme/theme.dart';

class ExamsScreen extends StatefulWidget {
  const ExamsScreen({super.key});

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme().backgroundColor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.edit,
                      size: 24,
                      color: Colors.white,
                    )),
                Text(
                  "Exams",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Ubuntu'),
                ),
                IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.more_horiz_rounded,
                      size: 36,
                      color: Colors.white,
                    ))
              ],
            )),
            SliverToBoxAdapter(
              child: GroupChooser(
                onGroupSelected: (value) {
                  setState(() {
                    GetIt.I.get<Data>().seekGroup = value;
                  });
                },
              ),
            )
          ],
        ),
      )),
    );
  }
}
