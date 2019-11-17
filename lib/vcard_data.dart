import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vcard_manager/dbmanager.dart';

class VCardData {
  int id = 1;
  String name = '';
  String designation = '';
  String phone = '';
  String email = '';
  String address = '';
  String image = '';
  String sendId = '';

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'designation': designation,
      'phone': phone,
      'email': email,
      'address': address,
      'image': image
    };
  }

  Map<String, dynamic> toMapToShare() {
    return {
      'sendId': sendId,
      'name': name,
      'designation': designation,
      'phone': phone,
      'email': email,
      'address': address,
      'image': image
    };
  }

  String geStringFormat() {
    return "Data{" +
        name +
        "," +
        designation +
        "," +
        phone +
        "," +
        email +
        "," +
        address +
        "}";
  }

  void save({isUpdate = false}) async {
    if (isUpdate) {
    } else {
      DBManager.instance.insert(this);
    }
  }

  void fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    designation = map['designation'];
    phone = map['phone'];
    email = map['email'];
    address = map['address'];
    image = map['image'];
  }

  void fromDocument(DocumentSnapshot doc) {
    name = doc['name'];
    designation = doc['designation'];
    email = doc['email'];
    phone = doc['phone'];
    address = doc['address'];
    image = doc['image'];
  }

  bool isEmpty() {
    return name.isEmpty;
  }
}
