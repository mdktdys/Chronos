import 'package:flutter/material.dart';
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
            // SliverToBoxAdapter(
            //   child: GroupChooser(
            //     onGroupSelected: (value) {
            //       setState(() {
            //         GetIt.I.get<Data>().seekGroup = value;
            //       });
            //     },
            //   ),
            // ),
            SliverToBoxAdapter(
              child: Center(
                child: Container(
                  height: 650,
                  width: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.construction_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 100,
                        shadows: [
                          Shadow(
                              color: Theme.of(context).colorScheme.primary,
                              blurRadius: 12)
                        ],
                      ),
                      Text(
                        "In develop",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.bold,
                            fontSize: 26),
                      ),
                      Text(
                        "see in next updates",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
