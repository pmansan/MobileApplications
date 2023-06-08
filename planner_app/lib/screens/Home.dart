import 'package:flutter/material.dart';
import 'package:planner_app/components/round_button.dart';
import 'package:planner_app/components/search_bar.dart';
import 'package:planner_app/screens/CreateTrip.dart';
import 'package:planner_app/screens/Profile.dart';
import 'package:planner_app/screens/TripDetailsPage.dart';
import 'package:planner_app/screens/Models.dart';

//clase de pantalla principal
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

//lista de viajes
class _HomePageState extends State<HomePage> {
  final passwordController = TextEditingController();
  List<Travel> _travels = [];

  void _addTravel(Travel travel) {
    setState(() {
      _travels.add(travel);
    });
  }

//ventana emergente
  void _showAddTravelDialog() {
    String title = '';
    String description = '';
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a new travel'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  title = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter the name of the travel',
                  labelText: 'Title',
                ),
              ),
              TextField(
                onChanged: (value) {
                  description = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter a description of the travel',
                  labelText: 'Description',
                ),
              ),
              ListTile(
                //fecha inicio
                title: const Text('Start Date'),
                subtitle: Text('${startDate.toLocal()}'.split(' ')[0]),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: startDate,
                    firstDate: DateTime(2015),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != startDate)
                    setState(() {
                      startDate = picked;
                    });
                },
              ),
              ListTile(
                //fecha final
                title: const Text('End Date'),
                subtitle: Text('${endDate.toLocal()}'.split(' ')[0]),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: endDate,
                    firstDate: DateTime(2015),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != endDate)
                    setState(() {
                      endDate = picked;
                    });
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
            //boton para añadir viaje
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
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

//pagina en si
  @override
  Widget build(BuildContext context) {
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
            //barra de busqueda
            SearchBar(
              controller: passwordController,
              hintText: 'Search...',
            ),
            const SizedBox(height: 190),
            Expanded(
              //aqui se verá la lista de viajes
              child: ListView.builder(
                itemCount: _travels.length,
                itemBuilder: (context, index) {
                  //cada elemento de la lista es un ListTile
                  return ListTile(
                    title: Text(_travels[index].title),
                    subtitle: Text(_travels[index].description),
                    trailing: Text(
                      '${_travels[index].startDate.day}/${_travels[index].startDate.month}/${_travels[index].startDate.year} - ${_travels[index].endDate.day}/${_travels[index].endDate.month}/${_travels[index].endDate.year}',
                    ),
                    // Al hacer clic en el ListTile, se navega a la página de detalles del viaje
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
            const SizedBox(height: 145),
            Padding(
              padding: const EdgeInsets.only(right: 20.0, bottom: 10),
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
                    iconSize: 70,
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
                    iconSize: 70,
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
