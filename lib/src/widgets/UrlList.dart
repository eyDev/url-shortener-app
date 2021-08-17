import 'package:flutter/material.dart';
import 'package:url_shortener_app/src/api/Constants.dart';
import 'package:url_shortener_app/src/api/UrlBloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_shortener_app/src/models/UrlModel.dart';

class UrlList extends StatelessWidget {
  const UrlList({Key? key, required this.snapshot}) : super(key: key);
  final AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final Constants _constants = Constants();
    final UrlBloc db = UrlBloc();
    if (!snapshot.hasData) {
      return Center(child: CircularProgressIndicator());
    }
    final List<UrlModel> urls = snapshot.data;
    if (urls.length == 0) {
      return Center(
        child: Image.asset(
          'assets/empty.png',
          width: MediaQuery.of(context).size.width / 2,
        ),
      );
    }
    return ListView.builder(
      itemCount: urls.length,
      itemBuilder: (context, i) => Dismissible(
        key: UniqueKey(),
        background: Container(color: _constants.primaryColor),
        onDismissed: (direction) => db.ulDeleteURL(urls[i].uid!),
        child: ListTile(
          trailing: IconButton(
            onPressed: () => launchURL(urls[i].shortUrl!),
            icon: Icon(Icons.launch),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          title: Text(urls[i].shortUrl!),
          subtitle: Text(urls[i].longUrl),
        ),
      ),
    );
  }

  launchURL(String text) async {
    if (await canLaunch(text)) {
      await launch(text);
    } else {
      await launch('https://www.google.com/search?q=$text');
    }
  }
}
