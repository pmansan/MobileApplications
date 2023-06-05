import 'package:flutter/material.dart';
import 'package:planner_app/components/round_button.dart';
import 'package:planner_app/screens/CreateActivity.dart';

class ActivitiesListPage extends StatelessWidget {
  ActivitiesListPage({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      // appBar: null,
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Color(0xffb3a78b1), size: 35 //change your color here
            ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // title text
            Padding(
              padding: const EdgeInsets.only(left: 30.0, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                verticalDirection: VerticalDirection.down,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Trip activities',
                    style: TextStyle(
                        color: Color(0xfb3a78b1),
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                ], //Children
              ),
            ),

            //days buttons (hay que hacer algo para que se añadan day 1, day 2, day 3 y que se ponga abajo las fechas que se han puesto)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Row(
                children: [
                  SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      onPressed: () {
                        // Acción al hacer clic en el botón
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffC3DAF2),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 30),
                          elevation: 0,
                          foregroundColor: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          // Espacio entre el icono y el texto
                          Text("Day 1",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      onPressed: () {
                        // Acción al hacer clic en el botón
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffECEAEA),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 30),
                          elevation: 0,
                          foregroundColor:
                              const Color.fromARGB(255, 142, 146, 151)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          // Espacio entre el icono y el texto
                          Text("Day 2",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 150),

            // text
            const Text(
              'Create a new activity',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 150),

            //plus button to add activity
            Padding(
              padding: const EdgeInsets.only(right: 20.0, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                verticalDirection: VerticalDirection.down,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RoundButton(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateActivityPage()));
                    },
                  )
                ], //Children
              ),
            ),
          ], //children
        ),
      ),
    );
  }
}
