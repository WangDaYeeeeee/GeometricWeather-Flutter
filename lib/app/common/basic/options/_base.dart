class Pair<K, V> {

  final K key;
  final V name;

  const Pair(this.key, this.name);

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

  static List<String> toNameList(List<Pair> list) {
    List<String> values = [];
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