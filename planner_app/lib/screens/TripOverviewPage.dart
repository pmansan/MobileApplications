import 'dart:io';

import 'package:flutter/material.dart';
import 'package:planner_app/screens/Models.dart';
import 'package:planner_app/screens/TripDetailsPage.dart';

class TripOverviewPage extends StatelessWidget {
  final Travel travel;
  final pickedimage;

  const TripOverviewPage({required this.travel, required this.pickedimage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 2.5 / 6,
            // color: const Color(0xffb3a78b1),
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(80),
              image: DecorationImage(
                  image: travel.imageURL != null && travel.imageURL != 'null'
                      ? NetworkImage(travel.imageURL!)
                      : pickedimage != null
                          ? FileImage(File(pickedimage!.path))
                          : const AssetImage('lib/images/blue.png')
                              as ImageProvider<Object>,
                  // image: AssetImage('lib/images/amsterdam.jpg'),
                  fit: BoxFit.fill),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${travel.startDate.day}${_getDaySuffix(travel.startDate.day)} ${_getMonthAbbreviation(travel.startDate.month)}-${travel.endDate.day}${_getDaySuffix(travel.endDate.day)} ${_getMonthAbbreviation(travel.endDate.month)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          capitalize(travel.title),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffb3a78b1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    capitalize(travel.description),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 1 / 6,
            color: Colors.white,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TripDetailsPage(travel: travel),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: const Color(0xffb3a78b1),
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  textStyle: TextStyle(fontSize: 18.0),
                ),
                child: Text('View Activities'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }

    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String _getMonthAbbreviation(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }
}
