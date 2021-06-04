import 'package:flutter/cupertino.dart';

typedef LocalizedStringGetter = String Function(BuildContext context);

class Pair {

  const Pair(this.key, this.nameGetter);

  final String key;
  final LocalizedStringGetter nameGetter;

  @override
  bool operator ==(Object other) {
    return other is Pair && key == other.key;
  }

  @override
  int get hashCode => super.hashCode;

  static Pair toPair(String key, Map<String, Pair> map) {
    return map[key];
  }

  static List<Pair> toPairList(List<String> keyList, Map<String, Pair> map) {
    try {
      List<Pair> list = [];
      for (String key in keyList) {
        list.add(map[key]);
      }
      return list;
    } catch (e) {
      return [];
    }
  }

  static List<String> toNameList<N>(BuildContext context, List<Pair> list) {
    List<String> values = [];
    for (Pair v in list) {
      values.add(v.nameGetter(context));
    }
    return values;
  }

  static String toSummary(BuildContext context, List<Pair> list) {
    StringBuffer b = new StringBuffer();
    for (Pair item in list) {
      b.write(",");
      b.write(item.nameGetter(context));
    }

    if (b.isEmpty) {
      return "";
    }

    String summary = b.toString();
    if (summary[0] == ',') {
      return summary.substring(1);
    }
    return summary;
  }
}

class VoicePair extends Pair {

  VoicePair(String key, LocalizedStringGetter name, this.voice) : super(key, name);

  final LocalizedStringGetter voice;
}

typedef ValueConverter<T> = T Function(T valueInDefaultUnit);

class Unit<T> extends VoicePair {

  Unit(
      String key,
      LocalizedStringGetter name,
      LocalizedStringGetter voice,
      this.converter
  ) : super(key, name, voice);

  final ValueConverter<T> converter;

  T getValue(T valueInDefaultUnit) {
    return converter(valueInDefaultUnit);
  }

  String getValueWithUnit(BuildContext context, T valueInDefaultUnit) {
    return '${formatValue(getValue(valueInDefaultUnit))}${nameGetter(context)}';
  }

  String formatValue(T value) {
    return value.toString();
  }
}