import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planner_app/main.dart';
import 'package:planner_app/models/Models.dart';
import 'package:planner_app/screens/Profile.dart';
import 'package:planner_app/screens/TripOverviewPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

  loadUserTrips() {}
}

class _HomePageState extends State<HomePage> {
  final passwordController = TextEditingController();
  List<Travel> _travels = [];
  PickedFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    loadUserTrips();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = PickedFile(pickedImage.path);
        loadUserTrips();
      });
    }
  }

  void loadUserTrips() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      QuerySnapshot tripsSnapshot =
          await usersCollection.doc(userId).collection('trips').get();

      List<Travel> trips = tripsSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Travel(
          title: data['title'],
          description: data['description'],
          startDate: data['startDate'].toDate(),
          endDate: data['endDate'].toDate(),
          imageURL: data['imageURL'],
        );
      }).toList();

      setState(() {
        _travels = trips;
      });
    } else {
      print('User is not authenticated');
    }
  }

  void _addTravel(Travel travel) {
    setState(() {
      _travels.add(travel);
    });
  }

  void _deleteTravel(int index) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');
      String title = _travels[index].title;

      usersCollection
          .doc(userId)
          .collection('trips')
          .doc(title)
          .delete()
          .then((value) {
        setState(() {
          _travels.removeAt(index);
        });
        print('Trip removed from Firestore');
      }).catchError((error) {
        print('Error when deleting the trip: $error');
      });
    } else {
      print('User is not authenticated');
    }
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
    DateTime selectedDate = DateTime.now();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    void saveTrip() async {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('users');

        // Check if an image was selected
        if (_pickedImage != null) {
          // Upload image to Firebase Storage
          final storageRef = firebase_storage.FirebaseStorage.instance.ref();
          final imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
          final uploadTask =
              storageRef.child(imageName).putFile(File(_pickedImage!.path));

          try {
            firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
            String downloadURL = await taskSnapshot.ref.getDownloadURL();

            // Create the data map for tripData with the image URL
            Map<String, dynamic> tripData = {
              'title': title,
              'description': description,
              'startDate': startDate,
              'endDate': endDate,
              'imageURL': downloadURL,
            };

            //Save tripData in Firestore
            usersCollection
                .doc(userId)
                .collection('trips')
                .doc(title)
                .set(tripData)
                .then((value) {
              print('Travel with photo stored in Firestore');
            }).catchError((error) {
              print('Error saving the trip: $error');
            });
          } catch (error) {
            print('Error uploading image to Firebase Storage: $error');
          }
        } else {
          // Create the data map for tripData without the image URL
          Map<String, dynamic> tripData = {
            'title': title,
            'description': description,
            'startDate': startDate,
            'endDate': endDate,
          };

          // Save tripData in Firestore
          usersCollection
              .doc(userId)
              .collection('trips')
              .doc(title)
              .set(tripData)
              .then((value) {
            print('Travel without photo stored in Firestore');
          }).catchError((error) {
            print('Error saving the trip: $error');
          });
        }
      } else {
        print('User is not authenticated');
      }
    }

