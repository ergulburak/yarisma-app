import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:yarisma_app/Services/font.dart';
import 'package:yarisma_app/Services/globals.dart' as globals;
import 'package:yarisma_app/Services/hexToColor.dart';

class CooldownScreen extends StatefulWidget {
  CooldownScreen({
    required this.callback,
  });

  final ValueChanged<String> callback;

  @override
  _CooldownScreenState createState() => _CooldownScreenState();
}

class _CooldownScreenState extends State<CooldownScreen> {
  TextStyle _textStyle = AppFont().getAppFont();
  late Timer _timer;
  int standbyTime = 3;
  static const oneSec = const Duration(seconds: 1);

  @override
  void initState() {
    _timer = new Timer.periodic(oneSec, (timer) {
      if (standbyTime == 0) {
        setState(() {
          timer.cancel();
          widget.callback("cooldown");
        });
      } else {
        setState(() {
          standbyTime--;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: globals.telefonWidth,
      height: globals.telefonHeight,
      child: Stack(
        children: [
          FlareActor(
            "assets/Loading.flr",
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: 'Alarm',
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              standbyTime.toString(),
              style: _textStyle.apply(
                color: HexColor().getColor("#03fcc2"),
                fontSizeDelta: 30,
                fontWeightDelta: 2,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(0, 0),
                    blurRadius: 5,
                  ),
                  Shadow(
                    color: Colors.black,
                    offset: Offset(0, 0),
                    blurRadius: 5,
                  ),
                  Shadow(
                    color: Colors.black,
                    offset: Offset(0, 0),
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
