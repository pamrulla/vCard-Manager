import 'package:flutter/material.dart';
import 'package:vcard_manager/Utility.dart';
import 'package:vcard_manager/VCardShareScreen.dart';
import 'package:vcard_manager/constants.dart';
import 'package:vcard_manager/vcard_data.dart';
import 'package:vcard_manager/vcardeditscreen.dart';

class VCardViewScreen extends StatefulWidget {
  VCardViewScreen({this.data});
  final data;

  @override
  _VCardViewScreenState createState() => _VCardViewScreenState();
}

class _VCardViewScreenState extends State<VCardViewScreen> {
  VCardData _data = new VCardData();

  @override
  void initState() {
    super.initState();
    _data = widget.data;
  }

  @override
  void deactivate() {
    //if (!Navigator.canPop(context)) {
    //  DBManager.instance.close();
    //}
    super.deactivate();
  }

  void onEdit() async {
    _data = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return VCardEditScreen(data: _data);
    }));
    setState(() {});
  }

  void onShare() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return VCardShareScreen(data: _data);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('V-Card'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: onShare,
            iconSize: 40.0,
          ),
          IconButton(
            icon: Icon(Icons.mode_edit),
            onPressed: onEdit,
            iconSize: 40.0,
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 75.0,
              backgroundImage:
                  MemoryImage(Utility.dataFromBase64String(_data.image)),
            ),
            Text(
              _data.name,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontFamily: 'Pacifico',
              ),
            ),
            Text(
              _data.designation.toUpperCase(),
              style: TextStyle(
                fontSize: 20,
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
                color: kSecondaryLightColor,
              ),
            ),
            SizedBox(
              height: 25.0,
              width: 200.0,
              child: (Divider()),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                leading: Icon(
                  Icons.phone,
                  color: Theme.of(context).accentColor,
                ),
                title: Text(
                  _data.phone,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                leading: Icon(
                  Icons.mail,
                  color: Theme.of(context).accentColor,
                ),
                title: Text(
                  _data.email,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                leading: Icon(
                  Icons.location_city,
                  color: Theme.of(context).accentColor,
                ),
                title: Text(
                  _data.address,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 14.0,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
