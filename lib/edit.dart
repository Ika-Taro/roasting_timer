import 'package:flutter/material.dart';

String formatTime(int milliseconds) {
  var secs = milliseconds ~/ 1000;
  var hours = (secs ~/ 3600).toString().padLeft(2, '0');
  var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
  var seconds = (secs % 60).toString().padLeft(2, '0');
  return "$hours:$minutes:$seconds";
}

class Edit extends StatefulWidget {

  String _current;
  Function _onChanged;

  Edit(this._current, this._onChanged,);

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  late Stopwatch _stopwatch;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
  }
  void handleStartStop() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
    } else {
      _stopwatch.start();
    }
    setState(() {});    // re-render the page
  }

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
        child: Column(
          children: <Widget>[
            Text(formatTime(_stopwatch.elapsedMilliseconds),
                style: const TextStyle(fontSize: 48.0)),
            ElevatedButton(
                onPressed: handleStartStop,
                child: Text(_stopwatch.isRunning ? 'Stop' : 'Start')),

            TextField(
              controller: TextEditingController(text: widget._current),
              maxLines: 99,
              style: const TextStyle(color: Colors.black),
              onChanged: (text) {
                widget._current = text;
                widget._onChanged(widget._current);
              },
            ),

            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) {
            //         return Edit(_stopwatch.elapsed.toString());
            //       }),
            //     );
            //   },
            //   child: const Text('保存'),
            // ),
          ],
        ),
      ),
    );
  }
}
