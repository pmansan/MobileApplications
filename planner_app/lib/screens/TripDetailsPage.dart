import 'package:flutter/material.dart';
import 'package:planner_app/screens/Models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


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
            final time = data['time'].toDate();
            Activity activity = Activity(title: title, time: time, day: _selectedDay);
            loadedActivities.add(activity);
          });

          setState(() {
            _activities = loadedActivities;
            _activitiesMap[_selectedDay] = loadedActivities; // Almacenar las actividades en el mapa
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
      Activity activity = Activity(title: title, time: time, day: _selectedDay);
      _activities.add(activity);
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
            .add({
          'title': title,
          'time': time,
        });
      }
    });
  }

  //se construye un widget para representar un día en la interfaz de usuario
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
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        width: 40.0,
        height: 40.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.blue : Colors.transparent,
          border: Border.all(
            color: Colors.blue,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Center(
          child: Text(
            actualDay.toString(),
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  @override
  //construye y devuelve la interfaz de usuario de la página de detalles del viaje
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.travel.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.travel.description,
              style: TextStyle(fontSize: 18),
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
                        title: Text('Day $day'),
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
                                title: Text(activity.title),
                                subtitle: Text(activity.time
                                    .toString()
                                    .substring(11,
                                        16)), // muestra solo horas y minutos
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

  // Muestra un cuadro de diálogo para agregar una nueva actividad
  void _showAddActivityDialog(int day) {
    String title = '';
    DateTime time = DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                subtitle: Text('${time.hour}:${time.minute}'),
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
              ),
            ],
          ),
          actions: <Widget>[
            //boton para cancelar y cerrar cuadro de dialogo
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            //boton para agregar actividad
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
  }
}
