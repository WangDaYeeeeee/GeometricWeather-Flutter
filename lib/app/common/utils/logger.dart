import 'dart:developer' as developer;

void testLog(String str) {
  developer.log('${DateTime.now()} - $str',
    name: 'testing',
    time: DateTime.now(),
  );
}