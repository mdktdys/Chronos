import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ExamsScreen extends StatefulWidget {
  const ExamsScreen({super.key});

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: 52,
                    height: 52,
                    child: Center(
                        child: SvgPicture.asset(
                      "assets/icon/vuesax_linear_award.svg",
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.inverseSurface,
                          BlendMode.srcIn),
                      width: 32,
                      height: 32,
                    ))),
                Text(
                  "Экзамены",
                  style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Ubuntu'),
                ),
                IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.more_horiz_rounded,
                      size: 36,
                      color: Colors.transparent
                    ))
              ],
            ),
            // SliverToBoxAdapter(
            //   child: GroupChooser(
            //     onGroupSelected: (value) {
            //       setState(() {
            //         GetIt.I.get<Data>().seekGroup = value;
            //       });
            //     },
            //   ),
            // ),
            Expanded(
              child: Center(
                child: SizedBox(
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
                        "В разработке",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.bold,
                            fontSize: 26),
                      ),
                      Text(
                        "следите за обновами",
                        textAlign: TextAlign.center,
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
            ),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
