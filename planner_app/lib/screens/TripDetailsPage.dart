import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planner_app/screens/Models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class TripDetailsPage extends StatefulWidget {
  final Travel travel;

  const TripDetailsPage({required this.travel});

  @override
  _TripDetailsPageState createState() => _TripDetailsPageState();
}

class DashedLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 4.0;
        final dashHeight = 1.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();

        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xfb3a78b1),
                ),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
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
            final price=data['price'];
            Activity activity =
                Activity(title: title, time: time, day: _selectedDay, price: price, id: id);
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

  void _addActivity(String title, DateTime time, double price) {
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
          price: price,
          id: docRef.id, // Asignar el ID generado automáticamente por Firestore
        );

        _activities.add(activity);
        _activities.sort((a, b) => a.time.compareTo(b.time));

        docRef.set({
          'title': title,
          'time': time,
          'price': price,
        });
        
      }
    });
  }

  void _editActivity(
      Activity activity, String newTitle, DateTime newTime, double newPrice) {
    setState(() {
      activity.title = newTitle;
      activity.time = newTime;
      activity.price = newPrice;
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
          'price': newPrice,
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
    String actualMonth = DateFormat('MMMM').format(actualDate);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDay = day;
          loadDatabaseData();
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: isSelected ? const Color(0xfb3a78b1) : Colors.transparent,
          border: Border.all(
            color: const Color(0xfb3a78b1),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Day $day',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14.0,
              ),
            ),
            Text(
              '$actualMonth ${actualDate.day}',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 18.0,
              ),
            ),
          ],
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
            padding: const EdgeInsets.symmetric(vertical:30.0, horizontal: 10),
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
                    color: Color(0xfb3a78b1),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  List.generate(widget.travel.duration.inDays + 1, (index) {
                final day = index + 1;
                return _buildDayWidget(day);
              }),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.travel.duration.inDays + 1,
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
                        children: activitiesForDay.asMap().entries.map((entry) {
                          final index = entry.key;
                          final activity = entry.value;
                          final isLastActivity =
                              index == activitiesForDay.length - 1;

                          return Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 40.0),
                                child: ListTile(
                                  title: Row(
                                    children: [
                                      Text(
                                        '${activity.time.toString().substring(11, 16)}',
                                        style: TextStyle(
                                          color: Color(0xfb3a78b1),
                                        ),
                                      ),
                                      SizedBox(width: 8.0),
                                      Text(activity.title),
                                    ],
                                  ),
                                  subtitle: Text(
                                    'Price: ${activity.price.toStringAsFixed(2)}€',
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
                              ),
                              Positioned(
                                top: 12.0,
                                left: 12.0,
                                child: Container(
                                  width: 20.0,
                                  height: 20.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xfb3a78b1),
                                  ),
                                ),
                              ),
                              if (!isLastActivity)
                                Positioned(
                                  top: 42.0,
                                  left: 22.0,
                                  bottom: 0,
                                  width: 2.0,
                                  child: Container(
                                    color: Color(0xfb3a78b1),
                                    child: DashedLine(),
                                  ),
                                ),
                            ],
                          );
                        }).toList(),
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
    double price = 0.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add an activity',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0xfb3a78b1),
            ),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Title',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xfb3a78b1),
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                          onChanged: (value) {
                            title = value;
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter the title of the activity',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(12.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Time',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xfb3a78b1),
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.all(12.0),
                        child: GestureDetector(
                          onTap: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(time),
                            );
                            if (picked != null) {
                              setState(() {
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
                          child: Text(
                            '${time.hour}:${time.minute}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price (€)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xfb3a78b1),
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                          onChanged: (value) {
                            price = double.tryParse(value) ?? 0.0;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter the price in euros',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(12.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
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
                _addActivity(title, time, price);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showEditActivityDialog(Activity activity) {
    TextEditingController titleController =
        TextEditingController(text: activity.title);
    TextEditingController priceController =
        TextEditingController(text: activity.price.toString());
    DateTime newTime = activity.time;
    double newPrice = activity.price;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Edit Activity',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0xfb3a78b1),
            ),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Title',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xfb3a78b1),
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            hintText: 'Enter the new title',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(12.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Time',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xfb3a78b1),
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: GestureDetector(
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
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              '${newTime.hour}:${newTime.minute}',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price (€)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xfb3a78b1),
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                          controller: priceController,
                          onChanged: (value) {
                            newPrice = double.tryParse(value) ?? 0.0;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter the price in euros',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(12.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
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
                _editActivity(
                    activity, titleController.text, newTime, newPrice);
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
  double price;
  final id ;

  Activity({
    required this.title,
    required this.time,
    required this.day,
    required this.price,
    required this.id,
  });
}
