import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vcard_manager/constants.dart';

class FullScreenLoadingWidget extends StatelessWidget {
  const FullScreenLoadingWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SpinKitChasingDots(
          color: kSecondaryLightColor,
          size: 50.0,
        ),
        SizedBox(
          height: 20.0,
        ),
        Text('Please wait...'),
      ],
    );
  }
}
