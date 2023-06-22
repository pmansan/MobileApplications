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
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _profileName,
                decoration: InputDecoration(labelText: 'Profile Name'),
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
                child: Text('Select Photo'),
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
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
