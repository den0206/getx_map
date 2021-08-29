import 'dart:math' as math;

class GenerateProbability {
  static GenerateProbability get to => GenerateProbability();
  var random = new math.Random();

  bool probability({int frequency = 2}) {
    final num = random.nextInt(10);
    final res = num % frequency == 0;
    return res;
  }
}
