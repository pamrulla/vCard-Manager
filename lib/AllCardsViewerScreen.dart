import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:vcard_manager/CardView.dart';
import 'package:vcard_manager/FullScreenLoadingWidget.dart';
import 'package:vcard_manager/constants.dart';
import 'package:vcard_manager/dbmanager.dart';
import 'package:vcard_manager/vcard_data.dart';

class AllCardsViewerScreen extends StatefulWidget {
  @override
  _AllCardsViewerScreenState createState() => _AllCardsViewerScreenState();
}

class _AllCardsViewerScreenState extends State<AllCardsViewerScreen> {
  int _current = 0;
  bool _isLoading = true;
  List<VCardData> data = [];
  List<Widget> cards = [];

  @override
  void initState() {
    super.initState();
    getData().then((x) {
      print(cards.length);
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> getData() async {
    List<Map<String, dynamic>> maps = await DBManager.instance.queryAllRows();
    for (var i = 0; i < maps.length; ++i) {
      if (i == 0) {
        continue;
      }
      VCardData vdata = VCardData();
      vdata.fromMap(maps[i]);
      data.add(vdata);
      cards.add(CardView(data: vdata));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('All Cards'),
        ),
        body: _isLoading ? FullScreenLoadingWidget() : getCarousel(),
      ),
    );
  }

  getCarousel() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CarouselSlider(
              items: cards,
              autoPlay: false,
              enlargeCenterPage: true,
              aspectRatio: 9 / 16,
              onPageChanged: (index) {
                setState(() {
                  _current = index;
                });
              },
              viewportFraction: 0.8,
              enableInfiniteScroll: false,
              scrollPhysics: BouncingScrollPhysics(),
            ),
          ),
        ],
      ),
    );
  }
}
