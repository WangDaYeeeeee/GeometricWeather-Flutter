import 'package:flutter_vibrate/flutter_vibrate.dart';

void haptic() {
  Vibrate.feedback(FeedbackType.success);
}