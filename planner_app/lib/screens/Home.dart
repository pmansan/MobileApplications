import 'package:flutter/material.dart';
import 'package:planner_app/components/round_button.dart';
import 'package:planner_app/components/search_bar.dart';
import 'package:planner_app/screens/CreateTrip.dart';
import 'package:planner_app/screens/Profile.dart';
import 'package:planner_app/screens/TripDetailsPage.dart';
import 'package:planner_app/screens/Models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final passwordController = TextEditingController();
  List<Travel> _travels = [];

  @override
  void initState() {
    super.initState();
    loadUserTrips();
  }

  void loadUserTrips() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      QuerySnapshot tripsSnapshot = await usersCollection
          .doc(userId)
          .collection('trips')
          .get();

      List<Travel> trips = tripsSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Travel(
          title: data['title'],
          description: data['description'],
          startDate: data['startDate'].toDate(),
          endDate: data['endDate'].toDate(),
        );
      }).toList();

      setState(() {
        _travels = trips;
      });
    } else {
      print('El usuario no está autenticado');
    }
  }

  void _addTravel(Travel travel) {
    setState(() {
      _travels.add(travel);
    });
  }

  void _showAddTravelDialog() {
    String title = '';
    String description = '';
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();
    final tripCoverController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    void guardarViaje() {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('users');

        Map<String, dynamic> tripData = {
          'title': title,
          'description': description,
          'startDate': startDate,
          'endDate': endDate,
        };

        usersCollection
            .doc(userId)
            .collection('trips')
            .doc(title)
            .set(tripData)
            .then((value) {
          print('Viaje guardado en Firestore');
        }).catchError((error) {
          print('Error al guardar el viaje: $error');
        });
      } else {
        print('El usuario no está autenticado');
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a new travel'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: titleController,
                onChanged: (value) {
                  title = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter the name of the travel',
                  labelText: 'Title',
                ),
              ),
              TextField(
                controller: descriptionController,
                onChanged: (value) {
                  description = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter a description of the travel',
                  labelText: 'Description',
                ),
              ),
              StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return ListTile(
                    title: const Text('Start Date'),
                    subtitle: TextFormField(
                      readOnly: true,
                      controller: startDateController,
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: startDate,
                          firstDate: DateTime(2015),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null && picked != startDate) {
                          setState(() {
                            startDate = picked;
                            startDateController.text =
                                '${startDate.toLocal()}'.split(' ')[0];
                          });
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Select Start Date',
                      ),
                    ),
                  );
                },
              ),
              StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return ListTile(
                    title: const Text('End Date'),
                    subtitle: TextFormField(
                      readOnly: true,
                      controller: endDateController,
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: endDate,
                          firstDate: DateTime(2015),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null && picked != endDate) {
                          setState(() {
                            endDate = picked;
                            endDateController.text =
                                '${endDate.toLocal()}'.split(' ')[0];
                          });
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Select End Date',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Travel travel = Travel(
                  title: title,
                  description: description,
                  startDate: startDate,
                  endDate: endDate,
                );
                _addTravel(travel);
                Navigator.of(context).pop();
                guardarViaje();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: null,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                verticalDirection: VerticalDirection.down,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Your trips',
                    style: TextStyle(
                        color: Color(0xfb3a78b1),
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SearchBar(
              controller: passwordController,
              hintText: 'Search...',
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.60,
              child: ListView.builder(
                itemCount: _travels.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_travels[index].title),
                    subtitle: Text(_travels[index].description),
                    trailing: Text(
                      '${_travels[index].startDate.day}/${_travels[index].startDate.month}/${_travels[index].startDate.year} - ${_travels[index].endDate.day}/${_travels[index].endDate.month}/${_travels[index].endDate.year}',
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TripDetailsPage(travel: _travels[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                verticalDirection: VerticalDirection.down,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: _showAddTravelDialog,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                verticalDirection: VerticalDirection.up,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.home_outlined),
                    onPressed: () {},
                    iconSize: 0.17 * screenWidth,
                    color: const Color(0xffb3a78b1),
                  ),
                  const SizedBox(width: 130),
                  IconButton(
                    icon: const Icon(Icons.person_2_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                    iconSize: 0.17 * screenWidth,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

