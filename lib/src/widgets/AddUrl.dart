import 'package:flutter/material.dart';
import 'package:url_shortener_app/src/api/UrlBloc.dart';
import 'package:url_shortener_app/src/models/UrlModel.dart';
import 'package:url_shortener_app/src/widgets/InputField.dart';

class AddUrl extends StatefulWidget {
  const AddUrl({Key? key}) : super(key: key);

  @override
  _AddUrlState createState() => _AddUrlState();
}

class _AddUrlState extends State<AddUrl> {
  final TextEditingController urlCodeController = TextEditingController();
  final TextEditingController longUrlController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UrlBloc urlbloc = UrlBloc();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(
          'Acortar Url',
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: ListBody(
              children: <Widget>[
                InputField(
                  label: 'Código de la url',
                  regexPattern: RegExp(r"(^([a-zA-Z0-9]{4,8})$)"),
                  inputType: TextInputType.text,
                  controller: urlCodeController,
                ),
                SizedBox(height: 15),
                InputField(
                  label: 'Url original',
                  regexPattern: RegExp(r"(http|ftp|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?"),
                  inputType: TextInputType.text,
                  controller: longUrlController,
                ),
              ],
            ),
          ),
        ),
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
              if (_formKey.currentState!.validate()) {
                urlbloc.ulNewURL(UrlModel(
                  urlCode: urlCodeController.text,
                  longUrl: longUrlController.text,
                ));
                Navigator.pop(context);
              }
            },
          ),
        ]);
  }
}
