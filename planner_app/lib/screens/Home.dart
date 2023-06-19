import 'dart:io';

import 'package:flutter/material.dart';
import 'package:planner_app/components/round_button.dart';
import 'package:planner_app/components/search_bar.dart';
import 'package:planner_app/screens/CreateTrip.dart';
import 'package:planner_app/screens/Profile.dart';
import 'package:planner_app/screens/TripDetailsPage.dart';
import 'package:planner_app/screens/Models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planner_app/screens/TripOverviewPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

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
    // final tripCoverController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    void guardarViaje() async {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('users');

        // Verificar si se seleccionó una imagen
        if (_pickedImage != null) {
          // Subir la imagen a Firebase Storage
          final storageRef = firebase_storage.FirebaseStorage.instance.ref();
          final imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
          final uploadTask =
              storageRef.child(imageName).putFile(File(_pickedImage!.path));

          try {
            firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
            String downloadURL = await taskSnapshot.ref.getDownloadURL();

            // Crear el mapa de datos para tripData con la URL de la imagen
            Map<String, dynamic> tripData = {
              'title': title,
              'description': description,
              'startDate': startDate,
              'endDate': endDate,
              'imageURL': downloadURL, // Agregar la URL de la imagen a tripData
            };

            // travel.imageURL = downloadURL;

            // Guardar tripData en Firestore
            usersCollection
                .doc(userId)
                .collection('trips')
                .doc(title)
                .set(tripData)
                .then((value) {
              print('Viaje con foto guardado en Firestore');
            }).catchError((error) {
              print('Error al guardar el viaje: $error');
            });
          } catch (error) {
            print('Error al subir la imagen a Firebase Storage: $error');
          }
        } else {
          // Crear el mapa de datos para tripData sin la URL de la imagen
          Map<String, dynamic> tripData = {
            'title': title,
            'description': description,
            'startDate': startDate,
            'endDate': endDate,
          };

          // Guardar tripData en Firestore
          usersCollection
              .doc(userId)
              .collection('trips')
              .doc(title)
              .set(tripData)
              .then((value) {
            print('Viaje sin foto guardado en Firestore');
          }).catchError((error) {
            print('Error al guardar el viaje: $error');
          });
        }
      } else {
        print('El usuario no está autenticado');
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a new travel'),
          content: SingleChildScrollView(
              // Agregar este widget
              child: Column(
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
              }),
              //Muestra la imagen seleccionada
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Add Image'),
              ),
              // if (_pickedImage != null)
              //   Image.file(
              //     File(_pickedImage!.path),
              //     height: 90, // Ajusta la altura según tus necesidades
              //     fit: BoxFit.fitWidth,
              //   ),            
            ],
          )),
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
                // Navigator.of(context).pop();
                guardarViaje();
                Navigator.of(context).pop();
                // loadUserTrips();
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
    // loadUserTrips();
    return WillPopScope(
        onWillPop: () async {
          // Bloquea la navegación hacia atrás
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
                Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.04, bottom: MediaQuery.of(context).size.height * 0.05, top: MediaQuery.of(context).size.height * 0.025),
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
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.05,
                // ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: ListView.builder(
                    itemCount: _travels.length,
                    itemBuilder: (context, index) {
                      return Card(
                          elevation: 0,
                          child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.62,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(80),
                                  image: DecorationImage(
                                      image: _travels[index].imageURL != null &&
                                              _travels[index].imageURL != 'null'
                                          ? NetworkImage(
                                                  _travels[index].imageURL!)
                                          : const AssetImage(
                                                  'lib/images/amsterdam.jpg')
                                              as ImageProvider<Object>,
                                      // image: AssetImage('lib/images/amsterdam.jpg'),
                                      fit: BoxFit.fill),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.5,
                                      left: MediaQuery.of(context).size.height *
                                          0.05,
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.025),
                                  tileColor: Colors.transparent,

                                  title: Text(capitalize(_travels[index].title),
                                      style: const TextStyle(
                                          fontSize: 22,
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
                                  // trailing: Text(
                                  //   '${_travels[index].startDate.day}/${_travels[index].startDate.month}/${_travels[index].startDate.year} - ${_travels[index].endDate.day}/${_travels[index].endDate.month}/${_travels[index].endDate.year}',
                                  // ),
                                  onTap: () {
                                    Travel travel = _travels[index];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TripOverviewPage(travel: travel),
                                      ),
                                    );
                                  },
                                ),
                              )));
                    },
                  ),
                ),

// ...

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
                        backgroundColor: Color(0xfb3a78b1),
                        onPressed: _showAddTravelDialog,
                        child: const Icon(
                          Icons.add,
                        ),
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
                            MaterialPageRoute(
                                builder: (context) => ProfilePage()),
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
