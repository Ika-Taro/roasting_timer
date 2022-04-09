import 'dart:async';
import 'package:flutter/material.dart';
import 'package:roasting_timer/edit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

String formatTime(int milliseconds) {
  var secs = milliseconds ~/ 1000;
  var hours = (secs ~/ 3600).toString().padLeft(2, '0');
  var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
  var seconds = (secs % 60).toString().padLeft(2, '0');
  return "$hours:$minutes:$seconds";
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Stopwatch Example', home: StopwatchPage());
  }
}

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({Key? key}) : super(key: key);

  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
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
      appBar: AppBar(title: const Text('Stopwatch Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(formatTime(_stopwatch.elapsedMilliseconds),
                style: const TextStyle(fontSize: 48.0)),
            ElevatedButton(
                onPressed: handleStartStop,
                child: Text(_stopwatch.isRunning ? 'Stop' : 'Start')),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return MemoList();
                  }),
                );
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}

class MemoListState extends State<MemoList> {
  var _memoList = <String>[];
  var _currentIndex = -1;
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  void initState() {
    super.initState();
    loadMemoList();
  }

  @override
  Widget build(BuildContext context) {
    const title = "Home";
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: _buildList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMemo,
        tooltip: 'New Memo',
        child: const Icon(Icons.add),
      ),
    );
  }

  void loadMemoList() {
    SharedPreferences.getInstance().then((prefs) {
      const key = "memo-list";
      if (prefs.containsKey(key)) {
        _memoList = prefs.getStringList(key)!;
      }
      setState(() {});
    });
  }

  void _addMemo() {
    setState(() {
      _memoList.add("");
      _currentIndex = _memoList.length - 1;
      storeMemoList();
      Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Edit(_memoList[_currentIndex], _onChanged,);
        },
      ));
    });
  }

  void _onChanged(String text) {
    setState(() {
      _memoList[_currentIndex] = text;
      storeMemoList();
    });
  }

  void storeMemoList() async {
    final prefs = await SharedPreferences.getInstance();
    const key = "memo-list";
    final success = await prefs.setStringList(key, _memoList);
    if (!success) {
      debugPrint("Failed to store value");
    }
  }

  Widget _buildList() {
    final itemCount = _memoList.isEmpty ? 0 : _memoList.length * 2 - 1;
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: itemCount,
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return const Divider(height: 2);
          final index = (i / 2).floor();
          final memo = _memoList[index];
          return _buildWrappedRow(memo, index);
        });
  }

  Widget _buildWrappedRow(String content, int index) {
    return Dismissible(
      background: Container(color: Colors.red),
      key: Key(content),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          _memoList.removeAt(index);
          storeMemoList();
        });
      },
      child: _buildRow(content, index),
    );
  }

  Widget _buildRow(String content, int index) {
    return ListTile(
      title: Text(
        content,
        style: _biggerFont,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        _currentIndex = index;
        Navigator.of(context)
            .push(MaterialPageRoute<void>(builder: (BuildContext context) {
          return Edit(_memoList[_currentIndex], _onChanged,);
        }));
      },
    );
  }
}

// ignore: prefer_final_fields
class MemoList extends StatefulWidget {
  // const MemoList({Key? key}) : super(key: key);
  @override
  MemoListState createState() => MemoListState();
}
