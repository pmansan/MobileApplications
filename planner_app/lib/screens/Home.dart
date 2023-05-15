import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planner_app/components/round_button.dart';
import 'package:planner_app/components/search_bar.dart';
import 'package:intl/intl.dart';
import 'package:planner_app/screens/CreateTrip.dart';
import 'package:planner_app/screens/Profile.dart';
//import 'package:planner_app/components/square_tile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class Travel {
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  // final Image? cover;

  Travel({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    
  });
}

//lista de viajes
class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  List<Travel> _travels = [];

  //para lo de la fecha aaaaaaaaa
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  String? imagePath;


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
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0), // Cambia el valor para ajustar los radios de las esquinas
            ),
          title: const Text('Add a new travel',style: TextStyle(fontFamily: 'Nunito', color: Color(0xffb3a78b1)),
          ),
          content:  SingleChildScrollView(
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  title = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter the name of the travel',
                  labelText: 'Title' ,
                  labelStyle: TextStyle(
                    fontFamily: 'Nunito', 
                  ),
                  hintStyle: TextStyle(
                    fontFamily: 'Nunito', 
                  ),
                ),
              ),
              TextField(
                onChanged: (value) {
                  description = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter a description of the travel',
                  labelText: 'Description',
                  labelStyle: TextStyle(
                    fontFamily: 'Nunito', 
                  ),
                  hintStyle: TextStyle(
                    fontFamily: 'Nunito', 
                  ),
                ),
              ),
              Row(
              children: [
                Expanded(child: ListTile(
                contentPadding: const EdgeInsets.only(top:5.0),
                title: const Text('Start Date',
                style: TextStyle(
                fontFamily: 'Nunito', 
                color: Color.fromARGB(255, 124, 123, 123)
              ),),
                subtitle: TextFormField(
                    controller: _startDateController,
                    enabled: false,
                    ),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: startDate,
                    firstDate: DateTime(2015),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    setState(() {
                      _startDateController.text = DateFormat('yyyy-MM-dd').format(picked);
                    });
                };
              })),
              Expanded( child: ListTile(
                contentPadding: const EdgeInsets.only(top:5.0),
                title: const Text('End Date',
                style: TextStyle(
                fontFamily: 'Nunito',
                color: Color.fromARGB(255, 124, 123, 123) 
              ),),
                 subtitle: TextFormField(
                              
                    controller: _endDateController,
                    enabled: false, // Si no quieres que el campo sea editable
                    ),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: endDate,
                    firstDate: DateTime(2015),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    setState(() {
                       _endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
                    });
                };
               }
               ))]),
               Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                        style:  ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)), // Ajusta la altura según tus preferencias
                        backgroundColor: MaterialStatePropertyAll<Color>(Colors.grey.shade200),
                        ),
                        child: Icon(Icons.camera_alt_outlined, color: Colors.grey[500],),
                        // const Text('Load image cover'), 
                        ////////////////////////////////////////// IMAGE PICKER
                        onPressed: () async {
                          final ImagePicker _picker = ImagePicker();
                          PickedFile _pickedfile = 
                            await _picker.getImage(source: ImageSource.gallery);
                          imagePath = _pickedfile.path;

                          // _pickedfile.readAsBytes().then((value){})
                        } ,
                ////////////////////////////////////////// IMAGE PICKER
                      )),
            ],
          )),
          actions: <Widget>[
            TextButton(
              
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel',
              style: TextStyle(
                fontFamily: 'Nunito',
                color: Color(0xffb3a78b1) 
              ),),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color(0xffb3a78b1)), // Cambia el color de fondo
              ),
              onPressed: () {
                Travel travel = Travel(
                  title: title,
                  description: description,
                  startDate: startDate,
                  endDate: endDate,
                  // image: 
                  
                );
                _addTravel(travel);
                Navigator.of(context).pop();
              },
              child: const Text('Save',
              style: TextStyle(
                fontFamily: 'Nunito', 
              ),),
            ),
          ],
        );
      },
    );
  }

  //pagina
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: null,
      // no app bar

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title text
            Padding(
              padding: const EdgeInsets.only(left: 30.0, bottom: 15, top: 30),
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
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.bold),
                  ),
                ], //Children
              ),
            ),

            // Search bar
            SearchBar(
              controller: searchController,
              hintText: 'Search...',
              // obscureText: true,
            ),

            const SizedBox(height: 150),

            //Text si no hay ningún trip (cambiar a que si hay se ponga directamente la foto y)
            Expanded(
              child: ListView.builder(
                itemCount: _travels.length,
                itemBuilder: (context, index) {
                  // Para cada elemento de la lista se crea un ListTile con la info
                  return ListTile(
                    title: Text(_travels[index].title),
                    subtitle: Text(_travels[index].description),
                    trailing: Text(
                        '${_travels[index].startDate.day}/${_travels[index].startDate.month}/${_travels[index].startDate.year} - ${_travels[index].endDate.day}/${_travels[index].endDate.month}/${_travels[index].endDate.year}'),
                  );
                },
              ),
            ),

            const SizedBox(height: 115),

            // add trip button
            Padding(
              padding: const EdgeInsets.only(right: 20.0, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                verticalDirection: VerticalDirection.down,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                      width: 75,
                      height: 75,
                      child: FloatingActionButton(
                        onPressed: _showAddTravelDialog,
                        backgroundColor: Color(0xffb3a78b1),
                        foregroundColor: Colors.white,
                        elevation: 4.0,
                        child: Icon(Icons.add_rounded, size: 70),
                      ),
                    )
                  // FloatingActionButton(
                  //   onPressed: _showAddTravelDialog,
                  //   backgroundColor: Color(0xffb3a78b1),
                  //   foregroundColor: Colors.white,
                  //   child: Icon(Icons.add_rounded, color: Colors.white,size: 70,),

                  // ),
                ], //Children
              ),
            ),

            //Home and profile icons buttons
            Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 50, bottom: 10),
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
                  // Icon(Icons.home_outlined,color: Colors.grey,size: 70,),
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
                ], //Children
              ),
            ),
          ], //children
        ),
      ),
    );
    ;
  }
}
