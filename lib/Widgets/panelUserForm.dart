import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yarisma_app/Services/font.dart';
import 'package:yarisma_app/Services/globals.dart' as globals;

class PanelUserForm extends StatefulWidget {
  const PanelUserForm({
    Key? key,
    required this.nickname,
    required this.rank,
    required this.email,
    required this.uid,
  }) : super(key: key);
  final String nickname, rank, uid, email;

  @override
  State<PanelUserForm> createState() => _PanelUserFormState();
}

class _PanelUserFormState extends State<PanelUserForm> {
  @override
  Widget build(BuildContext context) {
    final panelFormKey = GlobalKey<FormState>();

    final double _width = globals.telefonWidth! - 70;
    String dropdownValue = widget.rank;

    final TextStyle _textStyle = AppFont().getAppFont();
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (c) => AlertDialog(
              title: Text(
                "Seçilen Kullanıcı",
                style: _textStyle.apply(fontSizeDelta: 6, color: Colors.black),
              ),
              actions: [
                TextButton(
                  child: Text('Onayla'),
                  onPressed: () {
                    if (panelFormKey.currentState!.validate()) {
                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(widget.uid)
                          .update({'rank': dropdownValue})
                          .then((value) => print("User Updated"))
                          .catchError((error) =>
                              print("Failed to update user: $error"));
                      setState(() {});
                      Navigator.pop(c, false);
                    }
                  },
                ),
                TextButton(
                  child: Text('Vazgeç'),
                  onPressed: () => Navigator.pop(c, false),
                ),
              ],
              content: Stack(
                children: <Widget>[
                  Form(
                    key: panelFormKey,
                    child: Container(
                      width: _width,
                      height: 200,
                      child: Column(
                        children: [
                          Text(
                            "Nickname " + widget.nickname,
                            style: _textStyle,
                          ),
                          Text(
                            "eMail " + widget.email,
                            style: _textStyle,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Text(
                                    "Rank: ",
                                    style: _textStyle,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: DropdownButton<String>(
                                    value: dropdownValue,
                                    icon: const Icon(
                                      Icons.arrow_downward,
                                      color: Colors.black,
                                    ),
                                    iconSize: 20,
                                    elevation: 16,
                                    dropdownColor: Colors.white,
                                    style: _textStyle,
                                    underline: Container(
                                      height: 2,
                                      color: Colors.black,
                                    ),
                                    onChanged: (String? newValue) {
                                      dropdownValue = newValue!;
                                      setState(() {});
                                    },
                                    items: <String>[
                                      'user',
                                      'moderator',
                                      'admin',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: _textStyle,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blueAccent,
              width: 2,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15)),
          ),
          child: Column(
            children: [
              Text(
                "Nickname: " + widget.nickname,
                style: _textStyle,
              ),
              Text(
                "Rank: " + widget.rank,
                style: _textStyle,
              ),
              Text(
                "eMail: " + widget.email,
                style: _textStyle,
              ),
              Text(
                "UID: " + widget.uid,
                style: _textStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
