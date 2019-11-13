import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vcard_manager/constants.dart';
import 'package:vcard_manager/dbmanager.dart';
import 'package:vcard_manager/vcard_data.dart';
import 'package:vcard_manager/vcardeditscreen.dart';
import 'package:vcard_manager/vcardviewscreen.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    List<Map<String, dynamic>> maps = await DBManager.instance.queryAllRows();
    if (maps.length != 0) {
      VCardData vdata = VCardData();
      vdata.fromMap(maps[0]);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return VCardViewScreen(
          data: vdata,
        );
      }));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return VCardEditScreen(data: VCardData());
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Image.asset('images/logo_transparent.png'),
                    ),
                    Expanded(
                      flex: 1,
                      child: SpinKitChasingDots(
                        color: kSecondaryLightColor,
                        size: 50.0,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Image.asset('images/khanscode.png'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
