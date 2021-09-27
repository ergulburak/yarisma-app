import 'package:flutter/material.dart';

class InfoPillSheet extends StatelessWidget {
  const InfoPillSheet({
    Key? key,
    required String userData,
    required TextStyle textStyle,
    required IconData icon,
    required Color color,
  })   : _userData = userData,
        _textStyle = textStyle,
        _icon = icon,
        _color = color,
        super(key: key);

  final String _userData;
  final TextStyle _textStyle;
  final IconData _icon;
  final Color _color;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(5, 2, 2, 2),
            child: Container(
              height: 20,
              width: 20,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Icon(
                  _icon,
                  color: _color,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(2, 2, 5, 2),
            child: Text(
              _userData,
              style: _textStyle.apply(color: _color),
            ),
          ),
        ],
      ),
    );
  }
}
