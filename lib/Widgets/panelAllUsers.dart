import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yarisma_app/Entities/userData.dart';
import 'package:yarisma_app/Widgets/panelUserForm.dart';

class PanelAllUsers extends StatefulWidget {
  const PanelAllUsers({Key? key, required this.allUsers}) : super(key: key);
  final CollectionReference allUsers;

  @override
  _PanelAllUsersState createState() => _PanelAllUsersState();
}

class _PanelAllUsersState extends State<PanelAllUsers> {
  TextEditingController controller = new TextEditingController();
  List<UserData> _searchResult = [];
  List<UserData> _userDetails = [];

  @override
  void initState() {
    _userDetails.clear();
    widget.allUsers.snapshots().forEach((element) {
      element.docs.forEach((data) {
        _userDetails
            .add(UserData.fromJson(data.data() as Map<String, dynamic>));
        print((data.data() as Map<String, dynamic>)["nickname"]);
        setState(() {});
      });
    });
    super.initState();
  }

  Widget _buildUsersList() {
    return new ListView.builder(
      itemCount: _userDetails.length,
      itemBuilder: (context, index) {
        return PanelUserForm(
            nickname: _userDetails[index].nickname,
            rank: _userDetails[index].rank,
            email: _userDetails[index].mailAdress,
            uid: _userDetails[index].uid);
      },
    );
  }

  Widget _buildSearchResults() {
    return new ListView.builder(
      itemCount: _searchResult.length,
      itemBuilder: (context, index) {
        return PanelUserForm(
            nickname: _searchResult[index].nickname,
            rank: _searchResult[index].rank,
            email: _userDetails[index].mailAdress,
            uid: _searchResult[index].uid);
      },
    );
  }

  Widget _buildSearchBox() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Card(
        child: new ListTile(
          leading: new Icon(Icons.search),
          title: new TextField(
            controller: controller,
            decoration:
                new InputDecoration(hintText: 'Ara', border: InputBorder.none),
            onChanged: onSearchTextChanged,
          ),
          trailing: new IconButton(
            icon: new Icon(Icons.cancel),
            onPressed: () {
              controller.clear();
              onSearchTextChanged('');
            },
          ),
        ),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userDetails.forEach((temp) {
      if (temp.nickname.toUpperCase().contains(text.toUpperCase()))
        _searchResult.add(temp);
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          new Container(child: _buildSearchBox()),
          new Expanded(
              child: _searchResult.length != 0 || controller.text.isNotEmpty
                  ? _buildSearchResults()
                  : _buildUsersList()),
        ],
      ),
    );
  }
}
