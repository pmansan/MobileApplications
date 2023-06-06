import 'package:flutter/material.dart';
import 'package:planner_app/components/round_button.dart';
import 'package:planner_app/components/search_bar.dart';
import 'package:planner_app/screens/Profile.dart';
import 'package:planner_app/screens/createTrip.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

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
      appBar: null,
      // no app bar

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title text
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
                ], //Children
              ),
            ),

            // Search bar
            SearchBar(
              controller: passwordController,
              hintText: 'Search...',
              //obscureText: true,
            ),

            const SizedBox(height: 190),

            //Text si no hay ningún trip (cambiar a que si hay se ponga directamente la foto y)
            const Text(
              'Create a new trip',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 145),

            // add trip button
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
                              builder: (context) => CreateTripPage()));
                    },
                  ),
                ], //Children
              ),
            ),

            //Home and profile icons buttons
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
