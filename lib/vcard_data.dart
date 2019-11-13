import 'package:vcard_manager/dbmanager.dart';

class VCardData {
  int id = 1;
  String name = '';
  String designation = '';
  String phone = '';
  String email = '';
  String address = '';
  String image = '';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'designation': designation,
      'phone': phone,
      'email': email,
      'address': address,
      'image': image,
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

  void save() async {
    DBManager.instance.insert(this);
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
}
