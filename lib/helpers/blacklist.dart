class BlacklistEntry {
  final String value;
  final BlacklistType type;
  bool isEnable;

  BlacklistEntry(this.value, this.type, this.isEnable);

  factory BlacklistEntry.fromJson(Map<String, dynamic> json) {
    return BlacklistEntry(
      json['value'],
      BlacklistType.fromJson(json['type']),
      json['isEnable'],
    );
  }


  Map<String, dynamic> toJson() => {
        'value': value,
        'type': type.toJson(),
        'isEnable': isEnable,
      };
}

enum BlacklistType {

  BLACKLIST,
  PREFIX;

  String toJson() => name;
  static BlacklistType fromJson(String json) => values.byName(json);
}
