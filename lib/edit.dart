import 'package:flutter/material.dart';

class Edit extends StatelessWidget {
  String _current;
  final Function _onChanged;

  Edit(this._current, this._onChanged, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: const Icon(Icons.check),
            shape: const CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
        leading: FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back_ios),
          shape: const CircleBorder(side: BorderSide(color: Colors.transparent)),
        ),
      ),
      body: Container(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: TextEditingController(text: _current),
            maxLines: 99,
            style: const TextStyle(color: Colors.black),
            onChanged: (text) {
              _current = text;
              _onChanged(_current);
            },
          )),
    );
  }
}

