import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:zameny_flutter/config/bottom_bar_items.dart';
import 'package:zameny_flutter/config/delays.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';
import 'package:zameny_flutter/new/providers/main_provider.dart';
import 'package:zameny_flutter/new/providers/schedule_provider.dart';

class DesktopSideBar extends ConsumerStatefulWidget {
  const DesktopSideBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DesktopSideBarState();
}

class _DesktopSideBarState extends ConsumerState<DesktopSideBar> {
  bool hover = false;

  @override
  Widget build(final BuildContext context) {
    final provider = ref.watch(mainProvider);
    return Material(
      child: InkWell(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        mouseCursor: MouseCursor.defer,
        onTap: () {
          hover = !hover;

          setState(() {});
        },
        onHover: (final bool value) {
          hover = value;

          setState(() {});
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: hover? 260 : 64,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(border: Border(right: BorderSide(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1)))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  onTap: () {
                    ref.invalidate(searchItemProvider);
                  },
                  child: SizedBox(
                    child: Row(
                      children: [
                        SizedBox(
                          height: 48,
                          width: 48,
                          child: Image.asset('assets/icon/whale.png')
                        ),
                        if (hover)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                "Замены уксивтика",
                                maxLines: 1,
                                style: context.styles.ubuntu20
                              ),
                            ).animate(
                              effects: [
                                const MoveEffect(begin: Offset(-10, 0), duration: Duration(milliseconds: 200), curve: Curves.easeOut),
                                const FadeEffect(begin: 0.0, duration: Duration(milliseconds: 200))
                              ]
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: model.map((final BottomBarModel tile) {
                  bool isCurrent = provider.currentPage == tile.index; 
                  Color? color = isCurrent
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface;
                  return Container(
                    height: 60,
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Material(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 
                        isCurrent
                          ? 0.10
                          : 0.01,
                      ),
                      child: InkWell(
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        onTap: () => provider.setPage(tile.index),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                          child: Row(
                            children: [
                              AnimatedSwitcher(
                                duration: Delays.morphDuration,
                                child: SvgPicture.asset(
                                  key: ValueKey<bool>(isCurrent),
                                  isCurrent
                                    ? tile.activeicon
                                    : tile.icon,
                                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                                ),
                              ),
                              if (hover)
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      tile.title,
                                      maxLines: 1,
                                      style: context.styles.ubuntu20.copyWith(color: color)
                                    ),
                                  )
                                  .animate(
                                    effects: [
                                      const MoveEffect(begin: Offset(-10, 0), duration: Duration(milliseconds: 200), curve: Curves.easeOut),
                                      const FadeEffect(begin: 0.0, duration: Duration(milliseconds: 200))
                                    ]
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList()
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: hover? 1: 0.2,
                child: Material(
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    onTap: () {
                      try {
                        launchUrl(Uri.parse('tg://resolve?domain=bot_uksivt'));
                      } catch (_) {
                        launchUrl(Uri.parse('https://t.me/bot_uksivt'));
                      }
                    },
                    child: SizedBox(
                      child: Row(
                        children: [
                          Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color(0xFF27a7e7),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: SvgPicture.asset(
                              "assets/icon/telegram.svg",
                              width: 32,
                              height: 24,
                              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                            ),
                          ),
                          if (hover)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "Новые замены ❤️",
                                  maxLines: 1,
                                  style: context.styles.ubuntu20
                                ),
                              ).animate(
                                effects: [
                                  const MoveEffect(begin: Offset(-10, 0), duration: Duration(milliseconds: 200), curve: Curves.easeOut),
                                  const FadeEffect(begin: 0.0, duration: Duration(milliseconds: 200))
                                ]
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}
