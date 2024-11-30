import 'package:flutter/material.dart';

class SearchBannerMessageWidget extends StatelessWidget {
  const SearchBannerMessageWidget({
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Icon(
              Icons.info_outline_rounded,
              size: 30,
              color: Colors.blue,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Нет замен',
              style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.inverseSurface,),
            ),
          ],
        ),
      ),
    );
  }
}
