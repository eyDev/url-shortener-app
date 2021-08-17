import 'package:flutter/material.dart';
import 'package:url_shortener_app/src/api/Constants.dart';
import 'package:url_shortener_app/src/api/UrlBloc.dart';
import 'package:url_shortener_app/src/models/UrlModel.dart';
import 'package:url_shortener_app/src/pages/LoginPage.dart';
import 'package:url_shortener_app/src/storage/DataStorage.dart';
import 'package:url_shortener_app/src/widgets/AddUrl.dart';
import 'package:url_shortener_app/src/widgets/CustomPageRoute.dart';
import 'package:url_shortener_app/src/widgets/UrlList.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DataStorage storage = DataStorage();
  final UrlBloc urlbloc = UrlBloc();
  final Constants _constants = Constants();
  @override
  Widget build(BuildContext context) {
    urlbloc.ulGetURLs();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appbar(),
      body: _body(),
      floatingActionButton: _addButton(),
    );
  }

  AppBar _appbar() {
    return AppBar(
      title: Text(storage.userName),
      actions: [IconButton(onPressed: () => _logOutDialog(context), icon: Icon(Icons.logout))],
    );
  }

  Widget _body() {
    return StreamBuilder<List<UrlModel>>(
        stream: urlbloc.urlsStream,
        builder: (BuildContext context, AsyncSnapshot<List<UrlModel>> snapshot) {
          return UrlList(snapshot: snapshot);
        });
  }

  FloatingActionButton _addButton() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: _constants.primaryColor,
      onPressed: () => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AddUrl(),
      ),
    );
  }

  Future<void> _logOutDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Cerrar Sesión', textAlign: TextAlign.center),
        content: Text('¿Está seguro que desea cerrar sesión?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Aceptar'),
            onPressed: () {
              storage.userToken = '';
              Navigator.of(context).pushReplacement(CustomPageRoute(LoginPage()));
            },
          ),
        ],
      ),
    );
  }
}
