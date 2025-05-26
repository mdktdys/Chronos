import 'dart:math';
import 'dart:ui';

extension StringExtension on String {
  Color getColorForText() {
    final hash = hashCode;
    final random = Random(hash);

    int red = random.nextInt(256);
    int green = random.nextInt(256);
    int blue = random.nextInt(256);

    final int maxValue = max(red, max(green, blue));
    if (maxValue == red) {
      red = 230;
    } else if (maxValue == green) {
      green = 230;
    } else {
      blue = 230;
    }

    return Color.fromARGB(130, red, green, blue);
  }
}
