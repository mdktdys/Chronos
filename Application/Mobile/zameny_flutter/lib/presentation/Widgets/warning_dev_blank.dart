import 'package:flutter/material.dart';

class WarningDevBlank extends StatelessWidget {
  const WarningDevBlank({
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error.withOpacity(0.2),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('⚠️ Фича в деве',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Ubuntu',
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.inverseSurface,),),
          const SizedBox(
            height: 5,
          ),
          const Text(
            'Данные могут быть некорректны, для уверенности свертесь с файлом замен',
            style: TextStyle(
                fontFamily: 'Ubuntu', fontWeight: FontWeight.w400,),
          ),
        ],
      ),
    );
  }
}
