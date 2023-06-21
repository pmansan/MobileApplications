import 'package:flutter/material.dart';
import 'package:planner_app/screens/Models.dart';

class TripDetailsPage extends StatefulWidget {
  final Travel travel;

  const TripDetailsPage({required this.travel});

  @override
  _TripDetailsPageState createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends State<TripDetailsPage> {
  List<Activity> _activities = [];
  int _selectedDay = 1;

  void _addActivity(String title, DateTime time) {
    setState(() {
      Activity activity = Activity(title: title, time: time, day: _selectedDay);
      _activities.add(activity);
      _activities.sort((a, b) => a.time.compareTo(b.time));
    });
  }

  void _editActivity(Activity activity, String newTitle, DateTime newTime) {
    setState(() {
      activity.title = newTitle;
      activity.time = newTime;
      _activities.sort((a, b) => a.time.compareTo(b.time));
    });
  }

  void _deleteActivity(Activity activity) {
    setState(() {
      _activities.remove(activity);
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
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        width: 60.0,
        height: 60.0,
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
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 16.0),
                Text(
                  'Trip activities',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
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
                                subtitle: Text(
                                    activity.time.toString().substring(11, 16)),
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

  Activity({
    required this.title,
    required this.time,
    required this.day,
  });
}
