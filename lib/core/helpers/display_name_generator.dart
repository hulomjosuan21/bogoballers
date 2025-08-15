import 'dart:math';

final _random = Random();
final _adjectives = ["Cool", "Happy", "Swift", "Silent", "Mighty"];
final _nouns = ["Tiger", "Eagle", "Wizard", "Ninja", "Shark"];

String generateDisplayName() {
  String adjective = _adjectives[_random.nextInt(_adjectives.length)];
  String noun = _nouns[_random.nextInt(_nouns.length)];

  int timestamp = DateTime.now().millisecondsSinceEpoch;
  int shortNumber = timestamp % 10000;

  return "$adjective$noun$shortNumber";
}
