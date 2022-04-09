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
          ElevatedButton(
            onPressed: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: const Icon(Icons.check),
          ),
        ],
        leading: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back_ios),
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