//Dialog to add trip
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Add a new travel',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0xfb3a78b1),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: const Text(
                    'Title',
                    style: TextStyle(
                      color: Color(0xfb3a78b1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: titleController,
                      onChanged: (value) {
                        title = value;
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter the name of the travel',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  title: const Text(
                    'Description',
                    style: TextStyle(
                      color: Color(0xfb3a78b1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Expanded(
                      child: TextField(
                        controller: descriptionController,
                        onChanged: (value) {
                          description = value;
                        },
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter a description of the travel',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return ListTile(
                      title: const Text(
                        'Start Date',
                        style: TextStyle(
                          color: Color(0xfb3a78b1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
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
                          decoration: const InputDecoration(
                            hintText: 'Select Start Date',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return ListTile(
                      title: const Text(
                        'End Date',
                        style: TextStyle(
                          color: Color(0xfb3a78b1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
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
                          decoration: const InputDecoration(
                            hintText: 'Select End Date',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xfb3a78b1)),
                  ),
                  child: const Text('Add Image'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel',
                  style: TextStyle(
                    color: Color(0xfb3a78b1),
                  )),
            ),
            ElevatedButton(
              onPressed: () {
                if (title.isEmpty || startDate == null || endDate == null) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text(
                            'Please complete all the required fields.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                  return;
                } else if (endDate.isBefore(startDate)) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          'Error',
                          style: TextStyle(
                              color: Color(0xfb3a78b1),
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        content: const Text(
                            'The end date cannot be before the start date.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'OK',
                              style: TextStyle(
                                  color: Color(0xfb3a78b1),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                  return;
                }
                Travel travel = Travel(
                  title: title,
                  description: description,
                  startDate: startDate,
                  endDate: endDate,
                );
                _addTravel(travel);
                saveTrip();
                Navigator.of(context).pop();
                // loadUserTrips();
                Navigator.push(
                  context,
                  FadePageRoute(builder: (context) => HomePage()),
                );
                loadUserTrips();
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xfb3a78b1)),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

//Page
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    loadUserTrips();
    return WillPopScope(
        onWillPop: () async {
          // Block go back
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: null,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Title
                Padding(
                  padding: EdgeInsets.only(
                      left: screenHeight * 0.04,
                      bottom: screenHeight * 0.025,
                      top: screenHeight * 0.025),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    verticalDirection: VerticalDirection.down,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your trips',
                        style: TextStyle(
                            color: Color(0xfb3a78b1),
                            fontSize: 28,
                            fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
                //List of trips
                SizedBox(
                  height: screenHeight * 0.63,
                  child: ListView.builder(
                    itemCount: _travels.length,
                    itemBuilder: (context, index) {
                      return Card(
                          elevation: 0,
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: screenWidth * 0.01,
                                  horizontal: screenHeight * 0.03),
                              child: Container(
                                height: screenHeight * 0.6,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(65),
                                  image: DecorationImage(
                                      image: _travels[index].imageURL != null &&
                                              _travels[index].imageURL != 'null'
                                          ? NetworkImage(
                                              _travels[index].imageURL!)
                                          : const AssetImage(
                                                  'lib/images/blue.png')
                                              as ImageProvider<Object>,
                                      fit: BoxFit.fill),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.only(
                                    top: screenHeight * 0.5,
                                    left: screenHeight * 0.05,
                                    bottom: screenHeight * 0.045,
                                    right: screenHeight * 0.025,
                                  ),
                                  tileColor: Colors.transparent,
                                  title: Text(capitalize(_travels[index].title),
                                      style: const TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          shadows: <Shadow>[
                                            Shadow(
                                              offset: Offset(0.5, 0.5),
                                              blurRadius: 10.0,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ])),
                                  subtitle: Text(
                                      capitalize(
                                          '${_travels[index].startDate.day}/${_travels[index].startDate.month}/${_travels[index].startDate.year} - ${_travels[index].endDate.day}/${_travels[index].endDate.month}/${_travels[index].endDate.year}'),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          shadows: <Shadow>[
                                            Shadow(
                                              offset: Offset(0.5, 0.5),
                                              blurRadius: 10.0,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ])),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(0.5, 0.5),
                                          blurRadius: 10.0,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Delete Travel'),
                                            content: const Text(
                                                'Are you sure you want to delete this travel?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                    color: Color(0xfb3a78b1),
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                              Color>(
                                                          const Color(
                                                              0xfb3a78b1)),
                                                ),
                                                onPressed: () {
                                                  _deleteTravel(index);
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  onTap: () {
                                    Travel travel = _travels[index];
                                    loadUserTrips();
                                    Navigator.push(
                                      context,
                                      FadePageRoute(
                                        builder: (context) => TripOverviewPage(
                                            travel: travel,
                                            pickedimage: _pickedImage),
                                      ),
                                    );
                                  },
                                ),
                              )));
                    },
                  ),
                ),
                //Add trip icon
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
                        // foregroundColor: Color(0xfb3a78b1),
                        backgroundColor: const Color(0xfb3a78b1),
                        onPressed: _showAddTravelDialog,
                        child: const Icon(
                          Icons.add,
                        ),
                      ),
                    ],
                  ),
                ),
                //Icons home and profile
                Padding(
                  padding: EdgeInsets.only(
                      left: 0.13 * screenWidth,
                      right: 0.13 * screenWidth,
                      bottom: 0.01 * screenHeight),
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
                        color: const Color(0xfb3a78b1),
                      ),
                      SizedBox(width: 0.308 * screenWidth),
                      IconButton(
                        icon: const Icon(Icons.person_2_outlined),
                        onPressed: () {
                          Navigator.push(
                            context,
                            FadePageRoute(
                                builder: (context) => const ProfilePage()),
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
        ));
  }
}
