import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:zameny_flutter/config/images.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/models/search_item_model.dart';
import 'package:zameny_flutter/new/providers/favorite_search_items_provider.dart';
import 'package:zameny_flutter/new/providers/notifications_provider.dart';
import 'package:zameny_flutter/new/providers/schedule_provider.dart';

class SearchItemNotificationButton extends ConsumerWidget {
  final SearchItem? item;

  const SearchItemNotificationButton({
    required this.item,
    super.key
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    if (item == null) {
      return const SizedBox.shrink();
    }

    final AsyncValue<SubscribtionState> subscription = ref.watch(subsribtionProvider(item!));
    final provider = ref.read(subsribtionProvider(item!).notifier);

    return subscription.when(
      loading: () {
        return const RefreshProgressIndicator();
      },
      error: (final e,final o) {
        return const SizedBox.shrink();
      },
      data: (final data) {
        bool isNotificationSubscribed = false;

        if (data is SubscribtionSubscribed) {
          isNotificationSubscribed = true;
        } else if (data is SubscribtionNonSubscribed) {
          isNotificationSubscribed = false;
        }

        return Material(
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () async {
              if (isNotificationSubscribed) {
                await provider.onsubscribe();
              } else {
                await provider.subscribe();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle, 
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
              ),
              padding: const EdgeInsets.all(8),
              child: SvgPicture.asset(
                isNotificationSubscribed ? Images.notificationBold : Images.notification,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              )
            )
          ),
        );
      },
    );
  }
}


class SearchResultHeader extends ConsumerStatefulWidget {
  const SearchResultHeader({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchResultHeaderState();
}

class _SearchResultHeaderState extends ConsumerState<SearchResultHeader> {
  bool opened = false;
  // ExportBloc exportBloc = ExportBloc();

  @override
  Widget build(final BuildContext context) {
    //final provider = ref.watch(scheduleProvider);
    //bool enabled = provider.searchType == SearchType.group ? true : false;

    final provider = ref.watch(searchItemProvider);
  
    final bool isSubscribed = ref.watch(favoriteSearchItemsProvider).items.contains(provider);

    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            Text(
              provider?.typeName ?? '',
              textAlign: TextAlign.center,
              style: context.styles.ubuntuInverseSurface18
            ),
            Text(
              provider?.name ?? '',
              textAlign: TextAlign.center,
              style: context.styles.ubuntuInverseSurfaceBold24
            )
          ],
        ),
        Align(
          alignment: Alignment.topRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 8,
            children: [
              SearchItemNotificationButton(item: provider!),
              Material(
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    if (isSubscribed) {
                      ref.read(favoriteSearchItemsProvider).remove(searchItem: provider);
                    } else {
                      ref.read(favoriteSearchItemsProvider).add(searchItem: provider);
                    }
                    setState(() {});
                                    },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: SvgPicture.asset(
                      isSubscribed ? Images.heart : Images.heartOutlined,
                      colorFilter: const ColorFilter.mode(Colors.redAccent, BlendMode.srcIn),
                    )
                  )
                ),
              ),
            ],
          ),
        )
        // provider.searchType != SearchType.cabinet
        //     ? Align(
        //         alignment: Alignment.topRight,
        //         child: Modal(
        //           visible: opened,
        //           modal: Dialog(
        //             alignment: Alignment.topRight,
        //             child: Container(
        //                 padding: const EdgeInsets.all(12),
        //                 decoration: BoxDecoration(
        //                     borderRadius: BorderRadius.circular(26),
        //                     border: Border.all(
        //                         color: Colors.white.withValues(alpha: 0.15),),),
        //                 child:
        //                     Column(mainAxisSize: MainAxisSize.min, children: [
        //                   BlocBuilder<ExportBloc, ExportState>(
        //                       bloc: exportBloc,
        //                       builder: (final context, final state) {
        //                         return AnimatedSwitcher(
        //                           duration: const Duration(milliseconds: 150),
        //                           child: Builder(
        //                               key: ValueKey<String>(state.toString()),
        //                               builder: (final context) {
        //                                 if (state is ExportFailed) {
        //                                   return SizedBox(
        //                                     height: 30,
        //                                     child: Row(
        //                                       mainAxisSize: MainAxisSize.min,
        //                                       children: [
        //                                         const Icon(Icons.warning),
        //                                         const SizedBox(
        //                                           width: 5,
        //                                         ),
        //                                         Text(
        //                                           state.reason,
        //                                           style: context.styles.ubuntu.copyWith(color: Colors.red),
        //                                         ),
        //                                       ],
        //                                     ),
        //                                   );
        //                                 }
        //                                 if (state is ExportLoading) {
        //                                   return SizedBox(
        //                                     height: 30,
        //                                     width: 30,
        //                                     child: Center(
        //                                         child:
        //                                             CircularProgressIndicator(
        //                                       color: Theme.of(context)
        //                                           .colorScheme
        //                                           .primary,
        //                                     ),),
        //                                   );
        //                                 }
        //                                 if (state is ExportReady) {
        //                                   return GestureDetector(
        //                                     onTap: () async {
        //                                       exportBloc.add(ExportStart(context: context, ref: ref,),);
        //                                     },
        //                                     child: SizedBox(
        //                                       height: 30,
        //                                       child: Row(
        //                                         mainAxisSize: MainAxisSize.min,
        //                                         children: [
        //                                           const Icon(Icons.image),
        //                                           const SizedBox(
        //                                             width: 5,
        //                                           ),
        //                                           Text(
        //                                             'Экспортировать расписание',
        //                                             style: context.styles.ubuntuInverseSurface,
        //                                           ),
        //                                         ],
        //                                       ),
        //                                     ),
        //                                   );
        //                                 }
        //                                 return const SizedBox.shrink();
        //                               },),
        //                         );
        //                       },),
        //                 ],),),
        //           ),
        //           onClose: () => setState(() => opened = false),
        //           child: IconButton(
        //             icon: const Icon(
        //               Icons.more_vert,
        //               color: Colors.white,
        //             ),
        //             onPressed: () {
        //               setState(() => opened = true);
        //             },
        //           ),
        //         ),
        //       )
        //     : const SizedBox.shrink(),
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
