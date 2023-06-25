import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planner_app/services/auth.dart';
import 'package:planner_app/services/database.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _profileName = '';
  String? _newPhotoPath;
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  Future<void> _selectImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newPhotoPath = pickedFile.path;
      });
    }
  }

  void _checkForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Navigator.pop(context);
    }
  }

  String? getUserId() {
    final user = _auth.getUid();
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Color(0xffb3a78b1), size: 35 //change your color here
            ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
        
        body: SafeArea(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, bottom: 25, top:0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              verticalDirection: VerticalDirection.down,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Edit profile',
                  style: TextStyle(
                      color: Color(0xfb3a78b1),
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _profileName,
                    decoration: InputDecoration(labelText: 'Profile Name', labelStyle: TextStyle(
                      color: Color(0xfb3a78b1),
                      fontWeight: FontWeight.bold),
                
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:Color(0xfb3a78b1),))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a profile name';
                      }
                      return null;
                    },
                    onSaved: (value) async {
                      _profileName = value!;
                      final userId = getUserId();
                      await DataBaseService(uid: userId).updateUserName(value);
                      print('nombre cambiado');
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _selectImage,
                    style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xfb3a78b1)),
                  ),
                    child: Text('Select Photo',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  if (_newPhotoPath != null) ...[
                    //Image.file(File(_newPhotoPath!), height: 100),
                    SizedBox(height: 16.0),
                  ],
                  ElevatedButton(
                    onPressed: () {
                      _checkForm();
                    },
                    style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xfb3a78b1)),
                  ),
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        ])));
  }
}
