import 'package:flutter/material.dart';
import 'package:planner_app/screens/Models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class TripDetailsPage extends StatefulWidget {
  final Travel travel;
  // final String tripId;

  const TripDetailsPage({required this.travel});

  @override
  _TripDetailsPageState createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends State<TripDetailsPage> {
  Map<int, List<Activity>> _activitiesMap = {};
  List<Activity> _activities = [];
  int _selectedDay = 1;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // PickedFile? _pickedImage;

  // Future<void> _pickImage() async {
  //   final picker = ImagePicker();
  //   final pickedImage = await picker.pickImage(source: ImageSource.gallery);

  //   if (pickedImage != null) {
  //     setState(() {
  //       _pickedImage = PickedFile(pickedImage.path);
  //       print(_pickedImage);
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    loadDatabaseData();
  }

  void loadDatabaseData() {
    final userId = getUserId();
    if (userId != null) {
      if (_activitiesMap.containsKey(_selectedDay)) {
        // Si las actividades para el día seleccionado ya se han cargado, usarlas desde el mapa
        setState(() {
          _activities = _activitiesMap[_selectedDay]!;
        });
      } else {
        _firestore
            .collection('users')
            .doc(userId)
            .collection('trips')
            .doc(widget.travel.title)
            .collection('days')
            .doc('day$_selectedDay')
            .collection('activities')
            .get()
            .then((activitiesSnapshot) {
          final List<Activity> loadedActivities = [];
          activitiesSnapshot.docs.forEach((activityDoc) {
            final data = activityDoc.data();
            final title = data['title'];
            final id = activityDoc.id;
            final time = data['time'].toDate();
            Activity activity =
                Activity(title: title, time: time, day: _selectedDay, id: id);
            loadedActivities.add(activity);
          });

          setState(() {
            _activities = loadedActivities;
            _activitiesMap[_selectedDay] =
                loadedActivities; // Almacenar las actividades en el mapa
          });
        });
      }
    }
  }

  String? getUserId() {
    final user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }

  void _addActivity(String title, DateTime time) {
    setState(() {
      String? userId = getUserId();
      if (userId != null) {
        DocumentReference docRef = _firestore
            .collection('users')
            .doc(userId)
            .collection('trips')
            .doc(widget.travel.title)
            .collection('days')
            .doc('day$_selectedDay')
            .collection('activities')
            .doc();

        Activity activity = Activity(
          title: title,
          time: time,
          day: _selectedDay,
          id: docRef.id, // Asignar el ID generado automáticamente por Firestore
        );

        _activities.add(activity);
        _activities.sort((a, b) => a.time.compareTo(b.time));

        docRef.set({
          'title': title,
          'time': time,
        });
      }
    });
  }

  void _editActivity(Activity activity, String newTitle, DateTime newTime) {
    setState(() {
      activity.title = newTitle;
      activity.time = newTime;
      _activities.sort((a, b) => a.time.compareTo(b.time));

      String? userId = getUserId();
      if (userId != null) {
        _firestore
            .collection('users')
            .doc(userId)
            .collection('trips')
            .doc(widget.travel.title)
            .collection('days')
            .doc('day$_selectedDay')
            .collection('activities')
            .doc(activity.id)
            .update({
          'title': newTitle,
          'time': newTime,
        }).then((_) {
          print('Actividad actualizada en Firestore.');
        }).catchError((error) {
          print('Error al actualizar la actividad: $error');
        });
      }
    });
  }

  void _deleteActivity(Activity activity) {
    setState(() {
      _activities.remove(activity);

      String? userId = getUserId();
      if (userId != null && activity.id != null) {
        _firestore
            .collection('users')
            .doc(userId)
            .collection('trips')
            .doc(widget.travel.title)
            .collection('days')
            .doc('day$_selectedDay')
            .collection('activities')
            .doc(activity.id)
            .delete();
      }
    });
  }

  Widget _buildDayWidget(int day) {
    bool isSelected = day == _selectedDay;
    DateTime actualDate = widget.travel.startDate.add(Duration(days: day - 1));
    int actualDay = actualDate.day;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDay = day;
          loadDatabaseData();
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? const Color(0xfb3a78b1) : Colors.transparent,
          border: Border.all(
            color: const Color(0xfb3a78b1),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Center(
          child: Text(
            actualDay.toString(),
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(width: 16.0),
                const Text(
                  'Trip activities',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xffb3a78b1),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(widget.travel.duration.inDays, (index) {
                final day = index + 1;
                return _buildDayWidget(day);
              }),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.travel.duration.inDays,
              itemBuilder: (context, index) {
                final day = index + 1;
                final activitiesForDay = _activities
                    .where((activity) => activity.day == day)
                    .toList();

                return Visibility(
                  visible: _selectedDay == day,
                  maintainState: true,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          'Day $day',
                          style: const TextStyle(
                              color: Color(0xffb3a78b1),
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            _showAddActivityDialog(day);
                          },
                        ),
                      ),
                      Column(
                        children: activitiesForDay
                            .map(
                              (activity) => ListTile(
                                title: Text(capitalize(activity.title),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w200)),
                                subtitle: Text(
                                  activity.time.toString().substring(11, 16),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w200),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        _showEditActivityDialog(activity);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        _deleteActivity(activity);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddActivityDialog(int day) {
    String title = '';
    DateTime time = DateTime.now();
    TimeOfDay pickedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Add an activity'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    onChanged: (value) {
                      title = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter the title of the activity',
                      labelText: 'Title',
                    ),
                  ),
                  ListTile(
                    title: const Text('Time'),
                    subtitle: Text('${pickedTime.hour}:${pickedTime.minute}'),
                    onTap: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: pickedTime,
                      );
                      if (picked != null) {
                        setState(() {
                          pickedTime = picked;
                          time = DateTime(
                            time.year,
                            time.month,
                            time.day,
                            picked.hour,
                            picked.minute,
                          );
                        });
                      }
                    },
                  ),
                  // ElevatedButton(
                  //   onPressed: _pickImage,
                  //   child: const Text('Add Image'),
                  // ),
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
                    _addActivity(title, time);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditActivityDialog(Activity activity) {
    TextEditingController titleController =
        TextEditingController(text: activity.title);
    DateTime newTime = activity.time;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Activity'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Enter the new title',
                  labelText: 'Title',
                ),
              ),
              ListTile(
                title: const Text('Time'),
                subtitle: Text('${newTime.hour}:${newTime.minute}'),
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(newTime),
                  );
                  if (picked != null) {
                    setState(() {
                      newTime = DateTime(
                        newTime.year,
                        newTime.month,
                        newTime.day,
                        picked.hour,
                        picked.minute,
                      );
                    });
                  }
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
                _editActivity(activity, titleController.text, newTime);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class Activity {
  String title;
  DateTime time;
  int day;
  String? id;

  Activity(
      {required this.title,
      required this.time,
      required this.day,
      required this.id});
}
