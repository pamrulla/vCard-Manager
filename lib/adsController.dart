import 'package:firebase_admob/firebase_admob.dart';

class adsController {
  static final String appId = 'ca-app-pub-4197146727812625~8895393729';
  static final String bannerId = 'ca-app-pub-4197146727812625/6847459660';
  static final String interstitialId = 'ca-app-pub-4197146727812625~8895393729';

  adsController._privateConstructor() {
    FirebaseAdMob.instance
        .initialize(appId: appId /*FirebaseAdMob
            .testAppId*/
            );
  }
  static adsController instance = adsController._privateConstructor();

  static MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['flutterio', 'beautiful apps'],
    contentUrl: 'https://flutter.io',
    childDirected: false,
    testDevices: <String>[], // Android emulators are considered test devices
  );

  BannerAd myBanner = BannerAd(
    adUnitId: bannerId /*BannerAd.testAdUnitId*/,
    size: AdSize.smartBanner,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("BannerAd event is $event");
    },
  );

  InterstitialAd myInterstitial = InterstitialAd(
    adUnitId: bannerId /*InterstitialAd.testAdUnitId*/,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event is $event");
    },
  );
}
