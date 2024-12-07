import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zameny_flutter/theme/flex_color_scheme.dart';

class TopBanner extends StatelessWidget {
  const TopBanner({
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 30,
      child: Center(
        child: GestureDetector(
          onTap: () {
            try {
              launchUrl(Uri.parse('tg://resolve?domain=bot_uksivt'));
            } catch (_) {
              launchUrl(Uri.parse('https://t.me/bot_uksivt'));
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Новое расписание и замены тут ',
                style: context.styles.ubuntuWhite500,
              ),
              Text(
                '❄️',
                style: GoogleFonts.notoEmoji(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                ' *тык*',
                style: context.styles.ubuntuWhite500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
