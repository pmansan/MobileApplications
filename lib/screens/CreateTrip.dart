import 'package:flutter/material.dart';
import 'package:planner_app/screens/Home.dart';
import '../components/my_textfield.dart';

class CreateTripPage extends StatelessWidget {
  CreateTripPage({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  

  // sign user in method
  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Color(0xffb3a78b1),
            size: 35 //change your color here
            ),
        backgroundColor: Colors.white,
        elevation: 0,
         ),

      body: SafeArea(

          child: Column(
            
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

                //Title Create your trip
                Padding(
                  padding: const EdgeInsets.only(left: 30.0,bottom: 15 ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    verticalDirection: VerticalDirection.down,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [

                      Text('Create your trip',
                        style: TextStyle(
                        color: Color(0xfb3a78b1),
                        fontSize: 28,
                        fontWeight: FontWeight.bold
                        ),
                      ),
                    ], //Children
                  ),
                ),
              
              // title text
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      'Title',
                      style: TextStyle(color: Color(0xfb3a78b1), 
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 15),

              // title textfield
              MyTextField(
                controller: usernameController,
                hintText: 'e.g Trip to Spain... ',
                obscureText: false,
              ),

    
                   
              const SizedBox(height: 10),

              // description text
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      'Description',
                      style: TextStyle(color: Color(0xfb3a78b1), 
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 10),

              // description textfield 
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: 
                SizedBox (
                  width: 500, // <-- TextField width
                  height: 90,
                  child: TextField(
                  // controller: ,
                  obscureText: false,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      // hintText: hintText,
                      hintStyle: TextStyle(color: Colors.grey[500])),
                ),
                ),
            ),

            // dates text
            Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 10),
                  child: Row(children: const [
                    Text(
                                'Starts',
                                style: TextStyle(color: Color(0xfb3a78b1), 
                                fontSize: 18,
                                fontWeight: FontWeight.normal),
                              ),
                  
                  SizedBox(width: 125),
                  Text(
                            'Ends',
                            style: TextStyle(color: Color(0xfb3a78b1), 
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                          ),
                  ]
                  )
                    ),

            // dates textfield
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical:5),
                child: Row(children: [
                SizedBox (
                  width: 170, // <-- TextField width
                  height: 50,
                  child: TextField(
                  // controller: ,
                  obscureText: false,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      prefixIcon: const Icon(Icons.calendar_month),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      hintText: '02/04/2023',
                      hintStyle: TextStyle(color: Colors.grey[500])),
                  ),
                ),
                const SizedBox(width: 20,),
                SizedBox (
                  width: 170, // <-- TextField width
                  height: 50,
                  child: TextField(
                    // controller: ,
                    obscureText: false,
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        prefixIcon: const Icon(Icons.calendar_month),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: '02/04/2023',
                        hintStyle: TextStyle(color: Colors.grey[500])),
                      ),
                    ),
            
            ],)
            ),

            Padding(
                  padding: const EdgeInsets.only(left: 30.0,bottom: 10),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        'Trip cover (Optional)',
                        style: TextStyle(color: Color(0xfb3a78b1), 
                        fontSize: 18,
                        fontWeight: FontWeight.normal),
                      ),

                    ],
                  ),
              ),        
            Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: 
                    SizedBox (
                      width: 500, // <-- TextField width
                      height: 80,
                      child: TextField(
                      // controller: ,
                      obscureText: false,
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          prefixIcon: const Icon(Icons.camera_alt_outlined),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          // hintText: hintText,
                          hintStyle: TextStyle(color: Colors.grey[500])),
                        ),
                      ),
                ),
              
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>HomePage()),
                    );
                  },
              child: Container(
                padding: const EdgeInsets.all(25),
                margin: const EdgeInsets.symmetric(horizontal: 25,vertical: 20),
                decoration: BoxDecoration(
                  color:  Color(0xffb3a78b1),
                  borderRadius: BorderRadius.circular(50),
                  ),
                child: const Center(
                  child: Text(
                    "Create trip",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            )
            
            ], //children
          ),
        ),
      )  
     ;
  ;
}

}