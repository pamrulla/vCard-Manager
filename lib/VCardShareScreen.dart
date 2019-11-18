import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:vcard_manager/CardView.dart';
import 'package:vcard_manager/CustomTextFromField.dart';
import 'package:vcard_manager/FullScreenLoadingWidget.dart';
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
  VCardData _otherData = new VCardData();
  String _otherKey = '';
  final int maxLength = 5;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode _focusNodeOtherKey = new FocusNode();
  static final TextEditingController _OtherKeyController =
      new TextEditingController();
  bool _isLoading = true;
  bool _isDispalyOtherCard = false;

  @override
  void initState() {
    super.initState();
    _data = widget.data;
    uploadMyCard();
  }

  @override
  void deactivate() {
    super.deactivate();
    cleanCollection();
  }

  void cleanCollection() async {
    await Firestore.instance
        .collection(kFirestoreCollectionName)
        .where('sendId', isEqualTo: _data.sendId)
        .snapshots()
        .listen((data) {
      data.documents.forEach((doc) {
        print('clean');
        doc.reference.delete();
      });
    });
  }

  void uploadMyCard() async {
    _data.sendId = randomNumeric(maxLength);
    Firestore.instance
        .collection(kFirestoreCollectionName)
        .add(_data.toMapToShare())
        .then((x) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void showAlert() async {
    await showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Can\'t download vCard.'),
                  Text(
                      'Please check entered key is correct and connected to network.'),
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
        });
  }

  void onShare() async {
    Firestore.instance
        .collection(kFirestoreCollectionName)
        .where('sendId', isEqualTo: _otherKey)
        .snapshots()
        .listen((data) async {
      if (data.documents.length == 0) {
        await showAlert();
        return;
      }
      data.documents.forEach((doc) async {
        _otherData.fromDocument(doc);
        if (_otherData.isEmpty()) {
          await showAlert();
        } else {
          print(_otherData.geStringFormat());
          setState(() {
            _isLoading = false;
            _isDispalyOtherCard = true;
          });
        }
      });
    });
  }

  void onSave() async {
    setState(() {
      _isLoading = false;
    });
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      onShare();
    }
  }

  Widget getShareForm() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Card(
            elevation: 20.0,
            color: kPrimaryColor,
            child: Container(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'This is your key, please share it with other user to get your vCard.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        _data.sendId,
                        style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Card(
            elevation: 20.0,
            color: kPrimaryColor,
            child: Container(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'Enter other user\'s key to get his/her vCard.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            CustomTextFromField(
                              focusNode: _focusNodeOtherKey,
                              icon: Icons.vpn_key,
                              hintText: 'Enter Other Key',
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Enter Other Key';
                                }
                                if (value.length != maxLength) {
                                  return 'Key should be of length 5';
                                }
                                return null;
                              },
                              controller: _OtherKeyController,
                              onSaved: (val) => setState(() => _otherKey = val),
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (term) {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                              },
                              keyboardType: TextInputType.phone,
                              maxLength: maxLength,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      RaisedButton(
                        padding: EdgeInsets.all(20.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.red)),
                        onPressed: onSave,
                        color: Colors.red,
                        textColor: Colors.white,
                        child: Text("Share Now".toUpperCase(),
                            style: TextStyle(fontSize: 14)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getCardView() {
    return Card(
      elevation: 20.0,
      color: kPrimaryColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 9,
              child: CardView(data: _otherData),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Container(
                        child: Ink(
                          decoration: ShapeDecoration(
                            color: kSecondaryLightColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: kSecondaryLightColor)),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.clear),
                            color: Colors.red,
                            iconSize: 40.0,
                            onPressed: onCancel,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        child: Ink(
                          decoration: ShapeDecoration(
                            color: kSecondaryLightColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: kSecondaryLightColor)),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.done),
                            color: Colors.green,
                            iconSize: 40.0,
                            onPressed: onConfirm,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share vCard'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: _isDispalyOtherCard
              ? getCardView()
              : _isLoading ? new FullScreenLoadingWidget() : getShareForm(),
        ),
      ),
    );
  }

  void onConfirm() async {
    cleanCollection();
    await _otherData.save();
    _isDispalyOtherCard = false;
    Navigator.pop(context);
  }

  void onCancel() {
    cleanCollection();
    uploadMyCard();
    setState(() {
      _isDispalyOtherCard = false;
      _isLoading = false;
    });
  }
}
