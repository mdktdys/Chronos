import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:provider/provider.dart';
import 'package:zameny_flutter/domain/Providers/schedule_provider.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/CourseTile.dart';
import 'package:zameny_flutter/secrets.dart';

class SearchResultHeader extends StatefulWidget {
  const SearchResultHeader({
    super.key,
  });

  @override
  State<SearchResultHeader> createState() => _SearchResultHeaderState();
}

class _SearchResultHeaderState extends State<SearchResultHeader> {
  bool opened = false;

  @override
  Widget build(BuildContext context) {
    ScheduleProvider provider = context.watch<ScheduleProvider>();
    bool enabled = provider.searchType == SearchType.group ? true : false;
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            Text(provider.getSearchTypeNamed(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inverseSurface,
                    fontFamily: 'Ubuntu',
                    fontSize: 18)),
            Text(provider.searchDiscribtion(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inverseSurface,
                    fontFamily: 'Ubuntu',
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            enabled && IS_DEV
                ? Container(
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.1)),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await provider.exportSchedulePNG(context);
                          },
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.1)),
                          ),
                        )
                      ],
                    ),
                  )
                : const SizedBox()
          ],
        ),
        provider.searchType != SearchType.cabinet
            ? Align(
                alignment: Alignment.topRight,
                child: Modal(
                  visible: opened,
                  modal: Dialog(
                    alignment: Alignment.topRight,
                    child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                                width: 1,
                                color: Colors.white.withOpacity(0.15))),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          GestureDetector(
                            onTap: () async {
                              await provider.exportSchedulePNG(context);
                              setState(() => opened = false);
                            },
                            child: const SizedBox(
                              height: 30,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.image),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Экспортировать расписание',
                                    style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ])),
                  ),
                  onClose: () => setState(() => opened = false),
                  child: IconButton(
                    icon: const Icon(Icons.more_vert,color: Colors.white,),
                    onPressed: () {
                      setState(() => opened = true);
                    },
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

class Modal extends StatelessWidget {
  const Modal({
    Key? key,
    required this.visible,
    required this.onClose,
    required this.modal,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final Widget modal;
  final bool visible;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Barrier(
      visible: visible,
      onClose: onClose,
      child: PortalTarget(
        visible: visible,
        closeDuration: kThemeAnimationDuration,
        anchor: const Aligned(
            follower: Alignment.topRight, target: Alignment.topRight),
        portalFollower: TweenAnimationBuilder<double>(
            duration: kThemeAnimationDuration,
            curve: Curves.easeOut,
            tween: Tween(begin: 0, end: visible ? 1 : 0),
            builder: (context, progress, child) {
              return Transform(
                transform: Matrix4.translationValues(0, (1 - progress) * 50, 0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: progress, sigmaY: progress),
                  child: child,
                ),
              );
            },
            child: modal),
        child: child,
      ),
    );
  }
}

class Barrier extends StatelessWidget {
  const Barrier({
    Key? key,
    required this.onClose,
    required this.visible,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onClose;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: visible,
      closeDuration: kThemeAnimationDuration,
      portalFollower: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onClose,
          child: const SizedBox()),
      child: child,
    );
  }
}
