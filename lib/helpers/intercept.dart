class Intercept {
  int id = 0;
  String number = "";
  double at = 0;

  Intercept(this.id, this.number, this.at);

  toJson() {
    return {
      'id': id,
      'number': number,
      'at': at,
    };
  }

  factory Intercept.fromJson(Map<String, dynamic> json) {
    return Intercept(
      json['id'],
      json['number'],
      json['at'],
    );
  }
}
