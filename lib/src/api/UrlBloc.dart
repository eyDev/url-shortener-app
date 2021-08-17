import 'dart:async';

import 'package:url_shortener_app/src/api/DataProvider.dart';
import 'package:url_shortener_app/src/models/UrlModel.dart';

class UrlBloc {
  static final UrlBloc ulbloc = new UrlBloc._internal();
  final DataProvider apiConnection = DataProvider();

  factory UrlBloc() {
    return ulbloc;
  }

  UrlBloc._internal() {
    ulGetURLs();
  }

  final _urlsController = StreamController<List<UrlModel>>.broadcast();

  Stream<List<UrlModel>> get urlsStream => _urlsController.stream;

  dispose() {
    _urlsController.close();
  }

  ulGetURLs() async {
    _urlsController.sink.add(await apiConnection.getURLs());
  }

  ulNewURL(UrlModel url) async {
    await apiConnection.newURL(url.urlCode, url.longUrl);
    ulGetURLs();
  }

  ulDeleteURL(String uid) async {
    await apiConnection.deleteURL(uid);
    ulGetURLs();
  }
}
