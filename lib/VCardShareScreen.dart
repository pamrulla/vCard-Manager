import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:vcard_manager/constants.dart';
import 'package:vcard_manager/vcard_data.dart';

class VCardShareScreen extends StatefulWidget {
  VCardShareScreen({this.data});
  final VCardData data;

  @override
  _VCardShareScreenState createState() => _VCardShareScreenState();
}

class _VCardShareScreenState extends State<VCardShareScreen> {
  VCardData _data = new VCardData();

  @override
  void initState() {
    super.initState();
    _data = widget.data;
  }

  void onShare() async {
    _data.sendId = randomNumeric(5);
    Firestore.instance
        .collection(kFirestoreCollectionName)
        .add(_data.toMapToShare())
        .then((x) {
      Firestore.instance
          .collection(kFirestoreCollectionName)
          .where('sendId', isEqualTo: _data.sendId)
          .snapshots()
          .listen((data) {
        data.documents.forEach((doc) {
          doc.reference.delete();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share vCard'),
      ),
      body: SafeArea(
        child: Center(
          child: Text('This is to share stuff'),
        ),
      ),
    );
  }
}
