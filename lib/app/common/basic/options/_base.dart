import 'package:flutter/cupertino.dart';

class Pair<K, N> {

  static Map<K, Pair> getAll<K>(BuildContext context) {
    throw Exception("You need override this method.");
  }

  const Pair(this.key, this.name);

  final K key;
  final N name;

  static Pair toPair<K>(K key, Map<K, Pair> map) {
    return map[key];
  }

  static List<Pair> toPairList<K>(List<K> keyList, Map<K, Pair> map) {
    try {
      List<Pair> list = [];
      for (K key in keyList) {
        list.add(map[key]);
      }
      return list;
    } catch (e) {
      return [];
    }
  }

  static List<N> toNameList<N>(List<Pair> list) {
    List<N> values = [];
    for (Pair v in list) {
      values.add(v.name);
    }
    return values;
  }

  static String toSummary(List<Pair> list) {
    StringBuffer b = new StringBuffer();
    for (Pair item in list) {
      b.write(",");
      b.write(item.name);
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

class VoicePair<K, N, V> extends Pair<K, N> {

  VoicePair(K key, N name, this.voice) : super(key, name);

  final V voice;
}

typedef ValueConverter<T> = T Function(T valueInDefaultUnit);

class Unit<T> extends VoicePair<String, String, String> {

  Unit(
      String key,
      String name,
      String voice,
      this.converter
  ) : super(key, name, voice);

  final ValueConverter<T> converter;

  T getValue(T valueInDefaultUnit) {
    return converter(valueInDefaultUnit);
  }

  String getValueWithUnit(T valueInDefaultUnit) {
    return '${formatValue(getValue(valueInDefaultUnit))}$name';
  }

  String formatValue(T value) {
    return value.toString();
  }
}