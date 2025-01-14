import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:zameny_flutter/services/Data.dart';
import 'package:zameny_flutter/shared/tools.dart';
import 'package:zameny_flutter/models/zamenaFileLink_model.dart';
import 'package:zameny_flutter/config/theme/flex_color_scheme.dart';

class DayScheduleHeader extends StatelessWidget {
  final bool? fullSwap;
  const DayScheduleHeader(
      {required this.day, required this.startDate, required this.isToday, super.key,
      this.fullSwap,});

  final int day;
  final DateTime startDate;
  final bool isToday;

  @override
  Widget build(final BuildContext context) {
    final int searchDay = startDate.add(Duration(days: day - 1)).day;
    final int searchMonth = startDate.add(Duration(days: day - 1)).month;
    final int searchYear = startDate.add(Duration(days: day - 1)).year;
    final Set<ZamenaFileLink> links = GetIt.I
        .get<Data>()
        .zamenaFileLinks
        .where(
          (final element) =>
              element.date.year == searchYear &&
              element.date.month == searchMonth &&
              element.date.day == searchDay,
        )
        .toSet();
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getDayName(day),
                  style: context.styles.ubuntuInverseSurface24,
                ),
                Text(
                  '${getMonthName(startDate.add(Duration(days: day - 1)).month)} ${startDate.add(Duration(days: day - 1)).day}',
                  style: context.styles.ubuntu18.copyWith(color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.7))
                ),
              ],
            ),
          ),
          fullSwap == true
            ? Text(
                'Полная замена',
                style: context.styles.ubuntu18.copyWith(color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.7))
              )
            : const SizedBox.shrink(),
          links.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (final context) {
                          return Container(
                            //margin: EdgeInsets.only(bottom: 60),
                            padding: const EdgeInsets.all(20),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.surface,
                                  border: Border.all(
                                      color:
                                          Theme.of(context).colorScheme.primary,),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20),),),
                              child: ListView.separated(
                                // shrinkWrap: true,
                                separatorBuilder: (final context, final index) =>
                                    const Divider(),
                                itemCount: links.length,
                                itemBuilder: (final context, final index) {
                                  return GestureDetector(
                                    onTap: () => launchUrl(
                                        Uri.parse(links.toList()[index].link),),
                                    child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Ссылка:',
                                              style: TextStyle(
                                                  fontFamily: 'Ubuntu',
                                                  fontSize: 14,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .inverseSurface,),
                                            ),
                                            Text(links.toList()[index].link,
                                                style: TextStyle(
                                                    fontFamily: 'Ubuntu',
                                                    fontSize: 10,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .inverseSurface
                                                        .withValues(alpha: 0.6),),),
                                            Text(
                                              'Время добавления в систему:',
                                              style: TextStyle(
                                                  fontFamily: 'Ubuntu',
                                                  fontSize: 14,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .inverseSurface,),
                                            ),
                                            Text(
                                              '${links.toList()[index].created}',
                                              style: TextStyle(
                                                  fontFamily: 'Ubuntu',
                                                  fontSize: 10,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .inverseSurface
                                                      .withValues(alpha: 0.6),),
                                            ),
                                          ],
                                        ),),
                                  );
                                },
                              ),
                            ),
                          );
                        },);
                  },
                  icon: SizedBox(
                    width: 30,
                    height: 30,
                    child: Stack(
                      children: [
                        Align(
                          alignment: links.length > 1
                              ? Alignment.bottomLeft
                              : Alignment.center,
                          child: SvgPicture.asset(
                            'assets/icon/link-2.svg',
                            colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.inverseSurface, BlendMode.srcIn),
                          ),
                        ),
                        links.length > 1
                            ? Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface,
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inverseSurface
                                              .withValues(alpha: 0.3),),),
                                  child: Center(
                                    child: FittedBox(
                                      child: Text(
                                          links.length.toString(),
                                          style: context.styles.ubuntu
                                      ),
                                    ),
                                  ),
                                )
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                )
              : const SizedBox(
                  width: 5,
                ),
          isToday
              ? Container(
                  decoration:  BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),),
                  child:  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Сегодня',
                      style: TextStyle(
                          color: Theme.of(context).canvasColor,
                          fontSize: 16,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.bold,),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
