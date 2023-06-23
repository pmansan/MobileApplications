import 'package:cloud_firestore/cloud_firestore.dart';
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
      //'imagePath': imagePath,
    });
  }

  Future updateUserName(String name) async {
    DocumentSnapshot dataSnapshot =
        await DataBaseService(uid: uid).plannerCollection.doc(uid).get();

    return await plannerCollection.doc(uid).set({
      'name': name,
      'email': dataSnapshot.get('email'),
      'trips': dataSnapshot.get('trips'),
      //'imagePath': dataSnapshot.get('imagePath'),
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
