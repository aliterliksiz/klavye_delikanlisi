import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyAppHome(),
    );
  }
}

class MyAppHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppHomeState();
  }
}

class _MyAppHomeState extends State<MyAppHome> {
  String userName = "";
  int typedCharLength = 0;
  String lorem =
      "                                           Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
          .toLowerCase()
          .replaceAll(',', '')
          .replaceAll('.', '');
  int step = 0;
  late int lastTypeAt;

  void updateLastTypeAt() {
    this.lastTypeAt = DateTime.now().millisecondsSinceEpoch;
  }

  void onType(String value) {
    updateLastTypeAt();
    String trimmedValue = lorem.trimLeft();
    setState(() {
      if (trimmedValue.indexOf(value) != 0) {
        step = 2;
      } else {
        typedCharLength = value.length;
      }
    });
  }

  void onUserNameType(String value) {
    setState(() {
      this.userName = value;
    });
  }

  void resetGame() {
    setState(() {
      typedCharLength = 0;
      step = 1;
    });
  }

  void onStartClick() {
    setState(() {
      updateLastTypeAt();
      step++;
    });
    var timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      int now = DateTime.now().millisecondsSinceEpoch;

      //GAME OVER
      setState(() {
        if (step == 1 && now - lastTypeAt > 4000) {
          step++;
        }
        if (step != 1) {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var shownWidget;

    if (step == 0)
      shownWidget = <Widget>[
        Text('Oyuna hoşgeldin, coronadan kaçmaya hazır mısın?'),
        Container(
          padding: EdgeInsets.all(20),
          child: TextField(
            onChanged: onUserNameType,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Ismin nedir delikanli',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 10),
          child: RaisedButton(
            child: Text('BASLA!'),
            onPressed: userName.length == 0 ? null : onStartClick,
          ),
        ),
      ];
    else if (step == 1)
      shownWidget = <Widget>[
        Text('$typedCharLength'),
        Container(
          height: 40,
          child: Marquee(
            text: lorem,
            style: TextStyle(fontSize: 24, letterSpacing: 2),
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            blankSpace: 20.0,
            velocity: 125,
            pauseAfterRound: Duration(seconds: 20),
            startPadding: 0,
            accelerationDuration: Duration(seconds: 15),
            accelerationCurve: Curves.ease,
            decelerationDuration: Duration(milliseconds: 500),
            decelerationCurve: Curves.easeOut,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 32),
          child: TextField(
            autofocus: true,
            onChanged: onType,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Yaz bakalım',
            ),
          ),
        )
      ];
    else
      shownWidget = <Widget>[
        Text('Coronadan kacamadin, skorun: $typedCharLength'),
        RaisedButton(
          child: Text('Yeniden dene!'),
          onPressed: resetGame,
        )
      ];
    return Scaffold(
        appBar: AppBar(
          title: Text("Klavye Delikanlısı"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: shownWidget,
          ),
        ));
  }
}
