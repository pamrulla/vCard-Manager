import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vcard_manager/CustomTextFromField.dart';
import 'package:vcard_manager/Utility.dart';
import 'package:vcard_manager/vcardviewscreen.dart';

import 'vcard_data.dart';

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.parse(s, (e) => null) != null;
}

class VCardEditScreen extends StatefulWidget {
  VCardEditScreen({this.data});

  final data;
  @override
  _VCardEditScreenState createState() => _VCardEditScreenState();
}

class _VCardEditScreenState extends State<VCardEditScreen> {
  String _image = 'images/profile.jpg';
  VCardData _data = VCardData();
  String _imageAsString = '';
  bool _imageChanged = false;
  bool _isUpdate = false;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  FocusNode _focusNodeName = new FocusNode();
  FocusNode _focusNodePhone = new FocusNode();
  FocusNode _focusNodeEmail = new FocusNode();
  FocusNode _focusNodeDesignation = new FocusNode();
  FocusNode _focusNodeAddress = new FocusNode();
  static final TextEditingController _nameController =
      new TextEditingController();
  static final TextEditingController _phoneController =
      new TextEditingController();
  static final TextEditingController _emailController =
      new TextEditingController();
  static final TextEditingController _designationController =
      new TextEditingController();
  static final TextEditingController _addressnController =
      new TextEditingController();

  @override
  void initState() {
    super.initState();
    this._data = widget.data;
    _addressnController.text = _data.address;
    _emailController.text = _data.email;
    _phoneController.text = _data.phone;
    _designationController.text = _data.designation;
    _nameController.text = _data.name;
    _imageAsString = _data.image;
    _isUpdate = Navigator.canPop(context);
  }

  @override
  void deactivate() {
    //if (!Navigator.canPop(context)) {
    //  DBManager.instance.close();
    //}
    super.deactivate();
  }

  void onSave() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _data.image = _imageAsString;
      await _data.save(isUpdate: _isUpdate);

      if (Navigator.canPop(context)) {
        Navigator.pop(context, _data);
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return VCardViewScreen(
            data: _data,
          );
        }));
      }
    }
  }

  ImageProvider getImageToDisplay() {
    if (_imageChanged) {
      return MemoryImage(Utility.dataFromBase64String(_imageAsString));
    } else {
      return _data.image.isEmpty
          ? AssetImage(_image)
          : MemoryImage(Utility.dataFromBase64String(_data.image));
    }
  }

  Widget _simplePopup() => PopupMenuButton<ImageSource>(
      onSelected: (ImageSource result) {
        onSelectImage(result);
      },
      itemBuilder: (context) => [
            PopupMenuItem(
              value: ImageSource.camera,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.camera,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text("Camera"),
                ],
              ),
            ),
            PopupMenuDivider(),
            PopupMenuItem(
              value: ImageSource.gallery,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.photo_library,
                    color: Colors.pinkAccent,
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text("Gallery"),
                ],
              ),
            ),
          ],
      child: CircleAvatar(
        radius: 75.0,
        backgroundImage: getImageToDisplay(),
      ));

  void onSelectImage(ImageSource type) async {
    var image = await ImagePicker.pickImage(
      source: type,
      maxWidth: 400,
      maxHeight: 400,
      imageQuality: 80,
    );
    if (image != null) {
      _imageAsString = Utility.base64String(image.readAsBytesSync());
      setState(() {
        _image = image.path;
        _imageChanged = true;
        image.delete();
      });
    }
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(context, widget.data);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, widget.data),
          ),
          title: Text('V-Card Edit'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              iconSize: 40.0,
              onPressed: onSave,
            )
          ],
        ),
        body: SafeArea(
          top: false,
          bottom: false,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  _simplePopup(),
                  CustomTextFromField(
                    focusNode: _focusNodeName,
                    icon: Icons.label_important,
                    hintText: 'Your Full Name',
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Your Name';
                      }
                      return null;
                    },
                    controller: _nameController,
                    onSaved: (val) => setState(() => _data.name = val),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(
                          context, _focusNodeName, _focusNodeDesignation);
                    },
                  ),
                  CustomTextFromField(
                    focusNode: _focusNodeDesignation,
                    icon: Icons.work,
                    hintText: 'Your Designation',
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Your Designation';
                      }
                      return null;
                    },
                    controller: _designationController,
                    onSaved: (val) => setState(() => _data.designation = val),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(
                          context, _focusNodeDesignation, _focusNodePhone);
                    },
                  ),
                  CustomTextFromField(
                    focusNode: _focusNodePhone,
                    icon: Icons.phone,
                    hintText: 'Your Phone Number',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value.isEmpty || !isNumeric(value)) {
                        return 'Enter Your Phone Number';
                      }
                      return null;
                    },
                    controller: _phoneController,
                    onSaved: (val) => setState(() => _data.phone = val),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(
                          context, _focusNodePhone, _focusNodeEmail);
                    },
                  ),
                  CustomTextFromField(
                    focusNode: _focusNodeEmail,
                    icon: Icons.email,
                    hintText: 'Your Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty || !value.contains("@")) {
                        return 'Enter Your Email';
                      }
                      return null;
                    },
                    controller: _emailController,
                    onSaved: (val) => setState(() => _data.email = val),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(
                          context, _focusNodeEmail, _focusNodeAddress);
                    },
                  ),
                  CustomTextFromField(
                    focusNode: _focusNodeAddress,
                    icon: Icons.location_city,
                    hintText: 'Your Full Address',
                    maxLines: 6,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Your Address';
                      }
                      return null;
                    },
                    controller: _addressnController,
                    onSaved: (val) => setState(() => _data.address = val),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (term) {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
