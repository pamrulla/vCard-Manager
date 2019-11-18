import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vcard_manager/Utility.dart';
import 'package:vcard_manager/constants.dart';
import 'package:vcard_manager/vcard_data.dart';

class CardView extends StatelessWidget {
  final VCardData data;
  CardView({this.data});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 75.0,
              backgroundImage:
                  MemoryImage(Utility.dataFromBase64String(data.image)),
            ),
            Text(
              data.name,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontFamily: 'Pacifico',
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              data.designation.toUpperCase(),
              style: TextStyle(
                fontSize: 20,
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
                color: kSecondaryLightColor,
              ),
              textAlign: TextAlign.center,
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
                  data.phone,
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
                  data.email,
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
                  data.address,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 14.0,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
