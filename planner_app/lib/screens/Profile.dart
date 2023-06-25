import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planner_app/models/planner.dart';
import 'package:planner_app/screens/Home.dart';
import 'package:planner_app/screens/Start.dart';
import 'package:planner_app/screens/editProfile.dart';
import 'package:planner_app/services/auth.dart';
import 'package:planner_app/services/database.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String name = '';

  @override
  void initState() {
    super.initState();
    loadDataBaseData();
  }

  void loadDataBaseData() async {
    final userId = getUserId();
    if (userId != null) {
      DocumentSnapshot nameSnapshot = await DataBaseService(uid: userId)
          .plannerCollection
          .doc(userId)
          .get();

      setState(() {
        name = nameSnapshot.get('name');
      });
      print(name);
    } else {
      print('ERROR');
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
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return StreamProvider<List<Planner>>.value(
      value: DataBaseService().users,
      initialData: [],
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: null,
          body: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/images/BackgroundProfile.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 0.08 * screenWidth,
                      bottom: 0.014 * screenHeight,
                      top: 0.03 * screenHeight,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      verticalDirection: VerticalDirection.down,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Your profile',
                          style: TextStyle(
                            color: Color(0xfb3a78b1),
                            fontFamily: 'Nunito',
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    //backgroundImage: NetworkImage('URL_DE_LA_IMAGEN'),
                    radius: 0.156 * screenWidth,
                  ),
                  SizedBox(height: 0.02 * screenHeight),
                  StreamBuilder<DocumentSnapshot>(
                    stream: DataBaseService(uid: getUserId())
                        .plannerCollection
                        .doc(getUserId())
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        String name = snapshot.data!.get('name');
                        return Text(
                          name,
                          style: TextStyle(
                            color: Color(0xfb3a78b1),
                            fontFamily: 'Nunito',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        return Text('Loading...');
                      }
                    },
                  ),
                  SizedBox(height: 0.05 * screenHeight),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                    indent: 0.08 * screenWidth,
                    endIndent: 0.08 * screenWidth,
                  ),
                  SizedBox(
                    width: 0.778 * screenWidth,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfileScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.only(
                          left: 0,
                          right: 0.213 * screenWidth,
                          top: 0.032 * screenHeight,
                          bottom: 0.032 * screenHeight,
                        ),
                        elevation: 0,
                        foregroundColor: Colors.grey,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Icon(
                            Icons.edit_note_rounded,
                            color: Colors.yellow,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Edit profile",
                            style: TextStyle(
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                    indent: 0.08 * screenWidth,
                    endIndent: 0.08 * screenWidth,
                  ),
                  SizedBox(
                    width: 0.778 * screenWidth,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.only(
                          left: 0,
                          right: 0.213 * screenWidth,
                          top: 0.032 * screenHeight,
                          bottom: 0.032 * screenHeight,
                        ),
                        elevation: 0,
                        foregroundColor: Colors.grey,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Icon(
                            Icons.settings_rounded,
                            color: Colors.red,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Settings",
                            style: TextStyle(fontFamily: 'Nunito'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                        bottom: 0.12 * screenWidth,
                      ),
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey,
                        indent: 0.08 * screenWidth,
                        endIndent: 0.08 * screenWidth,
                      )),
                  // SizedBox(width: 0.1 * screenWidth),
                  InkWell(
                    onTap: () async {
                      await _auth.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StartPage()),
                      );
                      print('Succesfully signed out');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(
                        horizontal: 0.4 * screenWidth,
                        vertical: 0,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffb3a78b1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Text(
                          "Log out",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 0.13 * screenWidth,
                      right: 0.13 * screenWidth,
                      top: 0.032 * screenHeight,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      verticalDirection: VerticalDirection.up,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.home_outlined),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                            );
                          },
                          iconSize: 0.17 * screenWidth,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 0.306 * screenWidth),
                        IconButton(
                          icon: const Icon(Icons.person_2_outlined),
                          onPressed: () {},
                          iconSize: 0.17 * screenWidth,
                          color: const Color(0xffb3a78b1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
