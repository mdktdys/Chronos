
// class ExportCourseTile extends StatelessWidget {
//   final SearchType type;
//   final Course course;
//   final Lesson e;
//   final bool obedTime;
//   final bool saturdayTime;
//   const ExportCourseTile(
//       {required this.type, required this.course, required this.e, required this.obedTime, required this.saturdayTime, super.key,});

//   @override
//   Widget build(final BuildContext context) {
//     return Container(
//         margin: const EdgeInsets.symmetric(vertical: 5),
//         width: 500,
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: const BorderRadius.all(Radius.circular(20)),
//             color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       width: 30,
//                       decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: getCourseColor(course.color),),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           e.number.toString(),
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                               fontSize: 14,),
//                         ),
//                       ),
//                     ),
//                     Text(
//                         saturdayTime
//                             ? getTimeFromDateTime(
//                                 getLessonTimings(e.number).saturdayStart,)
//                             : obedTime
//                                 ? getTimeFromDateTime(
//                                     getLessonTimings(e.number).obedStart,)
//                                 : getTimeFromDateTime(
//                                     getLessonTimings(e.number).start,),
//                         style: TextStyle(
//                             fontSize: 16,
//                             color: obedTime
//                                 ? (e.number > 3
//                                     ? Colors.green
//                                     : Theme.of(context)
//                                         .colorScheme
//                                         .inverseSurface)
//                                 : Theme.of(context).colorScheme.inverseSurface,
//                             fontFamily: 'Ubuntu',
//                             fontWeight: FontWeight.bold,),),
//                     Text(
//                         saturdayTime
//                             ? getTimeFromDateTime(
//                                 getLessonTimings(e.number).saturdayEnd,)
//                             : obedTime
//                                 ? getTimeFromDateTime(
//                                     getLessonTimings(e.number).obedEnd,)
//                                 : getTimeFromDateTime(
//                                     getLessonTimings(e.number).end,),
//                         style: TextStyle(
//                             color: obedTime
//                                 ? (e.number > 3
//                                     ? Colors.green.withAlpha(200)
//                                     : Theme.of(context)
//                                         .colorScheme
//                                         .inverseSurface
//                                         .withAlpha(200))
//                                 : Theme.of(context)
//                                     .colorScheme
//                                     .inverseSurface
//                                     .withAlpha(200),
//                             fontFamily: 'Ubuntu',),),
//                   ],
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 Flexible(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                           (getCourseById(e.course) ??
//                                   Course(id: -1, name: 'err', color: '0,0,0,0'))
//                               .name,
//                           overflow: TextOverflow.fade,
//                           style: TextStyle(
//                               color:
//                                   Theme.of(context).colorScheme.inverseSurface,
//                               fontFamily: 'Ubuntu',
//                               fontWeight: FontWeight.bold,
//                               fontSize: 20,),),
//                       Text(
//                         type == SearchType.teacher
//                             ? getGroupById(e.group)!.name
//                             : type == SearchType.group
//                                 ? getTeacherById(e.teacher).name
//                                 : type == SearchType.cabinet
//                                     ? ''
//                                     : '',
//                         style: TextStyle(
//                             color: Theme.of(context).colorScheme.inverseSurface,
//                             fontFamily: 'Ubuntu',),
//                       ),
//                       Row(
//                         children: [
//                           SvgPicture.asset(
//                             'assets/icon/vuesax_linear_location.svg',
//                             colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.inverseSurface, BlendMode.srcIn),
//                             height: 18,
//                           ),
//                           Text(
//                             type == SearchType.teacher
//                                 ? getCabinetById(e.cabinet).name
//                                 : type == SearchType.group
//                                     ? getCabinetById(e.cabinet).name
//                                     : type == SearchType.cabinet
//                                         ? getGroupById(e.group)!.name
//                                         : '',
//                             style: TextStyle(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .inverseSurface,
//                                 fontFamily: 'Ubuntu',),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),);
//   }
// }

// class ExportCourseTileEmpty extends StatelessWidget {
//   const ExportCourseTileEmpty({super.key});

//   @override
//   Widget build(final BuildContext context) {
//     return Container(
//         margin: const EdgeInsets.symmetric(vertical: 5),
//         width: 500,
//         child: Container(
//             decoration: BoxDecoration(
//                 borderRadius: const BorderRadius.all(Radius.circular(20)),
//                 color: Colors.transparent,
//                 border: DashedBorder.all(
//                     dashLength: 10,
//                     color: Theme.of(context)
//                         .colorScheme
//                         .primary
//                         .withValues(alpha: 0.6),),),
//             child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Center(
//                     child: Text(
//                   'Нет пар',
//                   style: TextStyle(
//                       fontFamily: 'Ubuntu',
//                       fontSize: 20,
//                       color: Theme.of(context).colorScheme.inversePrimary,),
//                 ),),),),);
//   }
// }
