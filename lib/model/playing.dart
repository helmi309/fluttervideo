import 'dart:convert';

class Playing {
  List<Result> data;
  int page;
  int totalResults;
  Dates dates;
  int from;
  int to;

  Playing({
    this.data,
    this.page,
    this.from,
    this.to,
  });

  factory Playing.fromRawJson(String str) => Playing.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Playing.fromJson(Map<String, dynamic> json) => new Playing(
        data: new List<Result>.from(
            json["data"].map((x) => Result.fromJson(x))),
        page: json["current_page"],
        from: json["from"],
        to: json["to"],
      );

  Map<String, dynamic> toJson() => {
        "data": new List<dynamic>.from(data.map((x) => x.toJson())),
        "page": page,
        "from": from,
        "to": to,
      };
}

class Dates {
  DateTime maximum;
  DateTime minimum;

  Dates({
    this.maximum,
    this.minimum,
  });

  factory Dates.fromRawJson(String str) => Dates.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Dates.fromJson(Map<String, dynamic> json) => new Dates(
        maximum: DateTime.parse(json["maximum"]),
        minimum: DateTime.parse(json["minimum"]),
      );

  Map<String, dynamic> toJson() => {
        "maximum":
            "${maximum.year.toString().padLeft(4, '0')}-${maximum.month.toString().padLeft(2, '0')}-${maximum.day.toString().padLeft(2, '0')}",
        "minimum":
            "${minimum.year.toString().padLeft(4, '0')}-${minimum.month.toString().padLeft(2, '0')}-${minimum.day.toString().padLeft(2, '0')}",
      };
}

class Result {
  int id;
  int suka;
  String name;
  String kategori;
  String file;
  String image;
  String created_at;

  Result({
    this.id,
    this.suka,
    this.name,
    this.kategori,
    this.file,
    this.image,
    this.created_at,
  });

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => new Result(
        id: json["id"],
        file: json["file"],
        kategori: json["kategori"],
        name: json["name"],
        image: json["image"],
        suka: json["suka"],
        created_at: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "file": file,
        "image": image,
        "kategori": kategori,
        "created_at": created_at,
        "suka": suka,
      };
}

enum OriginalLanguage { EN, JA }

final originalLanguageValues =
    new EnumValues({"en": OriginalLanguage.EN, "ja": OriginalLanguage.JA});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
