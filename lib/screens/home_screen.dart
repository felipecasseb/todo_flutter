import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/screens/form_screen.dart';
import 'package:todo_flutter/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: ()async{
                await auth.signOut();
               Navigator.pushReplacement(
                   context,
                   MaterialPageRoute(builder: (context) => LoginScreen())
               );
              },
              icon: Icon(Icons.exit_to_app)
          )
        ],
      ),
      body: Center(child: ElevatedButton(
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => FormScreen())
          );
        },
        child: Text("Novo produto"),
      ),),
    );
  }
}
