import 'package:flutter/services.dart';

const _CHANNEL_NAME = 'com.wangdaye.geometricweather/language';
const _METHOD_GET_LANGUAGE = 'getLanguage';

Future<String> getLanguageCode() async {
  String code = await MethodChannel(_CHANNEL_NAME).invokeMethod(_METHOD_GET_LANGUAGE);

  // the local name may contains a location code.
  // for example: 'zh_Hans_US'.
  final codes = code.replaceAll('_', '-').split('-');
  if (codes.length > 2) {
    return '${codes[0]}-${codes[1]}';
  }

  return code.replaceAll('_', '-');
}