import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:zameny_flutter/config/images.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/models/search_item_model.dart';
import 'package:zameny_flutter/new/providers/export_schedule_provider.dart';
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
    final ThemeData theme = Theme.of(context);

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
                isNotificationSubscribed
                  ? Images.notificationBold
                  : Images.notification,
                colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.srcIn),
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

  @override
  Widget build(final BuildContext context) {
    final SearchItem? searchItem = ref.watch(searchItemProvider);
    final bool isSubscribed = ref.watch(favoriteSearchItemsProvider).items.contains(searchItem);
    final ThemeData theme = Theme.of(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            Text(
              searchItem?.typeName ?? '',
              textAlign: TextAlign.center,
              style: context.styles.ubuntuInverseSurface18
            ),
            Text(
              searchItem?.name ?? '',
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
              Material(
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    ref.read(scheduleExportProvider).exportSchedule(context: context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: SvgPicture.asset(
                      Images.export,
                      colorFilter: ColorFilter.mode(
                        theme.colorScheme.primary,
                        BlendMode.srcIn
                      ),
                    )
                  )
                ),
              ),
              SearchItemNotificationButton(item: searchItem!),
              Material(
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    if (isSubscribed) {
                      ref.read(favoriteSearchItemsProvider).remove(searchItem: searchItem);
                    } else {
                      ref.read(favoriteSearchItemsProvider).add(searchItem: searchItem);
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
