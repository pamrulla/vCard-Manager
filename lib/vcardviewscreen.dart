import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:vcard_manager/AllCardsViewerScreen.dart';
import 'package:vcard_manager/CardView.dart';
import 'package:vcard_manager/VCardShareScreen.dart';
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
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return VCardShareScreen(data: _data);
      }));
    } else {
      await showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('No Network connection.'),
                  Text('Please check your connection before proceeding.'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
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
            icon: Icon(Icons.view_carousel),
            onPressed: onViewAll,
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
        child: CardView(data: _data),
      ),
    );
  }

  void onViewAll() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AllCardsViewerScreen();
    }));
  }
}
