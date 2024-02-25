import 'dart:io';
import 'dart:typed_data';

import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talker_flutter/talker_flutter.dart';

class ScheduleHeader extends StatelessWidget {
  const ScheduleHeader({
    super.key,
  });

  Future<String> writeImageToStorage(Uint8List feedbackScreenshot) async {
    final Directory output = await getTemporaryDirectory();
    final String screenshotFilePath = '${output.path}/feedback.png';
    final File screenshotFile = File(screenshotFilePath);
    await screenshotFile.writeAsBytes(feedbackScreenshot);
    return screenshotFilePath;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(
            Icons.bug_report,
            size: 28,
          ),
          onPressed: () {
            BetterFeedback.of(context).show((feedback) async {
              final screenshotFilePath =
                  await writeImageToStorage(feedback.screenshot);
              final Email email = Email(
                body: feedback.text,
                subject: 'App Feedback',
                recipients: ['islamoffdanil67@gmail.com'],
                attachmentPaths: [screenshotFilePath],
                isHTML: false,
              );
              await FlutterEmailSender.send(email);
            });
          },
          color: Theme.of(context).primaryColorLight,
        ),
        Text(
          "Расписание",
          style: TextStyle(
              color: Theme.of(context).primaryColorLight,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Ubuntu'),
        ),
        IconButton(
            onPressed: () {
              showModalBottomSheet(
                  barrierColor: Colors.black.withOpacity(0.3),
                  backgroundColor: Theme.of(context).colorScheme.background,
                  context: context,
                  builder: (context) => Container(
                        height: 100,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  "Показать логи Talker",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                      fontFamily: 'Ubuntu'),
                                ),
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => TalkerScreen(
                                            talker: GetIt.I.get<Talker>()))),
                              )
                            ],
                          ),
                        ),
                      ));
            },
            icon: Icon(
              Icons.more_horiz_rounded,
              size: 36,
              color: Theme.of(context).primaryColorLight,
            ))
      ],
    );
  }
}
