import 'package:flutter/material.dart';
import 'package:planner_app/screens/Home.dart';
import 'package:planner_app/screens/Start.dart';
import 'package:planner_app/services/auth.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService _auth = AuthService();

  // sign user in method
  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        // No app bar
        appBar: null,
        body: SafeArea(
          // background mage
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('lib/images/BackgroundProfile.png'),
              fit: BoxFit.cover,
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Title text
                Padding(
                  padding:
                      const EdgeInsets.only(left: 30.0, bottom: 20, top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    verticalDirection: VerticalDirection.down,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Your profile',
                        style: TextStyle(
                            color: Color(0xfb3a78b1),
                            fontFamily: 'Nunito',
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                    ], //Children
                  ),
                ),

                //Profile image (tenemos que conseguir que se pueda cambiar subiendola, para eso hay que quitar el const)
                const CircleAvatar(
                  //backgroundImage: NetworkImage(
                  //   'https://img.freepik.com/foto-gratis/mujer-hermosa-joven-mirando-camara-chica-moda-verano-casual-camiseta-blanca-pantalones-cortos-hembra-positiva-muestra-emociones-faciales-modelo-divertido-aislado-amarillo_158538-15796.jpg'),
                  radius:
                      70.0, // El radio determina el tamaño de la imagen circular
                ),

                const SizedBox(height: 10),

                const Text(
                  'Name',
                  style: TextStyle(
                      color: Color(0xfb3a78b1),
                      fontFamily: 'Nunito',
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 50),

                const Divider(
                  thickness: 1, // Establecer el grosor de la línea
                  color: Colors.grey,
                  indent: 30,
                  endIndent: 30,
                  // Establecer el color de la línea
                ),

                //Edit button
                SizedBox(
                  width: 350,
                  child: ElevatedButton(
                    onPressed: () {
                      // Acción al hacer clic en el botón
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.only(
                            left: 0, right: 80, top: 20, bottom: 20),
                        elevation: 0,
                        foregroundColor: Colors.grey),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          Icons.edit_note_rounded,
                          color: Colors.yellow,
                        ),
                        SizedBox(width: 5), // Espacio entre el icono y el texto
                        Text(
                          "Edit profile",
                          style: TextStyle(
                            fontFamily: 'Nunito',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Divider(
                  thickness: 1, // Establecer el grosor de la línea
                  color: Colors.grey,
                  indent: 30,
                  endIndent: 30, // Establecer el color de la línea
                ),

                // settings button
                SizedBox(
                  width: 350,
                  child: ElevatedButton(
                    onPressed: () {
                      // Acción al hacer clic en el botón
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.only(
                            left: 0, right: 80, top: 20, bottom: 20),
                        elevation: 0,
                        foregroundColor: Colors.grey),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          Icons.settings_rounded,
                          color: Colors.red,
                        ),
                        SizedBox(
                            width: 10), // Espacio entre el icono y el texto
                        Text("Settings",
                            style: TextStyle(fontFamily: 'Nunito')),
                      ],
                    ),
                  ),
                ),

                const Divider(
                  thickness: 1, // Establecer el grosor de la línea
                  color: Colors.grey,
                  indent: 30,
                  endIndent: 30, // Establecer el color de la línea
                ),

                // log out button
                InkWell(
                  onTap: () async {
                    await _auth.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StartPage()),
                    );
                    print('Succesfully signed out');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 150, vertical: 0),
                    decoration: BoxDecoration(
                      color: Color(0xffb3a78b1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Center(
                      child: Text(
                        "Log out",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),

                //Iconos de abajo (Row para que estén situados de izq a derecha)

                Padding(
                  padding:
                      const EdgeInsets.only(left: 50.0, right: 50, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    verticalDirection: VerticalDirection.up,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.home_outlined),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        },
                        iconSize: 70,
                        color: Colors.grey,
                      ),
                      // Icon(Icons.home_outlined,color: Colors.grey,size: 70,),
                      const SizedBox(width: 130),
                      IconButton(
                        icon: const Icon(Icons.person_2_outlined),
                        onPressed: () {},
                        iconSize: 70,
                        color: const Color(0xffb3a78b1),
                      ),
                    ], //Children
                  ),
                ),
              ], //children
            ),
          ),
        ));
    ;
  }
}
