import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zameny_flutter/domain/Providers/bloc/export_bloc.dart';
import 'package:zameny_flutter/domain/Providers/schedule_provider.dart';
import 'package:zameny_flutter/domain/Services/firebase.dart';
import 'package:zameny_flutter/presentation/Widgets/schedule_screen/CourseTile.dart';
import 'package:zameny_flutter/theme/flex_color_scheme.dart';


class SearchResultHeader extends ConsumerStatefulWidget {
  const SearchResultHeader({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchResultHeaderState();
}

class _SearchResultHeaderState extends ConsumerState<SearchResultHeader> {
bool opened = false;
  ExportBloc exportBloc = ExportBloc();

  @override
  Widget build(final BuildContext context) {
    final provider = ref.watch(scheduleProvider);
    //bool enabled = provider.searchType == SearchType.group ? true : false;
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            onPressed: () {
              FirebaseApi().initNotifications(context);
              // ref.read(bottomSheetsProvider).openSheet(const NotificationsBottomSheet());
            },
            icon: const Icon(Icons.notification_add)
          ),
        ),
        Column(
          children: [
            Text(
              provider.getSearchTypeNamed(),
              textAlign: TextAlign.center,
              style: context.styles.ubuntuInverseSurface18
            ),
            Text(
              provider.searchDiscribtion(),
              textAlign: TextAlign.center,
              style: context.styles.ubuntuInverseSurfaceBold24
            )
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
                                color: Colors.white.withOpacity(0.15),),),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          BlocBuilder<ExportBloc, ExportState>(
                              bloc: exportBloc,
                              builder: (final context, final state) {
                                return AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 150),
                                  child: Builder(
                                      key: ValueKey<String>(state.toString()),
                                      builder: (final context) {
                                        if (state is ExportFailed) {
                                          return SizedBox(
                                            height: 30,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.warning),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  state.reason,
                                                  style: context.styles.ubuntu.copyWith(color: Colors.red),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                        if (state is ExportLoading) {
                                          return SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),),
                                          );
                                        }
                                        if (state is ExportReady) {
                                          return GestureDetector(
                                            onTap: () async {
                                              exportBloc.add(ExportStart(context: context, ref: ref,),);
                                            },
                                            child: SizedBox(
                                              height: 30,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(Icons.image),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    'Экспортировать расписание',
                                                    style: context.styles.ubuntuInverseSurface,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },),
                                );
                              },),
                        ],),),
                  ),
                  onClose: () => setState(() => opened = false),
                  child: IconButton(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() => opened = true);
                    },
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

class Modal extends StatefulWidget {
  const Modal({
    required this.visible, required this.onClose, required this.modal, required this.child, super.key,
  });

  final Widget child;
  final Widget modal;
  final bool visible;
  final VoidCallback onClose;

  @override
  State<Modal> createState() => _ModalState();
}

class _ModalState extends State<Modal> with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(vsync: this, value: 0);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Barrier(
      visible: widget.visible,
      onClose: widget.onClose,
      child: PortalTarget(
        visible: widget.visible,
        closeDuration: const Duration(milliseconds: 150),
        anchor: const Aligned(
            follower: Alignment.topRight, target: Alignment.topRight,),
        portalFollower: Animate(
          controller: controller,
          value: 0.05,
          effects: const [
            FadeEffect(duration: Duration(milliseconds: 250)),
            ScaleEffect(
                duration: Duration(milliseconds: 250),
                alignment: Alignment.topRight,
                curve: Curves.fastLinearToSlowEaseIn,),
          ],
          child: widget.modal,
        ),
        child: widget.child,
      ),
    );
  }
}

class Barrier extends StatelessWidget {
  const Barrier({
    required this.onClose, required this.visible, required this.child, super.key,
  });

  final Widget child;
  final VoidCallback onClose;
  final bool visible;

  @override
  Widget build(final BuildContext context) {
    return PortalTarget(
      visible: visible,
      closeDuration: kThemeAnimationDuration,
      portalFollower: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onClose,
          child: const SizedBox(),),
      child: child,
    );
  }
}
