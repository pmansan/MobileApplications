import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:planner_app/models/planner.dart';

class DataBaseService {
  final String? uid;
  String imagePath = '';

  DataBaseService({this.uid});

  final CollectionReference plannerCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(String name, String email) async {
    return await plannerCollection.doc(uid).set({
      'name': name,
      'email': email,
      'trips': '',
      'imagePath': '',
    });
  }

  Future updateUserName(String name) async {
    DocumentSnapshot dataSnapshot =
        await DataBaseService(uid: uid).plannerCollection.doc(uid).get();

    return await plannerCollection.doc(uid).set({
      'name': name,
      'email': dataSnapshot.get('email'),
      'trips': dataSnapshot.get('trips'),
      'imagePath': dataSnapshot.get('imagePath'),
    });
  }

  Future updateUserPPicture(String imagePath) async {
    DocumentSnapshot dataSnapshot =
        await DataBaseService(uid: uid).plannerCollection.doc(uid).get();

    if (imagePath != null) {
      // Subir la imagen a Firebase Storage
      final storageRef = firebase_storage.FirebaseStorage.instance.ref();
      final imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final uploadTask = storageRef.child(imageName).putFile(File(imagePath));

      try {
        firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
        String downloadURL = await taskSnapshot.ref.getDownloadURL();
        print(downloadURL);

        // Save the download URL to Firestore
        return await plannerCollection.doc(uid).set({
          'name': dataSnapshot.get('name'),
          'email': dataSnapshot.get('email'),
          'trips': dataSnapshot.get('trips'),
          'imagePath':
              downloadURL, // Save the download URL instead of the local file path
        });
      } catch (error) {
        print('Error al subir la imagen a Firebase Storage: $error');
      }
    }

    return await plannerCollection.doc(uid).set({
      'name': dataSnapshot.get('name'),
      'email': dataSnapshot.get('email'),
      'trips': dataSnapshot.get('trips'),
      'imagePath': imagePath,
    });
  }

  List<Planner> _plannerListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Planner(
          name: doc.get('name') ?? '', email: doc.get('email') ?? '');
    }).toList();
  }

  Stream<List<Planner>> get users {
    return plannerCollection.snapshots().map(_plannerListFromSnapshot);
  }
}
