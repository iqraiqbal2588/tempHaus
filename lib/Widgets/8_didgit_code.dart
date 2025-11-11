import 'dart:math';

String generate8DigitCode() {
  final random = Random();
  int code = 10000000 + random.nextInt(90000000); // ensures 8 digits
  return code.toString();
}
