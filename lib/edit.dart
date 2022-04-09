import 'package:flutter/material.dart';
import 'dart:async';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:roasting_timer/main.dart';

class Edit extends StatefulWidget {

  final String _current;
  final Function _onChanged;

  Edit(this._current, this._onChanged, {Key? key}) : super(key: key);

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  String formatTime(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  late Stopwatch _stopwatch;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    // re-render every 30ms
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void handleStartStop() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
    } else {
      _stopwatch.start();
    }
    setState(() {}); // re-render the page
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
              controller: TextEditingController(text: _current),
              maxLines: 99,
              style: TextStyle(color: Colors.black),
              onChanged: (text) {
                _current = text;
                _onChanged(_current);
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
