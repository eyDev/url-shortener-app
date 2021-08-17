class Urls {
  List<UrlModel> modelPlaceFromJson(dynamic response) => List<UrlModel>.from(
        response.map(
          (x) => UrlModel.fromJson(x),
        ),
      );
}

class UrlModel {
  String? uid;
  String urlCode;
  String longUrl;
  String? shortUrl;

  UrlModel({
    this.uid,
    required this.urlCode,
    required this.longUrl,
    this.shortUrl,
  });

  factory UrlModel.fromJson(Map<String, dynamic> json) => UrlModel(
        uid: json["uid"],
        urlCode: json["urlCode"],
        longUrl: json["longUrl"],
        shortUrl: json["shortUrl"],
      );
}
