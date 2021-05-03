import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

GetIt locator = GetIt();

void setupLocator() {
  locator.registerSingleton(SystemServices());
}

class SystemServices {

  void call(String number) => launch("tel:$number");

  void sendSms(String number) => launch("sms:$number");

  void sendEmail(String email) => launch("mailto:$email");

  void launchUrl(String url) => launch(url);
}